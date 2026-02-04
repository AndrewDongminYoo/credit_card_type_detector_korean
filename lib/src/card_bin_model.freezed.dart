// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_bin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CardBinModel {
  /// 순번
  @JsonKey(name: '순번')
  int get id;

  /// 발급사
  @JsonKey(name: '발급사')
  String get cardIssuer;

  /// BIN
  @JsonKey(name: 'BIN')
  String get bin;

  /// 전표인자명
  @JsonKey(name: '전표인자명')
  String get factorName;

  /// 개인/법인
  @JsonKey(name: '개인/법인')
  String get corporate;

  /// 브랜드
  @JsonKey(name: '브랜드')
  String get brand;

  /// 신용/체크
  @JsonKey(name: '신용/체크')
  String get creditDebit;

  /// 등록/수정일자
  @JsonKey(name: '등록/수정일자')
  String? get updatedAt;

  /// 변경사항
  @JsonKey(name: '변경사항')
  String? get changed;

  /// 비고
  @JsonKey(name: '비고')
  String? get remarks;

  /// Serializes this CardBinModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CardBinModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cardIssuer, cardIssuer) || other.cardIssuer == cardIssuer) &&
            (identical(other.bin, bin) || other.bin == bin) &&
            (identical(other.factorName, factorName) || other.factorName == factorName) &&
            (identical(other.corporate, corporate) || other.corporate == corporate) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.creditDebit, creditDebit) || other.creditDebit == creditDebit) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.changed, changed) || other.changed == changed) &&
            (identical(other.remarks, remarks) || other.remarks == remarks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    cardIssuer,
    bin,
    factorName,
    corporate,
    brand,
    creditDebit,
    updatedAt,
    changed,
    remarks,
  );

  @override
  String toString() {
    return 'CardBinModel(id: $id, cardIssuer: $cardIssuer, bin: $bin, factorName: $factorName, corporate: $corporate, brand: $brand, creditDebit: $creditDebit, updatedAt: $updatedAt, changed: $changed, remarks: $remarks)';
  }
}

/// @nodoc
@JsonSerializable()
class _CardBinModel implements CardBinModel {
  const _CardBinModel({
    @JsonKey(name: '순번') required this.id,
    @JsonKey(name: '발급사') required this.cardIssuer,
    @JsonKey(name: 'BIN') required this.bin,
    @JsonKey(name: '전표인자명') required this.factorName,
    @JsonKey(name: '개인/법인') required this.corporate,
    @JsonKey(name: '브랜드') required this.brand,
    @JsonKey(name: '신용/체크') required this.creditDebit,
    @JsonKey(name: '등록/수정일자') this.updatedAt,
    @JsonKey(name: '변경사항') this.changed,
    @JsonKey(name: '비고') this.remarks,
  });
  factory _CardBinModel.fromJson(Map<String, dynamic> json) => _$CardBinModelFromJson(json);

  /// 순번
  @override
  @JsonKey(name: '순번')
  final int id;

  /// 발급사
  @override
  @JsonKey(name: '발급사')
  final String cardIssuer;

  /// BIN
  @override
  @JsonKey(name: 'BIN')
  final String bin;

  /// 전표인자명
  @override
  @JsonKey(name: '전표인자명')
  final String factorName;

  /// 개인/법인
  @override
  @JsonKey(name: '개인/법인')
  final String corporate;

  /// 브랜드
  @override
  @JsonKey(name: '브랜드')
  final String brand;

  /// 신용/체크
  @override
  @JsonKey(name: '신용/체크')
  final String creditDebit;

  /// 등록/수정일자
  @override
  @JsonKey(name: '등록/수정일자')
  final String? updatedAt;

  /// 변경사항
  @override
  @JsonKey(name: '변경사항')
  final String? changed;

  /// 비고
  @override
  @JsonKey(name: '비고')
  final String? remarks;

  @override
  Map<String, dynamic> toJson() {
    return _$CardBinModelToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CardBinModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cardIssuer, cardIssuer) || other.cardIssuer == cardIssuer) &&
            (identical(other.bin, bin) || other.bin == bin) &&
            (identical(other.factorName, factorName) || other.factorName == factorName) &&
            (identical(other.corporate, corporate) || other.corporate == corporate) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.creditDebit, creditDebit) || other.creditDebit == creditDebit) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.changed, changed) || other.changed == changed) &&
            (identical(other.remarks, remarks) || other.remarks == remarks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    cardIssuer,
    bin,
    factorName,
    corporate,
    brand,
    creditDebit,
    updatedAt,
    changed,
    remarks,
  );

  @override
  String toString() {
    return 'CardBinModel(id: $id, cardIssuer: $cardIssuer, bin: $bin, factorName: $factorName, corporate: $corporate, brand: $brand, creditDebit: $creditDebit, updatedAt: $updatedAt, changed: $changed, remarks: $remarks)';
  }
}
