// 📦 Package imports:
import 'package:credit_card_type_detector/models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'package:credit_card_type_detector_korean/src/card_bin_model.dart';

part 'card_detection_result.freezed.dart';

@freezed
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
sealed class CardDetectionResult with _$CardDetectionResult {
  /// Creates a [CardDetectionResult] with the given [koreanBins] and
  /// [internationalTypes].
  const factory CardDetectionResult({
    /// Korean BIN records matching the card number prefix.
    required List<CardBinModel> koreanBins,

    /// International brand classifications matching the card number,
    /// ordered by match strength descending.
    required List<CreditCardType> internationalTypes,
  }) = _CardDetectionResult;
}
