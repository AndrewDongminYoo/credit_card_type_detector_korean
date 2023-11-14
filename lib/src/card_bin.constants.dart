import 'package:credit_card_type_detector_korean/types/constants.dart';

/// Cards issued in an individual's name
const String CARD_TYPE_INDIVIDUAL = '개인';

/// Cards issued in the name of a legal business entity
const String CARD_TYPE_CORPORATE = '법인';

const String METHOD_TYPE_UPDATED = '변경';
const String METHOD_TYPE_DELETED = '삭제';
const String METHOD_TYPE_CREATED = '신규';

const String CREDIT_CARD = '신용';
const String GIFT_CARD = '기프트';
const String DEBIT_CARD = '체크';

/// 'BC카드'
/// https://paybooc.co.kr/
const String CARD_ISSUER_BC = 'BC카드';

/// 'KB국민카드'
/// https://card.kbcard.com/
const String CARD_ISSUER_KB = 'KB국민카드';

/// 'NH농협카드'
/// https://card.nonghyup.com/
const String CARD_ISSUER_NH = 'NH농협카드';

/// '광주은행'
/// https://www.kjbank.com/
const String CARD_ISSUER_KWANGJU = '광주은행';

/// '롯데카드'
/// https://www.lottecard.co.kr/
const String CARD_ISSUER_LOTTE = '롯데카드';

/// '삼성카드'
/// https://www.samsungcard.com/
const String CARD_ISSUER_SAMSUNG = '삼성카드';

/// '수협은행'
/// https://www.suhyup-bank.com/
const String CARD_ISSUER_SUHYUP = '수협은행';

/// '신한카드'
/// https://www.shinhancard.com/
const String CARD_ISSUER_SHINHAN = '신한카드';

/// '씨티카드'
/// https://www.citibank.co.kr/
const String CARD_ISSUER_CITI = '씨티카드';

/// '우리카드'
/// https://pc.wooricard.com/
const String CARD_ISSUER_WOORI = '우리카드';

/// '전북은행'
/// https://www.jbbank.co.kr/
const String CARD_ISSUER_JB = '전북은행';

/// '제주은행'
/// https://www.e-jejubank.com/
const String CARD_ISSUER_JEJU = '제주은행';

/// '지드림카드'
/// https://gdream.gg.go.kr/
const String CARD_ISSUER_DREAM = '지드림카드';

/// '하나카드'
/// https://www.hanacard.co.kr/
const String CARD_ISSUER_HANA = '하나카드';

/// '현대카드'
/// https://www.hyundaicard.com/
const String CARD_ISSUER_HYUNDAI = '현대카드';

/// '우리BC카드'
const String CARD_ISSUER_WOORI_BC = '우리BC카드';

/// 국내 전용카드
const String TYPE_LOCAL_KO = '로컬';

/// 다이너 카드 See: [TYPE_DINERS_CLUB]
const String TYPE_DINERS_CLUB_KO = '다이너스';

/// 은련 카드 See: [TYPE_UNIONPAY]
const String TYPE_UNIONPAY_KO = '은련';

/// JCB 카드 See: [TYPE_JCB]
const String TYPE_JCB_KO = 'JCB';

/// 마스터 카드 See: [TYPE_MASTERCARD]
const String TYPE_MASTERCARD_KO = '마스터';

/// 비자 카드 See: [TYPE_VISA]
const String TYPE_VISA_KO = '비자';

/// 아멕스 카드 See: [TYPE_AMEX]
const String TYPE_AMEX_KO = '아멕스';
