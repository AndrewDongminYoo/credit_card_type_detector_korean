# Architecture

Two layers, wired together by `CreditCardTypeDetectorKorean`:

1. International vendor detection (upstream dependency)

- Provided by the `credit_card_type_detector` package, not by code in this repo — there is no `lib/types/` directory.
- The barrel re-exports `detectCCType(String)` and `CreditCardType` from that dependency.

2. Korean domestic BIN database (`lib/src/`)

- `card_bin_constants.dart`: issuer/brand/category constants (Korean labels)
- `card_bin_model.dart`: `CardBinModel` (freezed) with CSV/JSON field mapping (Korean column names)
- `data.dart`: generated `const data` list of `CardBinModel` rows from the CSV (do not hand-edit)
- `card_bin_detector.dart`: `CreditCardTypeDetectorKorean` — implemented. Lazy indexes over `data`; `detect()` (longest-prefix BIN lookup), `detectCard()` (Korean + international), `findByIssuer` / `findByBrand` / `findByCardType` / `findByCorporate`.
- `card_detection_result.dart`: `CardDetectionResult` (`koreanBins` + `internationalTypes`).

Public API:

- The barrel `lib/credit_card_type_detector_korean.dart` exports the Korean layer and re-exports `detectCCType` / `CreditCardType`. There is no `lib/index.dart`. The `data` list is not exported.

Data rules:

- Keep `bin` as a string to preserve leading zeros.
- Keep `id` aligned with `순번` and stable ordering unless source changes.
- CSV columns map to `CardBinModel` fields: `발급사`, `BIN`, `전표인자명`, `개인/법인`, `브랜드`, `신용/체크`, optional `등록/수정일자`, `변경사항`, `비고`.
