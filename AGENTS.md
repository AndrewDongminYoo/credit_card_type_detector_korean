# AGENTS

## **Project**

This package extends `credit_card_type_detector` to return Korean domestic card issuer BIN information for a provided card number. Data is bundled in code for offline lookup.

## **Key Files**

- `lib/credit_card_type_detector_korean.dart` barrel — public entrypoint; exports the Korean layer and re-exports `detectCCType` / `CreditCardType` from the upstream package.
- `lib/src/card_bin_constants.dart` Korean issuer/brand/category constants.
- `lib/src/data.dart` generated BIN dataset as `CardBinModel` list.
- `lib/src/card_bin_model.dart` model plus CSV/JSON field mapping (Korean column names).
- `lib/src/card_bin_detector.dart` `CreditCardTypeDetectorKorean` — implemented BIN lookup (`detect`, `detectCard`) and query helpers over `data`.
- `lib/src/card_detection_result.dart` `CardDetectionResult` — Korean BIN + international brand result for one card.
- `lib/src/dataset_version.dart` generated dataset release date exported as `datasetVersion`.
- `test/src/credit_card_type_detector_korean_test.dart` full test suite (detect, detectCard, query helpers, serialization).

## **Architecture**

Korean BIN lookup lives in `lib/src/`; international vendor detection comes from the upstream `credit_card_type_detector` dependency (there is no `lib/types/` in this repo). `CreditCardTypeDetectorKorean.detectCard()` wires the two together. The public API is the barrel `lib/credit_card_type_detector_korean.dart`.

## **Data Source**

The authoritative BIN table is `신용카드 BIN_Table(20260115).xls - 상세.csv` at repo root.
`lib/src/data.dart` should reflect this file.
`lib/src/data.dart` and `lib/src/dataset_version.dart` are generated; do not hand-edit them.

- Keep `bin` as a string to preserve leading zeros.
- Keep `id` aligned with `순번` and stable ordering unless the source changes.
- Map CSV columns to `CardBinModel` fields (`발급사`, `BIN`, `전표인자명`, `개인/법인`, `브랜드`, `신용/체크`, optional `등록/수정일자`, `변경사항`, `비고`).

## **Workflow**

- Install the tracked dependency resolution: `dart pub get --enforce-lockfile`.
- The public SDK constraint remains `>=3.10.0 <4.0.0`; current development generators and analysis require Dart 3.13 or later.
- Format: `dart format --line-length 160 lib test tool`.
- Analysis: `dart analyze`.
- Tests: `dart test --coverage=coverage`.
- CI enforces 100% line coverage over `lib`, respects coverage ignores, and excludes `**/*.g.dart` and `**/*.freezed.dart`.
- Dataset roundtrip: `dart run tool/generate_data.dart`, then `dart format --line-length 160 lib/src/data.dart lib/src/dataset_version.dart` and `git diff --exit-code -- lib/src/data.dart lib/src/dataset_version.dart`.
- Repository tooling: `trunk check --all --no-fix --jobs=2`.
  Dart is intentionally disabled in Trunk; use the Dart gates above.
  Trunk manages Node 22.23.4 for CSpell 10.4.0, which requires Node `>=22.18.0`.
  OSV scans the tracked Pub lockfile; its inherited converter may report line 0, but the controlled vulnerable Pub fixture still blocks Trunk with both advisory IDs.
  TruffleHog scans files without credential verification and uses `.trunk/configs/trufflehog_to_sarif.py` to retain encoded findings as file-level results when literal locations are unavailable.
- Reader regression tests: `python3 -B .trunk/configs/tests/test_trufflehog_to_sarif.py`.
- Keep spelling settings in `cspell.json` and preserve its imports and scan surface.
  Retain authoritative CSV spellings and keep the reader-test wire-identifier exception scoped to its test file.
- Imports: if needed, run `dart run import_sorter:main` to normalize import ordering.
