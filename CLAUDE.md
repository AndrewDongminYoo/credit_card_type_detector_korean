# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```sh
# Install dependencies
dart pub get

# Run all tests
dart test

# Run a single test file
dart test test/src/credit_card_type_detector_korean_test.dart

# Run tests with coverage
dart pub global activate coverage
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --check-ignore --ignore-files="**/*.g.dart" --in=coverage --out=coverage/lcov.info --package=. --report-on=lib

# Lint / analyze
dart analyze

# Sort imports (configured with emojis via pubspec.yaml import_sorter section)
dart run import_sorter:main
```

## Commit Message Format

Defined in `.vscode/settings.json` under `gitlens.ai.generateCommitMessage.customInstructions`. Follow this exactly:

```plaintext
<type>: <gitmoji> <subject>

<body>
```

- **Type**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore` only. **No scopes** (no parentheses).
- **Emoji mapping**: feat ✨ / fix 🐛 / docs 📝 / style 💄 / refactor ♻️ / test ✅ / chore 🔨 (general) or ⬆️ (deps)
- **Subject**: lowercase, no trailing period, imperative or past tense.
- **Body**: For dep updates list versions (`- package: from x to y`). For code changes explain what and why.

## Architecture Overview

The package has **two layers**, wired together by `CreditCardTypeDetectorKorean`. Understanding this split is critical before making changes.

### Layer 1 — International vendor detection (upstream dependency)

International brand detection is provided by the `credit_card_type_detector` package (a direct dependency), not by code in this repo. The barrel re-exports the two symbols this package builds on:

- `detectCCType(String)` — matches a card number against the upstream BIN patterns and returns a list of `CreditCardType` sorted by match strength.
- `CreditCardType` — the upstream brand model (brand + patterns + lengths + security code).

There is **no `lib/types/` directory** in this repo; the upstream logic lives in the dependency and is surfaced through `detectCard()` (see Layer 2).

### Layer 2 — Korean domestic BIN database (`lib/src/`)

- `src/card_bin_constants.dart` — Korean card issuer name constants (`CARD_ISSUER_SHINHAN`, etc.) and Korean brand label constants (`TYPE_LOCAL_KO = '로컬'`, `TYPE_VISA_KO = '비자'`, etc.), plus card category constants (개인/법인, 신용/체크/기프트).
- `src/card_bin_model.dart` — `CardBinModel`: flat data class mapping one row of the BIN CSV. Fields: `id`, `cardIssuer`, `bin`, `factorName`, `corporate`, `brand`, `creditDebit`, plus optional `updatedAt`/`changed`/`remarks`. Has `fromJson` / `toJson`.
- `src/data.dart` — **Generated file (tens of thousands of lines).** A `const data = [...]` list of `CardBinModel` instances, one per BIN row from the source CSV. Do not hand-edit. Regenerate from the CSV when the source data changes.
- `src/card_detection_result.dart` — `CardDetectionResult`: combines a Korean BIN lookup (`koreanBins`) with the international brand result (`internationalTypes`) for a single card number.
- `src/card_bin_detector.dart` — `CreditCardTypeDetectorKorean`: the implemented detector. Builds lazy indexes over `data` (by BIN, issuer, brand, card type, corporate) and exposes `detect()` (longest-prefix BIN lookup), `detectCard()` (Korean + international combined), and `findByIssuer` / `findByBrand` / `findByCardType` / `findByCorporate`.

### Source data

`신용카드 BIN_Table(20260428).xls - 상세.csv` — The upstream BIN table (3,643 rows) from which `src/data.dart` was generated. CSV headers (Korean): `순번, 발급사, BIN, 전표인자명, 개인/법인, 브랜드, 신용/체크, 등록/수정일자, 변경사항, 비고`.

### Public API surface

The public entry point is `lib/credit_card_type_detector_korean.dart` (there is no `lib/index.dart`). It exports the Korean layer — `card_bin_constants.dart`, `card_bin_detector.dart`, `card_bin_model.dart`, `card_detection_result.dart` — and re-exports `detectCCType` and `CreditCardType` from the upstream `credit_card_type_detector` package. The `data` list is intentionally **not** exported.

## Linting & Analysis

- Strict analysis via `very_good_analysis` with `strict-casts`, `strict-inference`, `strict-raw-types` all enabled.
- Several analyzer diagnostics are downgraded to ignore in `analysis_options.yaml` (under `analyzer.errors`): `avoid_types_on_closure_parameters`, `constant_identifier_names`, `directives_ordering`, `document_ignores`, `lines_longer_than_80_chars`, `use_setters_to_change_properties`.
- Line length is 120 chars — set in both `analysis_options.yaml` (`formatter.page_width: 120`) and `.vscode/settings.json` (`dart.lineLength: 120`), not the default 80.
- `import_sorter` is active — imports are grouped and prefixed with emoji comments (e.g., `// 📦 Package imports:`, `// 🌎 Project imports:`). Run the sorter after adding imports.

## CI

GitHub Actions (`.github/workflows/main.yaml`) runs on push/PR to `main`:

- Semantic PR title check
- Spell check on `*.md` files (custom dictionary at `.cspell/card-specific.txt` for card-related terms)
- Dart package build/test/analyze via Very Good Workflows

## Known state / things to be aware of

- `CreditCardTypeDetectorKorean` is fully implemented (BIN lookup + query helpers). The indexes over `data` are built lazily at first use and cached for the process lifetime.
- `detect()` matches by **longest prefix first** — 8-digit BINs win over overlapping 6-digit BINs. Input is sanitized (all non-digits stripped) and must be ≥ 6 digits.
- All list results are returned via `List.unmodifiable`, so callers cannot mutate the package's internal index buffers.
- Upstream-dependency caveats (in `credit_card_type_detector`, not this repo): `detectCCType` keeps a mutable module-level card collection with `addCardType` / `resetCardTypes` mutators — this package re-exports **only** `detectCCType` and `CreditCardType`, not those mutators. Also, `CreditCardType.hipercard()` sets `type = TYPE_HIPER` instead of `TYPE_HIPERCARD` (an upstream copy-paste bug).
