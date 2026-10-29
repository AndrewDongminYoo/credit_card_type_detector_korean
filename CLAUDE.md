# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```sh
# Install dependencies
dart pub get --enforce-lockfile

# Run all tests
dart test

# Run a single test file
dart test test/src/credit_card_type_detector_korean_test.dart

# Run tests with coverage
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --check-ignore --ignore-files="**/*.g.dart,**/*.freezed.dart" --in=coverage --out=coverage/lcov.info --package=. --report-on=lib

# Lint / analyze
dart analyze

# Check formatting without writing files
dart format --output=none --set-exit-if-changed --line-length 160 lib test tool

# Run repository quality and dependency scans
trunk check --all --no-fix --jobs=2

# Run the filesystem reader regression tests
python3 -B .trunk/configs/tests/test_trufflehog_to_sarif.py

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
- `src/data.dart` — **Generated file.**
  A `const data = [...]` list of `CardBinModel` instances, one per BIN row from the source CSV.
  Do not hand-edit.
  Regenerate from the CSV when the source data changes.
- `src/card_detection_result.dart` — `CardDetectionResult`: combines a Korean BIN lookup (`koreanBins`) with the international brand result (`internationalTypes`) for a single card number.
- `src/card_bin_detector.dart` — `CreditCardTypeDetectorKorean`: the implemented detector. Builds lazy indexes over `data` (by BIN, issuer, brand, card type, corporate) and exposes `detect()` (longest-prefix BIN lookup), `detectCard()` (Korean + international combined), and `findByIssuer` / `findByBrand` / `findByCardType` / `findByCorporate`.

### Source data

`신용카드 BIN_Table(20260115).xls - 상세.csv` — The upstream BIN table from which `src/data.dart` was generated.
CSV headers (Korean): `순번, 발급사, BIN, 전표인자명, 개인/법인, 브랜드, 신용/체크, 등록/수정일자, 변경사항, 비고`.

### Public API surface

The public entry point is `lib/credit_card_type_detector_korean.dart` (there is no `lib/index.dart`).
It exports the Korean layer — `card_bin_constants.dart`, `card_bin_detector.dart`, `card_bin_model.dart`, `card_detection_result.dart` — and `datasetVersion`, and re-exports `detectCCType` and `CreditCardType` from the upstream `credit_card_type_detector` package.
The `data` list is intentionally **not** exported.

## Linting & Analysis

- Strict analysis via `very_good_analysis` with `strict-casts`, `strict-inference`, `strict-raw-types` all enabled.
- Several analyzer diagnostics are downgraded to ignore in `analysis_options.yaml` (under `analyzer.errors`): `avoid_types_on_closure_parameters`, `constant_identifier_names`, `directives_ordering`, `document_ignores`, `lines_longer_than_80_chars`, `use_setters_to_change_properties`.
- Formatting uses 160 characters, set in `analysis_options.yaml` (`formatter.page_width: 160`) and CI (`format_line_length: 160`).
  The editor override in `.vscode/settings.json` still uses 120; pass `--line-length 160` for repository formatting.
- The package SDK range remains `>=3.10.0 <4.0.0` for consumers.
  Development tooling currently requires Dart 3.13 or later; the committed `pubspec.lock` records the development resolution and is excluded from publication by `.pubignore`.
- `import_sorter` is active — imports are grouped and prefixed with emoji comments (e.g., `// 📦 Package imports:`, `// 🌎 Project imports:`). Run the sorter after adding imports.
- Dart is disabled in Trunk so its runtime cannot shadow the project SDK.
  Its managed Node 22.23.4 meets CSpell 10.4.0's `>=22.18.0` engine requirement.
- Trunk runs OSV on `pubspec.lock` with the inherited JSON-to-SARIF converter.
  That converter can emit line 0 for Pub locks; actual vulnerable/clean Pub controls confirmed advisory reporting and Trunk rejection remain functional.
- TruffleHog runs with `--no-verification` and the project reader at `.trunk/configs/trufflehog_to_sarif.py`.
  The reader retains encoded or unreadable findings at file level when a literal location is unavailable, and omits secret values from diagnostic messages.
  The reader is a direct Trunk config so sandbox copying and cache invalidation include it.
- `cspell.json` preserves the existing imports and scan surface, with observed source/platform vocabulary recorded explicitly.
  Its wire-identifier exception applies only to the reader test file; unrelated spelling errors remain checked there.

## CI

GitHub Actions (`.github/workflows/main.yaml`) runs on push/PR to `main`:

- Semantic PR title check
- Spell check on `*.md` files (custom dictionary at `.cspell/card-specific.txt` for card-related terms)
- Dart package build/test/analyze via Very Good Workflows
- Lockfile enforcement before analysis/tests and CSV roundtrip
- 100% line coverage over `lib`, respecting ignore comments and excluding `**/*.g.dart` and `**/*.freezed.dart`
- Generated BIN data and `datasetVersion` regeneration with no Git diff
- Ten standard-library tests for the TruffleHog filesystem JSONL reader

## Known state / things to be aware of

- `CreditCardTypeDetectorKorean` is fully implemented (BIN lookup + query helpers). The indexes over `data` are built lazily at first use and cached for the process lifetime.
- `detect()` matches by **longest prefix first** — 8-digit BINs win over overlapping 6-digit BINs. Input is sanitized (all non-digits stripped) and must be ≥ 6 digits.
- Matched BIN lists and query-helper results are returned via `List.unmodifiable`, so callers cannot mutate the package's internal index buffers.
  The combined `detectCard()` result also has unmodifiable lists.
- Upstream-dependency caveats (in `credit_card_type_detector`, not this repo): `detectCCType` keeps a mutable module-level card collection with `addCardType` / `resetCardTypes` mutators — this package re-exports **only** `detectCCType` and `CreditCardType`, not those mutators. Also, `CreditCardType.hipercard()` sets `type = TYPE_HIPER` instead of `TYPE_HIPERCARD` (an upstream copy-paste bug).
