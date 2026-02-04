// 📦 Package imports:
import 'package:credit_card_type_detector/models.dart';

// 🌎 Project imports:
import 'package:credit_card_type_detector_korean/src/card_bin_model.dart';

/// Combined detection result for a single card number.
///
/// [koreanBins] contains the Korean BIN records that matched the card's prefix.
/// It is empty when the card is not a domestic Korean card.
///
/// [internationalTypes] contains the international brand classifications,
/// sorted by match strength (most likely first).
/// It is empty when no international pattern matches the card number.
///
/// Both lists are unmodifiable.
class CardDetectionResult {
  /// Creates a [CardDetectionResult] with the given [koreanBins] and
  /// [internationalTypes].
  CardDetectionResult({
    required this.koreanBins,
    required this.internationalTypes,
  });

  /// Korean BIN records matching the card number prefix.
  final List<CardBinModel> koreanBins;

  /// International brand classifications matching the card number,
  /// ordered by match strength descending.
  final List<CreditCardType> internationalTypes;
}
