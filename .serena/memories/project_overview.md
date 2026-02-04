# Project Overview

Purpose: Dart package that extends `credit_card_type_detector` to return Korean domestic card issuer BIN info for a given card number. Data is bundled in code for offline lookup.

Tech stack:
- Dart package (SDK >=3.10.0 <4.0.0)
- Depends on `credit_card_type_detector`
- Dev: `test`, `very_good_analysis`, `import_sorter`, `mocktail`

High-level structure:
- `lib/index.dart` exports the public API
- `lib/src/` Korean BIN data/model/detector layer
- `lib/types/` upstream-style international vendor detection logic
- `test/src/credit_card_type_detector_korean_test.dart` smoke test

Data source:
- The csv file at repo root is the authoritative BIN table.
