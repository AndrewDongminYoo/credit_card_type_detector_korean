# Credit Card Type Detector Korean

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Korean domestic credit-card BIN detector built on top of
[`credit_card_type_detector`](https://pub.dev/packages/credit_card_type_detector).

Given a card number it returns matching entries from the official Korean BIN
table (신용카드 BIN\_Table), optionally combined with the international brand
detected by the upstream package.

## Installation 💻

**❗ In order to start using Credit Card Type Detector Korean you must have the [Dart SDK][dart_install_link] installed on your machine.**

Install via `dart pub add`:

```sh
dart pub add credit_card_type_detector_korean
```

---

## Usage 📖

```dart
import 'package:credit_card_type_detector_korean/index.dart';

void main() {
  final detector = CreditCardTypeDetectorKorean();

  // ── Korean BIN lookup ────────────────────────────────────────
  // Accepts any formatting — spaces, dashes, tabs are stripped automatically.
  final bins = detector.detect('4599 2700 1234 5678');
  // bins[0].cardIssuer == '현대카드'
  // bins[0].brand      == '비자'

  // ── Combined Korean + international detection ────────────────
  final result = detector.detectCard('4599270012345678');
  // result.koreanBins         — List<CardBinModel>   (Korean issuer info)
  // result.internationalTypes — List<CreditCardType> (Visa / Mastercard / …)

  // ── Query helpers ─────────────────────────────────────────────
  final shinhan = detector.findByIssuer(CARD_ISSUER_SHINHAN);
  final visaCards = detector.findByBrand(TYPE_VISA_KO);
  final creditCards = detector.findByCardType(CREDIT_CARD);
  final corporate = detector.findByCorporate(CARD_TYPE_CORPORATE);
}
```

---

## Regenerating the BIN dataset 🔄

The bundled BIN data (`lib/src/data.dart`) is generated from the upstream CSV.
When a new CSV is available, place it in the project root and run:

```sh
dart tools/generate_data.dart
```

The script auto-discovers any file matching `*BIN_Table*.csv` in the project
root and overwrites `lib/src/data.dart`.  You can also pass the path
explicitly:

```sh
dart tools/generate_data.dart path/to/신용카드\ BIN_Table\(20260115\).xls\ -\ 상세.csv
```

---

## Continuous Integration 🤖

Credit Card Type Detector Korean comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
