# Architecture

Two layers are present and not yet fully wired together:

1. International vendor detection (`lib/types/`)

- Port/adaptation of `credit_card_type_detector`.
- `types/constants.dart` defines brand codes, BIN prefix patterns, length defaults, security code defaults.
- `types/models.dart` defines `CreditCardType`, `Pattern`, `SecurityCode`, `CardCollection`.
- `types/detector.dart` exposes `detectCCType(String)` and functions to add/update/remove/reset card types.

2. Korean domestic BIN database (`lib/src/`)

- `card_bin_constants.dart`: issuer/brand/category constants (Korean labels)
- `card_bin_model.dart`: `CardBinModel` with CSV/JSON field mapping (Korean column names)
- `data.dart`: generated list of `CardBinModel` rows from the CSV (do not hand-edit)
- `card_bin_detector.dart`: placeholder for higher-level BIN lookup logic

Public API:

- `lib/index.dart` currently exports only `src/card_bin_detector.dart`.

Data rules:

- Keep `bin` as a string to preserve leading zeros.
- Keep `id` aligned with `순번` and stable ordering unless source changes.
- CSV columns map to `CardBinModel` fields: `발급사`, `BIN`, `전표인자명`, `개인/법인`, `브랜드`, `신용/체크`, optional `등록/수정일자`, `변경사항`, `비고`.
