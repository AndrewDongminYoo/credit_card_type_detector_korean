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
- `test/src/credit_card_type_detector_korean_test.dart` full test suite (detect, detectCard, query helpers, serialization).

## **Architecture**

Korean BIN lookup lives in `lib/src/`; international vendor detection comes from the upstream `credit_card_type_detector` dependency (there is no `lib/types/` in this repo). `CreditCardTypeDetectorKorean.detectCard()` wires the two together. The public API is the barrel `lib/credit_card_type_detector_korean.dart`.

## **Data Source**

The authoritative BIN table is `신용카드 BIN_Table(20260428).xls - 상세.csv` at repo root. `lib/src/data.dart` should reflect this file.
`lib/src/data.dart` is generated; do not hand-edit it.

- Keep `bin` as a string to preserve leading zeros.
- Keep `id` aligned with `순번` and stable ordering unless the source changes.
- Map CSV columns to `CardBinModel` fields (`발급사`, `BIN`, `전표인자명`, `개인/법인`, `브랜드`, `신용/체크`, optional `등록/수정일자`, `변경사항`, `비고`).

## **Workflow**

- Format: `dart format .`
- Tests: `dart test`
- Imports: if needed, run `dart run import_sorter:main` to normalize import ordering.
