// ignore_for_file: lines_longer_than_80_chars

// 📦 Package imports:
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:credit_card_type_detector_korean/index.dart';

void main() {
  const detector = CreditCardTypeDetectorKorean();

  group('CreditCardTypeDetectorKorean', () {
    test('can be instantiated', () {
      expect(detector, isNotNull);
    });

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
        final uniqueBins = data.map((m) => m.bin).toSet();
        for (final bin in uniqueBins) {
          final results = detector.detect(bin);
          expect(results, isNotEmpty, reason: 'BIN $bin not found in index');
        }
      });

      test('total reachable entries equals data length (no silent drops)', () {
        final uniqueBins = data.map((m) => m.bin).toSet();
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
  });
}
