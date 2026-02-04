// ignore_for_file: lines_longer_than_80_chars

// 📦 Package imports:
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:credit_card_type_detector_korean/credit_card_type_detector_korean.dart';
import 'package:credit_card_type_detector_korean/src/data.dart';

void main() {
  const detector = CreditCardTypeDetectorKorean();

  group('CreditCardTypeDetectorKorean', () {
    test('can be instantiated', () {
      expect(detector, isNotNull);
    });

    // ─── detect ────────────────────────────────────────────────────────────

    group('detect - known BIN', () {
      test('returns matching CardBinModel for BIN 200001 (Shinhan)', () {
        final results = detector.detect('200001');
        expect(results, isNotEmpty);
        expect(results[0].bin, '200001');
        expect(results[0].cardIssuer, '신한카드');
        expect(results[0].brand, '로컬');
        expect(results[0].corporate, '개인');
        expect(results[0].creditDebit, '신용');
      });

      test('works with a full 16-digit card number', () {
        final results = detector.detect('2000011234567890');
        expect(results, isNotEmpty);
        expect(results[0].bin, '200001');
      });

      test('works with spaces inside the number', () {
        final results = detector.detect('2000 01 1234 5678 90');
        expect(results, isNotEmpty);
        expect(results[0].bin, '200001');
      });

      test('works with exactly 6 digits', () {
        final results = detector.detect('200001');
        expect(results, isNotEmpty);
      });

      test('matches 8-digit BIN (Hyundai Amex corporate)', () {
        final results = detector.detect('37466402');
        expect(results, isNotEmpty);
        expect(results[0].bin, '37466402');
        expect(results[0].cardIssuer, '현대카드');
        expect(results[0].brand, '아멕스');
        expect(results[0].corporate, '법인');
      });

      test('matches 8-digit BIN embedded in a full card number', () {
        final results = detector.detect('3746640212345678');
        expect(results, isNotEmpty);
        expect(results[0].bin, '37466402');
      });
    });

    group('detect - unknown or invalid input', () {
      test('returns empty for a BIN not in the dataset', () {
        final results = detector.detect('000000');
        expect(results, isEmpty);
      });

      test('returns empty for an empty string', () {
        expect(detector.detect(''), isEmpty);
      });

      test('returns empty for fewer than 6 digits', () {
        expect(detector.detect('12345'), isEmpty);
      });

      test('returns empty for non-numeric input', () {
        expect(detector.detect('abcdef'), isEmpty);
      });

      test('returns empty for mixed alpha-numeric shorter than 6 digits', () {
        expect(detector.detect('ab12cd'), isEmpty);
      });
    });

    group('detect - index consistency', () {
      test('every unique BIN in data is reachable via detect', () {
        final uniqueBins = data.map((CardBinModel m) => m.bin).toSet();
        for (final bin in uniqueBins) {
          final results = detector.detect(bin);
          expect(results, isNotEmpty, reason: 'BIN $bin not found in index');
        }
      });

      test('total reachable entries equals data length (no silent drops)', () {
        final uniqueBins = data.map((CardBinModel m) => m.bin).toSet();
        var total = 0;
        for (final bin in uniqueBins) {
          total += detector.detect(bin).length;
        }
        expect(total, data.length);
      });

      test('returned list is unmodifiable', () {
        final results = detector.detect('200001');
        expect(() => results.add(results[0]), throwsUnsupportedError);
      });
    });

    // ─── detectCard ─────────────────────────────────────────────────────────

    group('detectCard - combined result', () {
      test('purely international card returns internationalTypes only', () {
        // 4111111111111111 is a standard Visa test number not in the Korean BIN table.
        final result = detector.detectCard('4111111111111111');
        expect(result.koreanBins, isEmpty);
        expect(result.internationalTypes, isNotEmpty);
        expect(result.internationalTypes[0].type, 'visa');
      });

      test('domestic-only card (로컬) returns koreanBins, empty internationalTypes', () {
        // BIN 200001 — Shinhan 로컬; prefix 200001 matches no international pattern.
        final result = detector.detectCard('2000011234567890');
        expect(result.koreanBins, isNotEmpty);
        expect(result.koreanBins[0].brand, '로컬');
        expect(result.internationalTypes, isEmpty);
      });

      test('Korean card with international brand returns both', () {
        // BIN 40022351 — BC카드 비자; prefix 4… matches Visa internationally.
        final result = detector.detectCard('4002235112345678');
        expect(result.koreanBins, isNotEmpty);
        expect(result.koreanBins[0].bin, '40022351');
        expect(result.koreanBins[0].brand, '비자');
        expect(result.internationalTypes, isNotEmpty);
        expect(result.internationalTypes[0].type, 'visa');
      });

      test('both result lists are unmodifiable', () {
        final result = detector.detectCard('4002235112345678');
        expect(() => result.koreanBins.add(result.koreanBins[0]), throwsUnsupportedError);
        expect(() => result.internationalTypes.add(result.internationalTypes[0]), throwsUnsupportedError);
      });

      test('completely unknown number returns empty on both sides', () {
        final result = detector.detectCard('0000001234567890');
        expect(result.koreanBins, isEmpty);
        expect(result.internationalTypes, isEmpty);
      });
    });

    // ─── findBy* query methods ──────────────────────────────────────────────

    group('findByIssuer', () {
      test('returns non-empty result for 신한카드, all entries match', () {
        final results = detector.findByIssuer(CARD_ISSUER_SHINHAN);
        expect(results, isNotEmpty);
        expect(results, everyElement(predicate<CardBinModel>((m) => m.cardIssuer == CARD_ISSUER_SHINHAN)));
      });

      test('returns non-empty result for 현대카드, all entries match', () {
        final results = detector.findByIssuer(CARD_ISSUER_HYUNDAI);
        expect(results, isNotEmpty);
        expect(results, everyElement(predicate<CardBinModel>((m) => m.cardIssuer == CARD_ISSUER_HYUNDAI)));
      });

      test('returns empty for unknown issuer', () {
        expect(detector.findByIssuer('존재하지않는발급사'), isEmpty);
      });
    });

    group('findByBrand', () {
      test('returns non-empty result for 로컬, all entries match', () {
        final results = detector.findByBrand(TYPE_LOCAL_KO);
        expect(results, isNotEmpty);
        expect(results, everyElement(predicate<CardBinModel>((m) => m.brand == TYPE_LOCAL_KO)));
      });

      test('returns non-empty result for 아멕스, all entries match', () {
        final results = detector.findByBrand(TYPE_AMEX_KO);
        expect(results, isNotEmpty);
        expect(results, everyElement(predicate<CardBinModel>((m) => m.brand == TYPE_AMEX_KO)));
      });

      test('returns empty for unknown brand', () {
        expect(detector.findByBrand('존재하지않는브랜드'), isEmpty);
      });
    });

    group('findByCardType', () {
      test('returns non-empty result for 신용, all entries match', () {
        final results = detector.findByCardType(CREDIT_CARD);
        expect(results, isNotEmpty);
        expect(results, everyElement(predicate<CardBinModel>((m) => m.creditDebit == CREDIT_CARD)));
      });

      test('returns non-empty result for 기프트, all entries match', () {
        final results = detector.findByCardType(GIFT_CARD);
        expect(results, isNotEmpty);
        expect(results, everyElement(predicate<CardBinModel>((m) => m.creditDebit == GIFT_CARD)));
      });

      test('returns empty for unknown card type', () {
        expect(detector.findByCardType('존재하지않는종류'), isEmpty);
      });
    });

    group('findByCorporate', () {
      test('returns non-empty result for 개인, all entries match', () {
        final results = detector.findByCorporate(CARD_TYPE_INDIVIDUAL);
        expect(results, isNotEmpty);
        expect(results, everyElement(predicate<CardBinModel>((m) => m.corporate == CARD_TYPE_INDIVIDUAL)));
      });

      test('returns non-empty result for 법인, all entries match', () {
        final results = detector.findByCorporate(CARD_TYPE_CORPORATE);
        expect(results, isNotEmpty);
        expect(results, everyElement(predicate<CardBinModel>((m) => m.corporate == CARD_TYPE_CORPORATE)));
      });

      test('returns empty for unknown corporate type', () {
        expect(detector.findByCorporate('존재하지않는유형'), isEmpty);
      });
    });

    // ─── detect edge cases ──────────────────────────────────────────────────

    group('detect - separator & whitespace', () {
      test('dash-separated card number is normalised correctly', () {
        // 200001-xxxx-xxxx-xxxx → BIN 200001 (Shinhan)
        final results = detector.detect('200001-1234-5678-9012');
        expect(results, isNotEmpty);
        expect(results[0].bin, '200001');
        expect(results[0].cardIssuer, '신한카드');
      });

      test('tab characters are stripped', () {
        final results = detector.detect('200001\t1234\t5678');
        expect(results, isNotEmpty);
        expect(results[0].bin, '200001');
      });

      test('mixed separators (spaces, dashes, tabs) are all stripped', () {
        final results = detector.detect('2000\t01-12 34-5678');
        expect(results, isNotEmpty);
        expect(results[0].bin, '200001');
      });
    });

    group('detect - 8-digit BIN takes priority over overlapping 6-digit BIN', () {
      // BIN 45992700 (현대카드 비자) shares its first 6 digits with BIN 459927 (신한카드 비자).
      // The detector must return the 8-digit (more specific) match.
      test('8-digit BIN 45992700 wins over 6-digit BIN 459927', () {
        final results = detector.detect('4599270012345678');
        expect(results, isNotEmpty);
        expect(results[0].bin, '45992700');
        expect(results[0].cardIssuer, '현대카드');
      });

      test('exact 8-digit input returns the 8-digit match', () {
        final results = detector.detect('45992700');
        expect(results, isNotEmpty);
        expect(results[0].bin, '45992700');
      });

      test('6-digit-only input returns the 6-digit match when 8-digit cannot match', () {
        // Only 6 digits provided → cannot match 8-digit BIN; falls back to 459927 (신한카드).
        final results = detector.detect('459927');
        expect(results, isNotEmpty);
        expect(results[0].bin, '459927');
        expect(results[0].cardIssuer, '신한카드');
      });
    });

    // ─── CardBinModel serialization ─────────────────────────────────────────

    group('CardBinModel serialization', () {
      test('fromJson round-trip preserves all required fields', () {
        final json = <String, dynamic>{
          '순번': 1,
          '발급사': '신한카드',
          'BIN': '200001',
          '전표인자명': 'SHINHAN',
          '개인/법인': '개인',
          '브랜드': '로컬',
          '신용/체크': '신용',
        };
        final model = CardBinModel.fromJson(json);
        expect(model.id, 1);
        expect(model.cardIssuer, '신한카드');
        expect(model.bin, '200001');
        expect(model.factorName, 'SHINHAN');
        expect(model.corporate, '개인');
        expect(model.brand, '로컬');
        expect(model.creditDebit, '신용');
        expect(model.updatedAt, isNull);
        expect(model.changed, isNull);
        expect(model.remarks, isNull);
      });

      test('fromJson round-trip preserves optional fields when present', () {
        final json = <String, dynamic>{
          '순번': 99,
          '발급사': '현대카드',
          'BIN': '37466402',
          '전표인자명': 'HYUNDAI',
          '개인/법인': '법인',
          '브랜드': '아멕스',
          '신용/체크': '신용',
          '등록/수정일자': '2025-01-15',
          '변경사항': '신규',
          '비고': '테스트용',
        };
        final model = CardBinModel.fromJson(json);
        expect(model.updatedAt, '2025-01-15');
        expect(model.changed, '신규');
        expect(model.remarks, '테스트용');
      });

      test('toJson produces keys matching Korean column names', () {
        final json = <String, dynamic>{
          '순번': 1,
          '발급사': '신한카드',
          'BIN': '200001',
          '전표인자명': 'SHINHAN',
          '개인/법인': '개인',
          '브랜드': '로컬',
          '신용/체크': '신용',
        };
        final model = CardBinModel.fromJson(json);
        final roundTripped = model.toJson();
        expect(roundTripped['순번'], 1);
        expect(roundTripped['발급사'], '신한카드');
        expect(roundTripped['BIN'], '200001');
        expect(roundTripped['신용/체크'], '신용');
      });
    });

    group('findBy* - consistency', () {
      test('all issuers sum to data.length', () {
        final issuers = data.map((CardBinModel m) => m.cardIssuer).toSet();
        var total = 0;
        for (final issuer in issuers) {
          total += detector.findByIssuer(issuer).length;
        }
        expect(total, data.length);
      });

      test('all brands sum to data.length', () {
        final brands = data.map((CardBinModel m) => m.brand).toSet();
        var total = 0;
        for (final brand in brands) {
          total += detector.findByBrand(brand).length;
        }
        expect(total, data.length);
      });

      test('all card types sum to data.length', () {
        final cardTypes = data.map((CardBinModel m) => m.creditDebit).toSet();
        var total = 0;
        for (final cardType in cardTypes) {
          total += detector.findByCardType(cardType).length;
        }
        expect(total, data.length);
      });

      test('all corporate categories sum to data.length', () {
        final corporates = data.map((CardBinModel m) => m.corporate).toSet();
        var total = 0;
        for (final corp in corporates) {
          total += detector.findByCorporate(corp).length;
        }
        expect(total, data.length);
      });

      test('all findBy results are unmodifiable', () {
        final issuerResult = detector.findByIssuer(CARD_ISSUER_SHINHAN);
        expect(() => issuerResult.add(issuerResult[0]), throwsUnsupportedError);

        final brandResult = detector.findByBrand(TYPE_LOCAL_KO);
        expect(() => brandResult.add(brandResult[0]), throwsUnsupportedError);

        final cardTypeResult = detector.findByCardType(CREDIT_CARD);
        expect(() => cardTypeResult.add(cardTypeResult[0]), throwsUnsupportedError);

        final corporateResult = detector.findByCorporate(CARD_TYPE_INDIVIDUAL);
        expect(() => corporateResult.add(corporateResult[0]), throwsUnsupportedError);
      });
    });
  });
}
