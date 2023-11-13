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

  factory CardBinModel.fromJson(Map<String, dynamic> json) => CardBinModel(
        id: json['순번']! as int,
        cardIssuer: cardIssuerValues.map[json['발급사']]!,
        bin: json['BIN']! as String,
        factorName: json['전표인자명'] as String,
        corporate: corporateValues.map[json['개인/법인']]!,
        brand: brandValues.map[json['브랜드']]!,
        creditDebit: creditDebitValues.map[json['신용/체크']]!,
        updatedAt: json['등록/수정일자'] == null
            ? null
            : updatedAtValues.map[json['등록/수정일자']],
        changed:
            json['변경사항'] == null ? null : changedValues.map[json['변경사항']],
        remarks:
            json['비고'] == null ? null : remarksValues.map[json['비고']],
      );

  int id;
  CardIssuer cardIssuer;
  String bin;
  String factorName;
  Corporate corporate;
  Brand brand;
  CreditDebit creditDebit;
  UpdatedAt? updatedAt;
  Changed? changed;
  Remarks? remarks;

  Map<String, dynamic> toJson() => {
        '순번': id,
        '발급사': cardIssuerValues.reverse[cardIssuer],
        'BIN': bin,
        '전표인자명': factorName,
        '개인/법인': corporateValues.reverse[corporate],
        '브랜드': brandValues.reverse[brand],
        '신용/체크': creditDebitValues.reverse[creditDebit],
        '등록/수정일자':
            updatedAt == null ? null : updatedAtValues.reverse[updatedAt],
        '변경사항': changed == null ? null : changedValues.reverse[changed],
        '비고': remarks == null ? null : remarksValues.reverse[remarks],
      };
}

enum UpdatedAt { THE_202310, THE_202210, THE_202301, THE_202304, THE_202307 }

final updatedAtValues = EnumValues({
  '2022. 10': UpdatedAt.THE_202210,
  '2023. 01': UpdatedAt.THE_202301,
  '2023. 04': UpdatedAt.THE_202304,
  '2023. 07': UpdatedAt.THE_202307,
  '2023. 10': UpdatedAt.THE_202310,
});

enum Corporate { INDIVIDUAL, CORPORATE }

final corporateValues = EnumValues({
  '개인': Corporate.INDIVIDUAL,
  '법인': Corporate.CORPORATE,
});

enum Changed { UPDATED, CREATED, DELETED }

final changedValues = EnumValues({
  '변경': Changed.UPDATED,
  '삭제': Changed.DELETED,
  '신규': Changed.CREATED,
});

enum CreditDebit { Credit, Debit, GiftCard }

final creditDebitValues = EnumValues({
  '신용': CreditDebit.Credit,
  '기프트': CreditDebit.GiftCard,
  '체크': CreditDebit.Debit,
});

enum CardIssuer {
  BC,
  CITI,
  DREAM,
  HANA,
  HYUNDAI,
  JB,
  JEJU,
  KB,
  KWANGJU,
  LOTTE,
  NH,
  SAMSUNG,
  SHINHAN,
  SUHYUP,
  WOORI,
}

final cardIssuerValues = EnumValues({
  'BC카드': CardIssuer.BC,
  'KB국민카드': CardIssuer.KB,
  'NH농협카드': CardIssuer.NH,
  '광주은행': CardIssuer.KWANGJU,
  '롯데카드': CardIssuer.LOTTE,
  '삼성카드': CardIssuer.SAMSUNG,
  '수협은행': CardIssuer.SUHYUP,
  '신한카드': CardIssuer.SHINHAN,
  '씨티카드': CardIssuer.CITI,
  '우리카드': CardIssuer.WOORI,
  '전북은행': CardIssuer.JB,
  '제주은행': CardIssuer.JEJU,
  '지드림카드': CardIssuer.DREAM,
  '하나카드': CardIssuer.HANA,
  '현대카드': CardIssuer.HYUNDAI,
});

enum Remarks { WOORI_BC }

final remarksValues = EnumValues({
  '우리BC카드': Remarks.WOORI_BC,
});

enum Brand { LOCAL, MASTER, JCB, DINERS, AMEX, VISA, UNION }

final brandValues = EnumValues({
  '로컬': Brand.LOCAL,
  '다이너스': Brand.DINERS,
  '은련': Brand.UNION,
  'JCB': Brand.JCB,
  '마스터': Brand.MASTER,
  '비자': Brand.VISA,
  '아멕스': Brand.AMEX,
});

class EnumValues<T> {
  EnumValues(this.map);

  Map<String, T> map;
  Map<T, String>? reverseMap;

  Map<T, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
