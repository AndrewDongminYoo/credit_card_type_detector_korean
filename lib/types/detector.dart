import 'package:credit_card_type_detector_korean/types/constants.dart';
import 'package:credit_card_type_detector_korean/types/models.dart';

final CardCollection _defaultCCTypes = CardCollection({
  TYPE_VISA: CreditCardType.visa(),
  TYPE_MASTERCARD: CreditCardType.mastercard(),
  TYPE_AMEX: CreditCardType.americanExpress(),
  TYPE_DISCOVER: CreditCardType.discover(),
  TYPE_DINERS_CLUB: CreditCardType.dinersClub(),
  TYPE_JCB: CreditCardType.jcb(),
  TYPE_UNIONPAY: CreditCardType.unionPay(),
  TYPE_MAESTRO: CreditCardType.maestro(),
  TYPE_ELO: CreditCardType.elo(),
  TYPE_HIPER: CreditCardType.hiper(),
  TYPE_HIPERCARD: CreditCardType.hipercard(),
});

CardCollection _customCards = CardCollection.from(_defaultCCTypes);

/// 숫자가 아닌 문자를 찾습니다.
RegExp _nonNumeric = RegExp(r'\D+');

/// 모든 형태의 공백을 찾습니다.
RegExp _whiteSpace = RegExp(r'\s+\b|\b\s');

/// 이 함수는 카드 패턴을 기반으로 잠재적인 CC 유형을 결정합니다.
/// 가장 가능성이 높은 유형을 첫 번째 유형으로 하는 `CreditCardType` 목록을 반환합니다.
List<CreditCardType> detectCCType(String ccNumStr) {
  final cardTypes = <CreditCardType>[];
  // ignore: parameter_assignments
  ccNumStr = ccNumStr.replaceAll(_whiteSpace, '');

  if (ccNumStr.isEmpty) {
    return _customCards.cards.values.toList();
  }

  /// 문자열에 숫자만 있는지 확인합니다.
  if (_nonNumeric.hasMatch(ccNumStr)) {
    return cardTypes;
  }

  _customCards.cards.forEach(
    (String cardName, CreditCardType type) {
      for (final pattern in type.patterns) {
        /// 공백을 모두 제거합니다.
        var ccPatternStr = ccNumStr;
        final patternLen = pattern.prefixes[0].length;

        /// 패턴 접두사 길이와 일치하도록 CC 번호 문자열을 자릅니다.
        if (patternLen < ccNumStr.length) {
          ccPatternStr = ccPatternStr.substring(0, patternLen);
        }

        if (pattern.prefixes.length > 1) {
          /// 접두사 범위를 숫자로 변환한 다음 CC 번호가 패턴 범위에 있는지 확인합니다.
          /// 문자열에는 '>=' 타입 연산자가 없기 때문입니다.
          final ccPrefixAsInt = int.parse(ccPatternStr);
          final startPatternPrefixAsInt = int.parse(pattern.prefixes[0]);
          final endPatternPrefixAsInt = int.parse(pattern.prefixes[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt &&
              ccPrefixAsInt <= endPatternPrefixAsInt) {
            /// 일치하는 항목 발견
            type.matchStrength = _determineMatchStrength(
              ccNumStr,
              pattern.prefixes[0],
            );
            cardTypes.add(type);
            break;
          }
        } else {
          /// 단일 패턴 접두사와 CC 접두사를 비교하기만 하면 됩니다.
          if (ccPatternStr == pattern.prefixes[0]) {
            /// 일치하는 항목 발견
            type.matchStrength = _determineMatchStrength(
              ccNumStr,
              pattern.prefixes[0],
            );
            cardTypes.add(type);
            break;
          }
        }
      }
    },
  );

  cardTypes.sort((a, b) => b.matchStrength.compareTo(a.matchStrength));
  return cardTypes;
}

int _determineMatchStrength(String ccNumStr, String patternPrefix) {
  if (ccNumStr.length >= patternPrefix.length) {
    return patternPrefix.length;
  } else {
    return 0;
  }
}

/// `cardName`과 연관된 `신용 카드 유형` 객체를 가져옵니다.
CreditCardType? getCardType(String cardName) {
  return _customCards.getCardType(cardName);
}

/// 카드 컬렉션에 사용자 지정 카드 유형을 추가합니다.
///
/// `cardName`이 이미 컬렉션에 있는 경우 `Exception`을 던집니다.
void addCardType(String cardName, CreditCardType type) {
  _customCards.addCardType(cardName, type);
}

/// 카드 컬렉션에서 `cardName`의 카드 유형을 업데이트합니다.
void updateCardType(String cardName, CreditCardType type) {
  _customCards.updateCardType(cardName, type);
}

/// 카드 컬렉션에서 `cardName`을 제거합니다.
void removeCardType(String cardName) {
  final _ = _customCards.removeCard(cardName);
}

/// 카드 컬렉션을 기본 카드 유형으로 재설정합니다.
void resetCardTypes() {
  _customCards = CardCollection.from(_defaultCCTypes);
}
