# Suggested Commands

Dependencies:
- `dart pub get`

Formatting:
- `dart format .`
- `dart run import_sorter:main` (import grouping)

Lint / analyze:
- `dart analyze`

Tests:
- `dart test`
- Single test: `dart test test/src/credit_card_type_detector_korean_test.dart`

Coverage:
- `dart pub global activate coverage 1.2.0`
- `dart test --coverage=coverage`
- `dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info`
- `genhtml coverage/lcov.info -o coverage/`
- `open coverage/index.html`
