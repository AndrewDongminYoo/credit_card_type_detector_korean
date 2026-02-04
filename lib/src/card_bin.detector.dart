// 🌎 Project imports:
import 'package:credit_card_type_detector_korean/src/card_bin.model.dart';
import 'package:credit_card_type_detector_korean/src/data.dart';

/// Lazily-built index: BIN string → matching [CardBinModel] entries.
/// Initialized exactly once on first access.
/// Keys may be 6 or 8 characters long depending on the source data.
final Map<String, List<CardBinModel>> _binIndex = _buildBinIndex();

/// Distinct BIN lengths present in the index, sorted descending.
/// Used for longest-prefix-first matching inside [CreditCardTypeDetectorKorean.detect].
final List<int> _binLengths = _binIndex.keys.map((k) => k.length).toSet().toList()..sort((a, b) => b.compareTo(a));

Map<String, List<CardBinModel>> _buildBinIndex() {
  final index = <String, List<CardBinModel>>{};
  for (final model in data) {
    index.putIfAbsent(model.bin, () => []).add(model);
  }
  return index;
}

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
}
