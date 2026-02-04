# AGENTS

## **Project**

This package extends `credit_card_type_detector` to return Korean domestic card issuer BIN information for a provided card number. Data is bundled in code for offline lookup.

## **Key Files**

- `lib/index.dart` entrypoint exports.
- `lib/src/card_bin_constants.dart` Korean issuer/brand/category constants.
- `lib/src/data.dart` generated BIN dataset as `CardBinModel` list.
- `lib/src/card_bin_model.dart` model plus CSV/JSON field mapping (Korean column names).
- `lib/src/card_bin_detector.dart` placeholder for higher-level detection logic.
- `lib/types/` credit card type detection logic (upstream style).
- `test/src/credit_card_type_detector_korean_test.dart` basic smoke test.

## **Architecture**

There are two layers that are not yet wired together: international vendor detection in `lib/types/` and Korean BIN lookup in `lib/src/`. Public API currently only exports `lib/src/card_bin_detector.dart`.

## **Data Source**

The authoritative BIN table is `신용카드 BIN_Table(20260115).xls - 상세.csv` at repo root. `lib/src/data.dart` should reflect this file.
`lib/src/data.dart` is generated; do not hand-edit it.

- Keep `bin` as a string to preserve leading zeros.
- Keep `id` aligned with `순번` and stable ordering unless the source changes.
- Map CSV columns to `CardBinModel` fields (`발급사`, `BIN`, `전표인자명`, `개인/법인`, `브랜드`, `신용/체크`, optional `등록/수정일자`, `변경사항`, `비고`).

## **Workflow**

- Format: `dart format .`
- Tests: `dart test`
- Imports: if needed, run `dart run import_sorter:main` to normalize import ordering.
