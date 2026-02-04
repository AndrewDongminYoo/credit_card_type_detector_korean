// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_bin.model.freezed.dart';
part 'card_bin.model.g.dart';

@freezed
/// A single row of the Korean BIN database.
///
/// Each instance represents one card-number prefix and its associated
/// issuer, brand, and product metadata as recorded in the upstream
/// BIN table CSV.
sealed class CardBinModel with _$CardBinModel {
  const factory CardBinModel({
    /// 순번
    @JsonKey(name: '순번') required int id,

    /// 발급사
    @JsonKey(name: '발급사') required String cardIssuer,

    /// BIN
    @JsonKey(name: 'BIN') required String bin,

    /// 전표인자명
    @JsonKey(name: '전표인자명') required String factorName,

    /// 개인/법인
    @JsonKey(name: '개인/법인') required String corporate,

    /// 브랜드
    @JsonKey(name: '브랜드') required String brand,

    /// 신용/체크
    @JsonKey(name: '신용/체크') required String creditDebit,

    /// 등록/수정일자
    @JsonKey(name: '등록/수정일자') String? updatedAt,

    /// 변경사항
    @JsonKey(name: '변경사항') String? changed,

    /// 비고
    @JsonKey(name: '비고') String? remarks,
  }) = _CardBinModel;

  factory CardBinModel.fromJson(Map<String, dynamic> json) => _$CardBinModelFromJson(json);
}
