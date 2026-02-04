// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_bin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardBinModel _$CardBinModelFromJson(Map<String, dynamic> json) => _CardBinModel(
  id: (json['순번'] as num).toInt(),
  cardIssuer: json['발급사'] as String,
  bin: json['BIN'] as String,
  factorName: json['전표인자명'] as String,
  corporate: json['개인/법인'] as String,
  brand: json['브랜드'] as String,
  creditDebit: json['신용/체크'] as String,
  updatedAt: json['등록/수정일자'] as String?,
  changed: json['변경사항'] as String?,
  remarks: json['비고'] as String?,
);

Map<String, dynamic> _$CardBinModelToJson(_CardBinModel instance) => <String, dynamic>{
  '순번': instance.id,
  '발급사': instance.cardIssuer,
  'BIN': instance.bin,
  '전표인자명': instance.factorName,
  '개인/법인': instance.corporate,
  '브랜드': instance.brand,
  '신용/체크': instance.creditDebit,
  '등록/수정일자': ?instance.updatedAt,
  '변경사항': ?instance.changed,
  '비고': ?instance.remarks,
};
