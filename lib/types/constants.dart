import 'package:credit_card_type_detector_korean/types/models.dart';

/// The default length of the CVV or security code (most cards do this)
const int DEFAULT_SECURITY_CODE_LENGTH = 3;

/// The alternate length of the security code
const int ALT_SECURITY_CODE_LENGTH = 4;

/// Predefined security code names
const String SEC_CODE_CVV = 'CVV';
const String SEC_CODE_CVC = 'CVC';
const String SEC_CODE_CID = 'CID';
const String SEC_CODE_CVN = 'CVN';
const String SEC_CODE_CVE = 'CVE';
const String SEC_CODE_CVP2 = 'CVP2';

/// Predefined card brands
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

/// Predefined pretty printed card brands
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

/// A mapping of possible credit card types to their respective possible
/// card number length defaults
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

/// A mapping of possible credit card types to their respective security code defaults
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

/// A [List<String>] represents a range.
/// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
Map<String, Set<NumPattern>> cardNumPatternDefaults = {
  TYPE_VISA: {
    NumPattern(const ['4']),
  },
  TYPE_MASTERCARD: {
    NumPattern(const ['51', '55']),
    NumPattern(const ['2221', '2229']),
    NumPattern(const ['223', '229']),
    NumPattern(const ['23', '26']),
    NumPattern(const ['270', '271']),
    NumPattern(const ['2720']),
  },
  TYPE_AMEX: {
    NumPattern(const ['34']),
    NumPattern(const ['37']),
  },
  TYPE_DISCOVER: {
    NumPattern(const ['6011']),
    NumPattern(const ['644', '649']),
    NumPattern(const ['65']),
  },
  TYPE_DINERS_CLUB: {
    NumPattern(const ['300', '305']),
    NumPattern(const ['36']),
    NumPattern(const ['38']),
    NumPattern(const ['39']),
  },
  TYPE_JCB: {
    NumPattern(const ['3528', '3589']),
    NumPattern(const ['2131']),
    NumPattern(const ['1800']),
  },
  TYPE_UNIONPAY: {
    NumPattern(const ['620']),
    NumPattern(const ['624', '626']),
    NumPattern(const ['62100', '62182']),
    NumPattern(const ['62184', '62187']),
    NumPattern(const ['62185', '62197']),
    NumPattern(const ['62200', '62205']),
    NumPattern(const ['622010', '622999']),
    NumPattern(const ['622018']),
    NumPattern(const ['622019', '622999']),
    NumPattern(const ['62207', '62209']),
    NumPattern(const ['622126', '622925']),
    NumPattern(const ['623', '626']),
    NumPattern(const ['6270']),
    NumPattern(const ['6272']),
    NumPattern(const ['6276']),
    NumPattern(const ['627700', '627779']),
    NumPattern(const ['627781', '627799']),
    NumPattern(const ['6282', '6289']),
    NumPattern(const ['6291']),
    NumPattern(const ['6292']),
    NumPattern(const ['810']),
    NumPattern(const ['8110', '8131']),
    NumPattern(const ['8132', '8151']),
    NumPattern(const ['8152', '8163']),
    NumPattern(const ['8164', '8171']),
  },
  TYPE_MAESTRO: {
    NumPattern(const ['493698']),
    NumPattern(const ['500000', '506698']),
    NumPattern(const ['506779', '508999']),
    NumPattern(const ['56', '59']),
    NumPattern(const ['63']),
    NumPattern(const ['67']),
  },
  TYPE_ELO: {
    NumPattern(const ['401178']),
    NumPattern(const ['401179']),
    NumPattern(const ['438935']),
    NumPattern(const ['457631']),
    NumPattern(const ['457632']),
    NumPattern(const ['431274']),
    NumPattern(const ['451416']),
    NumPattern(const ['457393']),
    NumPattern(const ['504175']),
    NumPattern(const ['506699', '506778']),
    NumPattern(const ['509000', '509999']),
    NumPattern(const ['627780']),
    NumPattern(const ['636297']),
    NumPattern(const ['636368']),
    NumPattern(const ['650031', '650033']),
    NumPattern(const ['650035', '650051']),
    NumPattern(const ['650405', '650439']),
    NumPattern(const ['650485', '650538']),
    NumPattern(const ['650541', '650598']),
    NumPattern(const ['650700', '650718']),
    NumPattern(const ['650720', '650727']),
    NumPattern(const ['650901', '650978']),
    NumPattern(const ['651652', '651679']),
    NumPattern(const ['655000', '655019']),
    NumPattern(const ['655021', '655058']),
  },
  TYPE_MIR: {
    NumPattern(const ['2200', '2204']),
  },
  TYPE_HIPER: {
    NumPattern(const ['637095']),
    NumPattern(const ['637568']),
    NumPattern(const ['637599']),
    NumPattern(const ['637609']),
    NumPattern(const ['637612']),
    NumPattern(const ['63743358']),
    NumPattern(const ['63737423']),
  },
  TYPE_HIPERCARD: {
    NumPattern(const ['606282']),
  },
};
