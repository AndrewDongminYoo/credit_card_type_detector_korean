# Implementation Plan: Korean Credit Card BIN Detector

## Context & Current State

This package bridges two layers that already exist in the codebase but are **not yet wired together**:

| Layer                         | Location                                                         | Status                                                |
| ----------------------------- | ---------------------------------------------------------------- | ----------------------------------------------------- |
| International brand detection | `lib/types/` (`detectCCType`, `CreditCardType`, patterns)        | Implemented, **not exported**                         |
| Korean BIN database           | `lib/src/` (`data.dart` — 3,612 rows, `CardBinModel`, constants) | Data ready, **detector is empty placeholder**         |
| Public API                    | `lib/index.dart`                                                 | Only exports the empty `CreditCardTypeDetectorKorean` |

The core task is to implement `CreditCardTypeDetectorKorean` so that, given a card number, it performs a BIN-prefix lookup against the Korean database **and** surfaces the international brand detection result alongside it.

---

## Phase 1 — BIN Lookup Index

**Goal:** Build an efficient, pre-indexed data structure over `data.dart` so that BIN lookups are O(1) instead of O(n) linear scans across 3,612 rows.

### What to do

- Create an internal index: `Map<String, List<CardBinModel>>` keyed by the 6-digit BIN string, lazily initialized on first use.
- BINs in the current source are **6 or 8 digits** (3,260 × 6-digit, 352 × 8-digit); the index key is the full BIN value as-is from `CardBinModel.bin`.
- Lookup uses **longest-prefix-first** matching: for a given card number the detector tries each distinct BIN length in descending order and returns the first hit. This ensures 8-digit BINs take priority over any overlapping 6-digit prefix.
- The index lives inside `CreditCardTypeDetectorKorean` (or a package-private helper) — it is **not** part of the public API.

### Files to touch

- `lib/src/card_bin_detector.dart`

### Completion criteria

- [x] Index is built exactly once (lazy singleton pattern).
- [x] Every entry in `data` is reachable via the index; no row is silently dropped.
- [x] Unit test: given a known BIN from the CSV (e.g. `200001`), the index returns the correct `CardBinModel`.
- [x] Unit test: a BIN that does not exist in the dataset returns an empty list.

---

## Phase 2 — Core Detection Logic

**Goal:** Implement the primary public method that accepts a card number string and returns the matching Korean BIN record(s).

### What to do

- Add a `detect(String cardNumber)` method to `CreditCardTypeDetectorKorean`:
  1. **Sanitize input** — strip whitespace and non-numeric characters, the same way `types/detector.dart` does (reuse or mirror `_nonNumeric` / `_whiteSpace` logic).
  2. **Guard** — return empty if the sanitized string is empty or shorter than 6 digits (a BIN cannot be identified with fewer).
  3. **Extract prefix** — take the first 6 characters of the sanitized string.
  4. **Lookup** — hit the Phase 1 index with the prefix; return the list of matching `CardBinModel`.
- Return type: `List<CardBinModel>` (multiple issuers can share a BIN in edge cases; the caller picks).

### Files to touch

- `lib/src/card_bin_detector.dart`

### Completion criteria

- [x] `detect('200001xxxxxxxxxxxx')` returns a non-empty list containing the Shinhan card entry.
- [x] `detect('000000xxxxxxxxxxxx')` (non-existent BIN) returns an empty list.
- [x] `detect('')`, `detect('12345')` (too short), `detect('abcdef')` (non-numeric) all return an empty list.
- [x] `dart analyze` passes with zero issues.

---

## Phase 3 — Combined Result Model & International Wiring

**Goal:** Deliver a single result object that combines Korean BIN info with the international brand classification, so consumers get everything they need in one call.

### What to do

- Define a new data class `CardDetectionResult` in `lib/src/` that holds:
  - `List<CardBinModel> koreanBins` — the Korean BIN matches (may be empty if the card is not a domestic Korean card).
  - `List<CreditCardType> internationalTypes` — the result of `detectCCType()` from `lib/types/detector.dart`.
- Add a higher-level method to `CreditCardTypeDetectorKorean`:
  ```dart
  CardDetectionResult detectCard(String cardNumber)
  ```
  This calls both the Phase 2 Korean lookup **and** `detectCCType` from the types layer, and packages them together.
- Export `detectCCType`, `CreditCardType`, and `CardDetectionResult` from `lib/index.dart` so consumers can use them.

### Files to touch

- `lib/src/card_bin_detector.dart` (or a new `lib/src/card_detection_result.dart`)
- `lib/index.dart`

### Completion criteria

- [x] `detectCard` returns both Korean and international results in one call.
- [x] A purely international card (e.g., a non-Korean Visa test number) returns a populated `internationalTypes` and an empty `koreanBins`.
- [x] A Korean domestic-only card (brand `로컬`) returns a populated `koreanBins` and may return an empty or populated `internationalTypes` depending on prefix overlap.
- [x] `lib/index.dart` exports are intentional — only types consumers actually need are public.
- [x] `dart analyze` passes.

---

## Phase 4 — Query & Filter API

**Goal:** Expose convenience methods for common lookup patterns beyond raw BIN detection.

### What to do

Add the following query methods to `CreditCardTypeDetectorKorean` (all backed by the Phase 1 index or a secondary index built alongside it):

