// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_detection_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CardDetectionResult {
  /// Korean BIN records matching the card number prefix.
  List<CardBinModel> get koreanBins;

  /// International brand classifications matching the card number,
  /// ordered by match strength descending.
  List<CreditCardType> get internationalTypes;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CardDetectionResult &&
            const DeepCollectionEquality().equals(
              other.koreanBins,
              koreanBins,
            ) &&
            const DeepCollectionEquality().equals(
              other.internationalTypes,
              internationalTypes,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(koreanBins),
    const DeepCollectionEquality().hash(internationalTypes),
  );

  @override
  String toString() {
    return 'CardDetectionResult(koreanBins: $koreanBins, internationalTypes: $internationalTypes)';
  }
}

/// @nodoc

class _CardDetectionResult implements CardDetectionResult {
  const _CardDetectionResult({
    required List<CardBinModel> koreanBins,
    required List<CreditCardType> internationalTypes,
  }) : _koreanBins = koreanBins,
       _internationalTypes = internationalTypes;

  /// Korean BIN records matching the card number prefix.
  final List<CardBinModel> _koreanBins;

  /// Korean BIN records matching the card number prefix.
  @override
  List<CardBinModel> get koreanBins {
    if (_koreanBins is EqualUnmodifiableListView) return _koreanBins;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_koreanBins);
  }

  /// International brand classifications matching the card number,
  /// ordered by match strength descending.
  final List<CreditCardType> _internationalTypes;

  /// International brand classifications matching the card number,
  /// ordered by match strength descending.
  @override
  List<CreditCardType> get internationalTypes {
    if (_internationalTypes is EqualUnmodifiableListView) return _internationalTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_internationalTypes);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CardDetectionResult &&
            const DeepCollectionEquality().equals(
              other._koreanBins,
              _koreanBins,
            ) &&
            const DeepCollectionEquality().equals(
              other._internationalTypes,
              _internationalTypes,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_koreanBins),
    const DeepCollectionEquality().hash(_internationalTypes),
  );

  @override
  String toString() {
    return 'CardDetectionResult(koreanBins: $koreanBins, internationalTypes: $internationalTypes)';
  }
}
