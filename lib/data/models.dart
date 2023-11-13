import 'package:credit_card_type_detector_korean/data/constants.dart';

/// 신용 카드 유형과 해당 브랜드에 사용되는 패턴 및 일반적인 보안 코드를 포함하여 특정 카드 브랜드에 대한 일반 정보를 나타냅니다.
class CreditCardType {

  CreditCardType(this.type, this.prettyType, this.lengths, this.patterns,
      this.securityCode,);

  /// 기본값을 사용하여 Visa 카드 유형을 생성합니다.
  CreditCardType.visa()
      : type = TYPE_VISA,
        prettyType = PRETTY_VISA,
        lengths = ccNumLengthDefaults[TYPE_VISA]!,
        patterns = cardNumPatternDefaults[TYPE_VISA]!,
        securityCode = ccSecurityCodeDefaults[TYPE_VISA]!;

  /// 기본값을 사용하여 Master Card 카드 유형을 생성합니다.
  CreditCardType.mastercard()
      : type = TYPE_MASTERCARD,
        prettyType = PRETTY_MASTERCARD,
        lengths = ccNumLengthDefaults[TYPE_MASTERCARD]!,
        patterns = cardNumPatternDefaults[TYPE_MASTERCARD]!,
        securityCode = ccSecurityCodeDefaults[TYPE_MASTERCARD]!;

  /// 기본값을 사용하여 American Express 카드 유형을 생성합니다.
  CreditCardType.americanExpress()
      : type = TYPE_AMEX,
        prettyType = PRETTY_AMEX,
        lengths = ccNumLengthDefaults[TYPE_AMEX]!,
        patterns = cardNumPatternDefaults[TYPE_AMEX]!,
        securityCode = ccSecurityCodeDefaults[TYPE_AMEX]!;

  /// 기본값을 사용하여 Discover 카드 유형을 생성합니다.
  CreditCardType.discover()
      : type = TYPE_DISCOVER,
        prettyType = PRETTY_DISCOVER,
        lengths = ccNumLengthDefaults[TYPE_DISCOVER]!,
        patterns = cardNumPatternDefaults[TYPE_DISCOVER]!,
        securityCode = ccSecurityCodeDefaults[TYPE_DISCOVER]!;

  /// 기본값을 사용하여 Diners Club 카드 유형을 생성합니다.
  CreditCardType.dinersClub()
      : type = TYPE_DINERS_CLUB,
        prettyType = PRETTY_DINERS_CLUB,
        lengths = ccNumLengthDefaults[TYPE_DINERS_CLUB]!,
        patterns = cardNumPatternDefaults[TYPE_DINERS_CLUB]!,
        securityCode = ccSecurityCodeDefaults[TYPE_DINERS_CLUB]!;

  /// 기본값을 사용하여 JCB 카드 유형을 생성합니다.
  CreditCardType.jcb()
      : type = TYPE_JCB,
        prettyType = PRETTY_JCB,
        lengths = ccNumLengthDefaults[TYPE_JCB]!,
        patterns = cardNumPatternDefaults[TYPE_JCB]!,
        securityCode = ccSecurityCodeDefaults[TYPE_JCB]!;

  /// 기본값을 사용하여 UnionPay 카드 유형을 생성합니다.
  CreditCardType.unionPay()
      : type = TYPE_UNIONPAY,
        prettyType = PRETTY_UNIONPAY,
        lengths = ccNumLengthDefaults[TYPE_UNIONPAY]!,
        patterns = cardNumPatternDefaults[TYPE_UNIONPAY]!,
        securityCode = ccSecurityCodeDefaults[TYPE_UNIONPAY]!;

  /// 기본값을 사용하여 Maestro 카드 유형을 생성합니다.
  CreditCardType.maestro()
      : type = TYPE_MAESTRO,
        prettyType = PRETTY_MAESTRO,
        lengths = ccNumLengthDefaults[TYPE_MAESTRO]!,
        patterns = cardNumPatternDefaults[TYPE_MAESTRO]!,
        securityCode = ccSecurityCodeDefaults[TYPE_MAESTRO]!;

  /// 기본값을 사용하여 Elo 카드 유형을 생성합니다.
  CreditCardType.elo()
      : type = TYPE_ELO,
        prettyType = PRETTY_ELO,
        lengths = ccNumLengthDefaults[TYPE_ELO]!,
        patterns = cardNumPatternDefaults[TYPE_ELO]!,
        securityCode = ccSecurityCodeDefaults[TYPE_ELO]!;

  /// 기본값을 사용하여 Mir 카드 유형을 생성합니다.
  CreditCardType.mir()
      : type = TYPE_MIR,
        prettyType = PRETTY_MIR,
        lengths = ccNumLengthDefaults[TYPE_MIR]!,
        patterns = cardNumPatternDefaults[TYPE_MIR]!,
        securityCode = ccSecurityCodeDefaults[TYPE_MIR]!;

