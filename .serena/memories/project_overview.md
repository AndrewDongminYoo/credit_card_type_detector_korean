# Project Overview

Purpose: Dart package that extends `credit_card_type_detector` to return Korean domestic card issuer BIN info for a given card number. Data is bundled in code for offline lookup.

Tech stack:

- Dart package (SDK >=3.10.0 <4.0.0)
- Depends on `credit_card_type_detector`
- Dev: `test`, `very_good_analysis`, `import_sorter`, `mockito`, `build_runner`, `freezed`, `json_serializable`

High-level structure:

- `lib/credit_card_type_detector_korean.dart` barrel — exports the public API
- `lib/src/` Korean BIN data/model/detector layer (`CreditCardTypeDetectorKorean`)
- International vendor detection comes from the `credit_card_type_detector` dependency (no `lib/types/` in this repo)
- `test/src/credit_card_type_detector_korean_test.dart` full test suite

Data source:

- The csv file at repo root is the authoritative BIN table.