| Method                              | Returns              | Description                                                               |
| ----------------------------------- | -------------------- | ------------------------------------------------------------------------- |
| `findByIssuer(String issuer)`       | `List<CardBinModel>` | All BIN records for a given issuer (e.g. `CARD_ISSUER_SHINHAN`).          |
| `findByBrand(String brand)`         | `List<CardBinModel>` | All BIN records for a given brand (e.g. `TYPE_VISA_KO`, `TYPE_LOCAL_KO`). |
| `findByCardType(String cardType)`   | `List<CardBinModel>` | Filter by `신용` / `체크` / `기프트`.                                     |
| `findByCorporate(String corporate)` | `List<CardBinModel>` | Filter by `개인` / `법인`.                                                |

- Use the existing constants (`CARD_ISSUER_*`, `TYPE_*_KO`, `CREDIT_CARD`, etc.) as the expected input values — document this clearly.
- Secondary indexes (issuer → list, brand → list, etc.) should be built lazily alongside the BIN index in Phase 1's initialization block so that these queries are also O(1) map lookups, not linear scans.

### Files to touch

- `lib/src/card_bin_detector.dart`
- `lib/index.dart` (export any new public constants if needed)

### Completion criteria

- [x] Each query method returns correct results verified against the source CSV for at least two distinct issuers / brands.
- [x] Passing a value that matches no records returns an empty list (no crash).
- [x] All new methods are exercised by unit tests.
- [x] `dart analyze` passes.

---

## Phase 5 — Comprehensive Test Suite

**Goal:** Achieve reliable coverage across all detection and query paths, including edge cases.

### What to do

Expand `test/src/credit_card_type_detector_korean_test.dart` (or add sibling test files) with the following test categories:

1. **BIN lookup accuracy** — spot-check 10+ BINs from different issuers against the CSV source. Verify `cardIssuer`, `brand`, `corporate`, `creditDebit` fields all match.
2. **Edge-case inputs** — empty string, whitespace-only, spaces inside the number (`2000 01`), letters mixed in, numbers shorter than 6 digits, exactly 6 digits, full 16-digit number.
3. **Combined detection** — `detectCard` returns consistent results; Korean and international parts are independently correct.
4. **Query methods** — each `findBy*` method tested with valid and invalid arguments.
5. **Consistency check** — assert that the number of unique BINs in the index equals the number of rows in `data` (catches silent deduplication bugs).

### Files to touch

- `test/src/credit_card_type_detector_korean_test.dart` (and/or additional test files)

### Completion criteria

- [x] `dart test` passes with zero failures.
- [x] All test categories above have at least the minimum number of cases listed.
- [x] Coverage report (via `dart test --coverage`) shows ≥ 80% line coverage on `lib/src/card_bin_detector.dart`.

---

## Phase 6 — Data Regeneration Tooling

**Goal:** Provide a reproducible way to regenerate `lib/src/data.dart` from the source CSV, so that when the upstream BIN table is updated, the code can be kept in sync without manual editing.

### What to do

- Create a standalone Dart script (e.g., `tools/generate_data.dart`) that:
  1. Reads the CSV file at the repo root.
  2. Parses each row into the same shape as `CardBinModel`.
  3. Emits a valid `data.dart` file with the standard preamble and `final data = [...]` list.
  4. Preserves `bin` as a string (leading zeros must not be stripped).
  5. Sorts output by `id` (the `순번` column) for deterministic diffs.
- Document usage in `README.md` (a single command).

### Files to touch

- `tools/generate_data.dart` (new)
- `README.md`

### Completion criteria

- [x] Running the script produces output that is byte-for-byte identical to the current `lib/src/data.dart` (given the same CSV input).
- [x] If a new CSV is dropped in, the script produces a valid, compilable `data.dart` without manual intervention.
- [x] `dart analyze` on the generated file passes.

---

## Phase 7 — Polish & Known-Bug Fixes

**Goal:** Clean up rough edges, fix documented bugs, and finalize the public API surface.

### What to do

1. **Fix `hipercard` copy-paste bug** in `lib/types/models.dart`: the `CreditCardType.hipercard()` named constructor currently copies `hiper` values instead of `hipercard` values. Align `type`, `prettyType`, `lengths`, `patterns`, and `securityCode` to the `TYPE_HIPERCARD` / `PRETTY_HIPERCARD` constants and the correct prefix/length definitions.
2. **Review `index.dart` exports** — remove anything that leaked into the public API unintentionally; add anything that consumers genuinely need.
3. **Update `README.md`** — basic usage example showing `detectCard`, the query methods, and the data regeneration command.
4. **Run full CI checks locally** — `dart analyze`, `dart test`, import sorter — before considering any phase done.

### Files to touch

- `lib/types/models.dart`
- `lib/index.dart`
- `README.md`

### Completion criteria

- [x] `hipercard` named constructor produces values distinct from `hiper` and consistent with `TYPE_HIPERCARD`.
- [x] `lib/index.dart` exports are audited and intentional.
- [x] `README.md` contains a working usage example.
- [x] `dart analyze` and `dart test` both pass cleanly.

---

## Dependency Graph

```diagram
Phase 1 (Index)
    ↓
Phase 2 (Core detect)
    ↓
Phase 3 (Combined result + international wiring)
    ↓               ↓
Phase 4 (Queries)   Phase 5 (Tests — can start after Phase 2, grows through Phase 4)
    ↓
Phase 7 (Polish)

Phase 6 (Data regen tooling) — independent, can run at any time
```

## Notes

- `lib/src/data.dart` must **never** be hand-edited. Any BIN data changes go through the CSV → Phase 6 script → regenerate.
- BIN values are stored as strings to preserve leading zeros. Do not cast to `int` during indexing.
- The `types/` layer's mutable `_customCards` state (`resetCardTypes()`, etc.) is orthogonal to Korean BIN lookup. Do not entangle them.
- Strict analysis is enabled (`very_good_analysis`). Every new symbol should compile cleanly under strict casts/inference/raw-types before moving to the next phase.
