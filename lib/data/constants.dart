import 'package:credit_card_type_detector_korean/data/models.dart';

/// CVV 또는 보안 코드의 기본 길이(대부분의 카드가 이 길이를 사용함)
const int DEFAULT_SECURITY_CODE_LENGTH = 3;

/// 보안 코드의 대체 길이
const int ALT_SECURITY_CODE_LENGTH = 4;

/// 미리 정의된 보안 코드 이름
const String SEC_CODE_CVV = 'CVV';
const String SEC_CODE_CVC = 'CVC';
const String SEC_CODE_CID = 'CID';
const String SEC_CODE_CVN = 'CVN';
const String SEC_CODE_CVE = 'CVE';
const String SEC_CODE_CVP2 = 'CVP2';

/// 미리 정의된 카드 브랜드
const String TYPE_VISA = 'visa';
const String TYPE_MASTERCARD = 'mastercard';
const String TYPE_AMEX = 'american_express';
const String TYPE_DISCOVER = 'discover';
const String TYPE_DINERS_CLUB = 'diners_club';
const String TYPE_JCB = 'jcb';
const String TYPE_UNIONPAY = 'unionpay';
const String TYPE_MAESTRO = 'maestro';
const String TYPE_ELO = 'elo';
const String TYPE_MIR = 'mir';
const String TYPE_HIPER = 'hiper';
const String TYPE_HIPERCARD = 'hipercard';

/// 미리 정의된 예쁜 인쇄 카드 브랜드
const String PRETTY_VISA = 'Visa';
const String PRETTY_MASTERCARD = 'Mastercard';
const String PRETTY_AMEX = 'American Express';
const String PRETTY_DISCOVER = 'Discover';
const String PRETTY_DINERS_CLUB = "Diner's Club";
const String PRETTY_JCB = 'JCB';
const String PRETTY_UNIONPAY = 'UnionPay';
const String PRETTY_MAESTRO = 'Maestro';
const String PRETTY_ELO = 'Elo';
const String PRETTY_MIR = 'Mir';
const String PRETTY_HIPER = 'Hiper';
const String PRETTY_HIPERCARD = 'Hipercard';

/// 사용 가능한 신용 카드 유형과 각각의 사용 가능한 카드 번호 길이 기본값 매핑
const Map<String, List<int>> ccNumLengthDefaults = {
  TYPE_VISA: [16, 18, 19],
  TYPE_MASTERCARD: [16],
  TYPE_AMEX: [15],
  TYPE_DISCOVER: [16, 19],
  TYPE_DINERS_CLUB: [14, 16, 19],
  TYPE_JCB: [16, 17, 18, 19],
  TYPE_UNIONPAY: [14, 15, 16, 17, 18, 19],
  TYPE_MAESTRO: [12, 13, 14, 15, 16, 17, 18, 19],
  TYPE_ELO: [16],
  TYPE_MIR: [16, 17, 18, 19],
  TYPE_HIPER: [16],
  TYPE_HIPERCARD: [16],
};

/// 사용 가능한 신용 카드 유형과 해당 보안 코드 기본값 매핑
const Map<String, SecurityCode> ccSecurityCodeDefaults = {
  TYPE_VISA: SecurityCode.cvv(),
  TYPE_MASTERCARD: SecurityCode.cvc(),
  TYPE_AMEX: SecurityCode.cid4(),
  TYPE_DISCOVER: SecurityCode.cid3(),
  TYPE_DINERS_CLUB: SecurityCode.cvv(),
  TYPE_JCB: SecurityCode.cvv(),
  TYPE_UNIONPAY: SecurityCode.cvn(),
  TYPE_MAESTRO: SecurityCode.cvc(),
  TYPE_ELO: SecurityCode.cve(),
  TYPE_MIR: SecurityCode.cvp2(),
  TYPE_HIPER: SecurityCode.cvc(),
  TYPE_HIPERCARD: SecurityCode.cvc(),
};

