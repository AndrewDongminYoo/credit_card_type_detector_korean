// 📦 Package imports:
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

// 🌎 Project imports:
import 'package:credit_card_type_detector_korean/src/card_bin.model.dart';
import 'package:credit_card_type_detector_korean/src/card_detection_result.dart';
import 'package:credit_card_type_detector_korean/src/data.dart';

/// Builds an index over [data] keyed by the value returned by [keyFn].
Map<String, List<CardBinModel>> _buildIndex(String Function(CardBinModel) keyFn) {
  final index = <String, List<CardBinModel>>{};
  for (final model in data) {
    index.putIfAbsent(keyFn(model), () => []).add(model);
  }
  return index;
}

/// BIN → CardBinModel entries. Keys are 6 or 8 characters long.
final Map<String, List<CardBinModel>> _binIndex = _buildIndex((m) => m.bin);

/// Distinct BIN lengths present in the index, sorted descending.
/// Used for longest-prefix-first matching inside [CreditCardTypeDetectorKorean.detect].
final List<int> _binLengths = _binIndex.keys.map((k) => k.length).toSet().toList()..sort((a, b) => b.compareTo(a));

/// Card issuer name → CardBinModel entries.
final Map<String, List<CardBinModel>> _issuerIndex = _buildIndex((m) => m.cardIssuer);

/// Brand label → CardBinModel entries.
final Map<String, List<CardBinModel>> _brandIndex = _buildIndex((m) => m.brand);

/// Card type (신용 / 체크 / 기프트) → CardBinModel entries.
final Map<String, List<CardBinModel>> _cardTypeIndex = _buildIndex((m) => m.creditDebit);

/// Corporate category (개인 / 법인) → CardBinModel entries.
final Map<String, List<CardBinModel>> _corporateIndex = _buildIndex((m) => m.corporate);

/// Matches any non-digit character (whitespace, letters, punctuation, etc.).
final _nonDigit = RegExp(r'\D');

/// {@template credit_card_type_detector_korean}
/// Detects Korean domestic credit card issuers by looking up the BIN prefix
/// of a card number against the bundled BIN database.
/// BIN lengths in the current dataset are 6 or 8 digits; the most specific
/// (longest) match is returned.
/// {@endtemplate}
class CreditCardTypeDetectorKorean {
  /// {@macro credit_card_type_detector_korean}
  const CreditCardTypeDetectorKorean();

  /// Returns Korean BIN records matching [cardNumber] via longest-prefix lookup.
  ///
  /// All non-digit characters (including whitespace) are stripped before lookup.
  /// An empty list is returned when the sanitized input is shorter than the
  /// minimum BIN length (6 digits) or when no BIN record matches.
  List<CardBinModel> detect(String cardNumber) {
    final sanitized = cardNumber.replaceAll(_nonDigit, '');
    if (sanitized.length < 6) return [];

    // Longest-prefix-first: try each BIN length in descending order.
    // Returns the first match found, which corresponds to the most specific BIN.
    for (final len in _binLengths) {
      if (sanitized.length < len) continue;
      final matches = _binIndex[sanitized.substring(0, len)];
      if (matches != null) return List.unmodifiable(matches);
    }
    return [];
  }

  /// Returns a [CardDetectionResult] combining Korean BIN lookup and
  /// international brand detection for [cardNumber].
  ///
  /// Both result lists are unmodifiable. Either or both may be empty depending
  /// on whether the card matches Korean and/or international patterns.
  CardDetectionResult detectCard(String cardNumber) {
    return CardDetectionResult(
      koreanBins: detect(cardNumber),
      internationalTypes: List.unmodifiable(detectCCType(cardNumber)),
    );
  }

  /// Returns all BIN records whose issuer matches [issuer].
  ///
  /// Use the `CARD_ISSUER_*` constants (e.g. `CARD_ISSUER_SHINHAN`) as the
  /// argument. Returns an empty list when no records match.
  List<CardBinModel> findByIssuer(String issuer) {
    return List.unmodifiable(_issuerIndex[issuer] ?? []);
  }

  /// Returns all BIN records whose brand matches [brand].
  ///
  /// Use the Korean brand constants (e.g. `TYPE_VISA_KO`, `TYPE_LOCAL_KO`) as
  /// the argument. Returns an empty list when no records match.
  List<CardBinModel> findByBrand(String brand) {
    return List.unmodifiable(_brandIndex[brand] ?? []);
  }

  /// Returns all BIN records whose card type matches [cardType].
  ///
  /// Use `CREDIT_CARD`, `DEBIT_CARD`, or `GIFT_CARD` as the argument.
  /// Returns an empty list when no records match.
  List<CardBinModel> findByCardType(String cardType) {
    return List.unmodifiable(_cardTypeIndex[cardType] ?? []);
  }

  /// Returns all BIN records whose corporate category matches [corporate].
  ///
  /// Use `CARD_TYPE_INDIVIDUAL` or `CARD_TYPE_CORPORATE` as the argument.
  /// Returns an empty list when no records match.
  List<CardBinModel> findByCorporate(String corporate) {
    return List.unmodifiable(_corporateIndex[corporate] ?? []);
  }
}