  /// 기본값을 사용하여 Hiper 카드 유형을 생성합니다.
  CreditCardType.hiper()
      : type = TYPE_HIPER,
        prettyType = PRETTY_HIPER,
        lengths = ccNumLengthDefaults[TYPE_HIPER]!,
        patterns = cardNumPatternDefaults[TYPE_HIPER]!,
        securityCode = ccSecurityCodeDefaults[TYPE_HIPER]!;

  /// 기본값을 사용하여 Hipercard 카드 유형을 만듭니다.
  CreditCardType.hipercard()
      : type = TYPE_HIPER,
        prettyType = PRETTY_HIPER,
        lengths = ccNumLengthDefaults[TYPE_HIPER]!,
        patterns = cardNumPatternDefaults[TYPE_HIPER]!,
        securityCode = ccSecurityCodeDefaults[TYPE_HIPER]!;

  final String type;
  final String prettyType;
  final List<int> lengths;
  final Set<Pattern> patterns;
  SecurityCode securityCode;
  int matchStrength = 0;

  /// 카드 유형에 새 패턴 추가
  void addPattern(Pattern pattern) {
    patterns.add(pattern);
  }

  /// 다음에 대한 보안 코드 정보 변경
  void updateSecurityCode(SecurityCode securityCode) {
    this.securityCode = securityCode;
  }

  @override
  bool operator ==(Object other) =>
    other is CreditCardType &&
      type == other.type &&
          prettyType == other.prettyType &&
          lengths == other.lengths &&
          patterns == other.patterns &&
          securityCode == other.securityCode;

  @override
  int get hashCode =>
      Object.hash(type, prettyType, lengths, patterns, securityCode);
}

/// 신용 카드 번호 패턴이 가질 수 있는 다양한 패턴을 나타냅니다.
/// 대부분 특정 브랜드에 대해 카드 번호에 사용할 수 있는 접두사를 캡슐화합니다.
class Pattern {

  Pattern(this.prefixes);
  /// 카드 번호가 시작하는 값의 범위의 하한과 상한. 즉, `['51', '55']`는 '51'로 시작하는 카드부터 '55'로 시작하는 카드까지를 나타냅니다.
  final List<String> prefixes;

  void addPrefix(String prefix) {
    prefixes.add(prefix);
  }

  @override
  bool operator ==(Object other) =>
      other is Pattern && prefixes == other.prefixes;

  @override
  int get hashCode => Object.hashAll(prefixes);
}

class SecurityCode {

  SecurityCode(this.name, this.length);

  /// 표준 CVV를 기반으로 보안 코드를 생성합니다.
  const SecurityCode.cvv()
      : name = SEC_CODE_CVV,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// 표준 CVC를 기반으로 보안 코드를 만듭니다.
  const SecurityCode.cvc()
      : name = SEC_CODE_CVC,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// 3자리로 구성된 표준 CID를 기반으로 보안 코드를 만듭니다.
  const SecurityCode.cid3()
      : name = SEC_CODE_CID,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// 4자리 표준 CID를 기반으로 보안 코드를 생성합니다.
  const SecurityCode.cid4()
      : name = SEC_CODE_CID,
        length = ALT_SECURITY_CODE_LENGTH;

  /// 표준 CVN을 기반으로 보안 코드를 만듭니다.
  const SecurityCode.cvn()
      : name = SEC_CODE_CVN,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// 표준 CVE를 기반으로 보안 코드를 만듭니다.
  const SecurityCode.cve()
      : name = SEC_CODE_CVE,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  /// 표준 CVP2를 기반으로 보안 코드를 만듭니다.
  const SecurityCode.cvp2()
      : name = SEC_CODE_CVP2,
        length = DEFAULT_SECURITY_CODE_LENGTH;

  final String name;
  final int length;

  @override
  bool operator ==(Object other) =>
    other is SecurityCode &&
      name == other.name && length == other.length;

  @override
  int get hashCode => Object.hash(name, length);
}

class CardCollection {

  CardCollection(this.cards);
  CardCollection.empty() : cards = {};
  factory CardCollection.from(CardCollection other) {
    final c = CardCollection.empty();
    c.cards.addAll(other.cards);
    return c;
  }
  final Map<String, CreditCardType> cards;

  CreditCardType? getCardType(String cardName) {
    return cards[cardName];
  }

  void addCardType(String key, CreditCardType cardType) {
    if (cards.containsKey(key)) {
      throw Exception(
          'The card "$key" already exists in this collection. Use `updateCardType()` instead',);
    } else {
      cards[key] = cardType;
    }
  }

  void updateCardType(String key, CreditCardType cardType) {
    cards[key] = cardType;
  }

  CreditCardType? removeCard(String key) {
    return cards.remove(key);
  }
}
