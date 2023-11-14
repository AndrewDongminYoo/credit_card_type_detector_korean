class CardBinModel {
  CardBinModel({
    required this.id,
    required this.cardIssuer,
    required this.bin,
    required this.factorName,
    required this.corporate,
    required this.brand,
    required this.creditDebit,
    this.updatedAt,
    this.changed,
    this.remarks,
  });

  factory CardBinModel.fromJson(Map<String, String?> json) {
    return CardBinModel(
      id: json['순번']! as int,
      cardIssuer: json['발급사']!,
      bin: json['BIN']!,
      factorName: json['전표인자명']!,
      corporate: json['개인/법인']!,
      brand: json['브랜드']!,
      creditDebit: json['신용/체크']!,
      updatedAt: json['등록/수정일자'],
      changed: json['변경사항'],
      remarks: json['비고'],
    );
  }

  int id;
  String cardIssuer;
  String bin;
  String factorName;
  String corporate;
  String brand;
  String creditDebit;
  String? updatedAt;
  String? changed;
  String? remarks;

  Map<String, dynamic> toJson() {
    return {
      '순번': id,
      '발급사': cardIssuer,
      'BIN': bin,
      '전표인자명': factorName,
      '개인/법인': corporate,
      '브랜드': brand,
      '신용/체크': creditDebit,
      '등록/수정일자': updatedAt,
      '변경사항': changed,
      '비고': remarks,
    };
  }
}
