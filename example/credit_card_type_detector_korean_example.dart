// ignore_for_file: avoid_print

// 🌎 Project imports:
import 'package:credit_card_type_detector_korean/credit_card_type_detector_korean.dart';

void main() {
  const detector = CreditCardTypeDetectorKorean();

  // ── Korean BIN lookup ──────────────────────────────────────────────
  // Any formatting works — spaces, dashes and tabs are stripped.
  final bins = detector.detect('4002 2351 1234 5678');
  print('detect("4002 2351 1234 5678") -> ${bins.length} match(es)');
  if (bins.isNotEmpty) {
    final top = bins.first;
    print('  issuer=${top.cardIssuer}, brand=${top.brand}, bin=${top.bin}');
  }

  // ── Combined Korean + international detection ───────────────────────
  final result = detector.detectCard('4002235112345678');
  print(
    'detectCard(...) -> ${result.koreanBins.length} Korean BIN(s), '
    '${result.internationalTypes.length} international type(s)',
  );
  if (result.internationalTypes.isNotEmpty) {
    print('  international brand: ${result.internationalTypes.first.type}');
  }

  // A domestic-only card matches no international brand.
  final local = detector.detectCard('2000011234567890');
  print(
    'domestic-only -> brand=${local.koreanBins.first.brand}, '
    'international=${local.internationalTypes.length}',
  );

  // ── Query helpers ──────────────────────────────────────────────────
  print('Shinhan BINs:      ${detector.findByIssuer(CARD_ISSUER_SHINHAN).length}');
  print('Visa-branded BINs: ${detector.findByBrand(TYPE_VISA_KO).length}');
  print('Credit-card BINs:  ${detector.findByCardType(CREDIT_CARD).length}');
  print('Corporate BINs:    ${detector.findByCorporate(CARD_TYPE_CORPORATE).length}');
}