/// [List<String>]은 범위를 나타냅니다.
/// 즉, ['51', '55']는 '51'로 시작하는 카드부터 '55'로 시작하는 카드의 범위를 나타냅니다.
Map<String, Set<Pattern>> cardNumPatternDefaults = {
  TYPE_VISA: {
    Pattern(const ['4']),
  },
  TYPE_MASTERCARD: {
    Pattern(const ['51', '55']),
    Pattern(const ['2221', '2229']),
    Pattern(const ['223', '229']),
    Pattern(const ['23', '26']),
    Pattern(const ['270', '271']),
    Pattern(const ['2720']),
  },
  TYPE_AMEX: {
    Pattern(const ['34']),
    Pattern(const ['37']),
  },
  TYPE_DISCOVER: {
    Pattern(const ['6011']),
    Pattern(const ['644', '649']),
    Pattern(const ['65']),
  },
  TYPE_DINERS_CLUB: {
    Pattern(const ['300', '305']),
    Pattern(const ['36']),
    Pattern(const ['38']),
    Pattern(const ['39']),
  },
  TYPE_JCB: {
    Pattern(const ['3528', '3589']),
    Pattern(const ['2131']),
    Pattern(const ['1800']),
  },
  TYPE_UNIONPAY: {
    Pattern(const ['620']),
    Pattern(const ['624', '626']),
    Pattern(const ['62100', '62182']),
    Pattern(const ['62184', '62187']),
    Pattern(const ['62185', '62197']),
    Pattern(const ['62200', '62205']),
    Pattern(const ['622010', '622999']),
    Pattern(const ['622018']),
    Pattern(const ['622019', '622999']),
    Pattern(const ['62207', '62209']),
    Pattern(const ['622126', '622925']),
    Pattern(const ['623', '626']),
    Pattern(const ['6270']),
    Pattern(const ['6272']),
    Pattern(const ['6276']),
    Pattern(const ['627700', '627779']),
    Pattern(const ['627781', '627799']),
    Pattern(const ['6282', '6289']),
    Pattern(const ['6291']),
    Pattern(const ['6292']),
    Pattern(const ['810']),
    Pattern(const ['8110', '8131']),
    Pattern(const ['8132', '8151']),
    Pattern(const ['8152', '8163']),
    Pattern(const ['8164', '8171']),
  },
  TYPE_MAESTRO: {
    Pattern(const ['493698']),
    Pattern(const ['500000', '506698']),
    Pattern(const ['506779', '508999']),
    Pattern(const ['56', '59']),
    Pattern(const ['63']),
    Pattern(const ['67']),
  },
  TYPE_ELO: {
    Pattern(const ['401178']),
    Pattern(const ['401179']),
    Pattern(const ['438935']),
    Pattern(const ['457631']),
    Pattern(const ['457632']),
    Pattern(const ['431274']),
    Pattern(const ['451416']),
    Pattern(const ['457393']),
    Pattern(const ['504175']),
    Pattern(const ['506699', '506778']),
    Pattern(const ['509000', '509999']),
    Pattern(const ['627780']),
    Pattern(const ['636297']),
    Pattern(const ['636368']),
    Pattern(const ['650031', '650033']),
    Pattern(const ['650035', '650051']),
    Pattern(const ['650405', '650439']),
    Pattern(const ['650485', '650538']),
    Pattern(const ['650541', '650598']),
    Pattern(const ['650700', '650718']),
    Pattern(const ['650720', '650727']),
    Pattern(const ['650901', '650978']),
    Pattern(const ['651652', '651679']),
    Pattern(const ['655000', '655019']),
    Pattern(const ['655021', '655058']),
  },
  TYPE_MIR: {
    Pattern(const ['2200', '2204']),
  },
  TYPE_HIPER: {
    Pattern(const ['637095']),
    Pattern(const ['637568']),
    Pattern(const ['637599']),
    Pattern(const ['637609']),
    Pattern(const ['637612']),
    Pattern(const ['63743358']),
    Pattern(const ['63737423']),
  },
  TYPE_HIPERCARD: {
    Pattern(const ['606282']),
  },
};
