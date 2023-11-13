import 'dart:convert';

List<CreditCard> creditCardFromJson(String str) {
  final jsonData = json.decode(str) as List<dynamic>;
  return List<CreditCard>.from(
    jsonData.map((x) => CreditCard.fromJson(x as Map<String, dynamic>)),
  );
}

String creditCardToJson(List<CreditCard> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class CreditCard {
  CreditCard({
    required this.id,
    required this.cardIssuer,
    required this.cardBIN,
    required this.factorName,
    required this.corpOrIndi,
    required this.brand,
    required this.creditOrDebit,
    required this.updated,
    required this.changes,
    required this.remarks,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
        id: json['순번'] as int,
        brand: creditCardBrands.map[json['브랜드']]!,
        cardBIN: json['BIN'] as int,
        cardIssuer: creditCardEnumValues.map[json['발급사']]!,
        factorName: json['전표인자명'] as String,
        corpOrIndi: individualOrCorporate.map[json['개인/법인']]!,
        creditOrDebit: purposes.map[json['신용/체크']]!,
        updated: lastModified.map[json['등록/수정일자']]!,
        changes: lastModifiedMethods.map[json['변경사항']]!,
        remarks: extras.map[json['비고']]!,
      );

  int id;
  CreditCardIssuer cardIssuer;
  int cardBIN;
  String factorName;
  CorpOrIndi corpOrIndi;
  CreditCardBrand brand;
  CardPurpose creditOrDebit;
  ModificationDate updated;
  LastMethod changes;
  Remarks remarks;

  Map<String, dynamic> toJson() => {
        '순번': id,
        '발급사': creditCardEnumValues.reverse[cardIssuer],
        'BIN': cardBIN,
        '전표인자명': factorName,
        '개인/법인': individualOrCorporate.reverse[corpOrIndi],
        '브랜드': creditCardBrands.reverse[brand],
        '신용/체크': purposes.reverse[creditOrDebit],
        '등록/수정일자': lastModified.reverse[updated],
        '변경사항': lastModifiedMethods.reverse[changes],
        '비고': extras.reverse[remarks],
      };
}

enum ModificationDate { THE_202310, THE_202210, THE_202301, THE_202304, THE_202307 }

final lastModified = EnumValues({
  '2022. 10': ModificationDate.THE_202210,
  '2023. 01': ModificationDate.THE_202301,
  '2023. 04': ModificationDate.THE_202304,
  '2023. 07': ModificationDate.THE_202307,
  '2023. 10': ModificationDate.THE_202310,
});

enum CorpOrIndi { INDIVIDUAL, CORPORATE }

final individualOrCorporate = EnumValues({
  '개인': CorpOrIndi.INDIVIDUAL,
  '법인': CorpOrIndi.CORPORATE,
});

enum LastMethod { UPDATE, DELETE, CREATE }

final lastModifiedMethods = EnumValues({
  '변경': LastMethod.UPDATE,
  '삭제': LastMethod.CREATE,
  '신규': LastMethod.DELETE,
});

enum CardPurpose { Credit, Debit, GiftCard }

final purposes = EnumValues({
  '신용': CardPurpose.Credit,
  '기프트': CardPurpose.GiftCard,
  '체크': CardPurpose.Debit,
});

enum CreditCardIssuer {
  SHINHAN,
  SAMSUNG,
  KB,
  GWANGJU,
  BC,
  NH,
  HANA,
  LOTTE,
  HYUNDAI,
  CITI,
  SUHYUP,
  JEJU,
  WOORI,
  JB,
  DREAM
}

final creditCardEnumValues = EnumValues({
  '제주은행': CreditCardIssuer.JEJU,
  'BC카드': CreditCardIssuer.BC,
  '우리카드': CreditCardIssuer.WOORI,
  '신한카드': CreditCardIssuer.SHINHAN,
  '광주은행': CreditCardIssuer.GWANGJU,
  '지드림카드': CreditCardIssuer.DREAM,
  '수협은행': CreditCardIssuer.SUHYUP,
  '씨티카드': CreditCardIssuer.CITI,
  '현대카드': CreditCardIssuer.HYUNDAI,
  'KB국민카드': CreditCardIssuer.KB,
  '전북은행': CreditCardIssuer.JB,
  'NH농협카드': CreditCardIssuer.NH,
  '삼성카드': CreditCardIssuer.SAMSUNG,
  '롯데카드': CreditCardIssuer.LOTTE,
  '하나카드': CreditCardIssuer.HANA,
});

enum Remarks { WOORI_BC }

final extras = EnumValues({
  '우리BC카드': Remarks.WOORI_BC,
});

enum CreditCardBrand { LOCAL, MASTER, JCB, DINERS, AMEX, VISA, UNION }

final creditCardBrands = EnumValues({
  '로컬': CreditCardBrand.LOCAL,
  '다이너스': CreditCardBrand.DINERS,
  '은련': CreditCardBrand.UNION,
  'JCB': CreditCardBrand.JCB,
  '마스터': CreditCardBrand.MASTER,
  '비자': CreditCardBrand.VISA,
  '아멕스': CreditCardBrand.AMEX,
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
