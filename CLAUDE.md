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
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info

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

The package has **two distinct layers** that are not yet fully wired together. Understanding this split is critical before making changes.

### Layer 1 — International vendor detection (`lib/types/`)

A port/adaptation of the `credit_card_type_detector` package logic:

- `types/constants.dart` — Card brand type codes (`TYPE_VISA`, etc.), BIN prefix patterns (`cardNumPatternDefaults`), valid card number lengths (`ccNumLengthDefaults`), and security code defaults (`ccSecurityCodeDefaults`). All internationally-scoped data lives here.
- `types/models.dart` — Data classes: `CreditCardType` (brand + patterns + lengths + security code), `Pattern` (prefix or prefix-range), `SecurityCode` (CVV/CVC/CID variants), `CardCollection` (map wrapper with add/update/remove).
- `types/detector.dart` — Top-level functions: `detectCCType(String)` matches a card number against `cardNumPatternDefaults` and returns a sorted list of `CreditCardType` by match strength. Also exposes `addCardType`, `updateCardType`, `removeCardType`, `resetCardTypes` for runtime customization of the card collection. **None of these are currently exported from the package** (not in `lib/index.dart`).

### Layer 2 — Korean domestic BIN database (`lib/src/`)

- `src/card_bin.constants.dart` — Korean card issuer name constants (`CARD_ISSUER_SHINHAN`, etc.) and Korean brand label constants (`TYPE_LOCAL_KO = '로컬'`, `TYPE_VISA_KO = '비자'`, etc.), plus card category constants (개인/법인, 신용/체크/기프트).
- `src/card_bin.model.dart` — `CardBinModel`: flat data class mapping one row of the BIN CSV. Fields: `id`, `cardIssuer`, `bin`, `factorName`, `corporate`, `brand`, `creditDebit`, plus optional `updatedAt`/`changed`/`remarks`. Has `fromJson` / `toJson`.
- `src/data.dart` — **Generated file, ~30k lines.** A `final data = [...]` list of `CardBinModel` instances, one per BIN row from the source CSV. Do not hand-edit. Regenerate from the CSV when the source data changes.
- `src/card_bin.detector.dart` — Currently an **empty placeholder class** (`CreditCardTypeDetectorKorean`). This is where the Korean BIN lookup logic should be implemented, bridging `data.dart` with the detection API.

### Source data

`신용카드 BIN_Table(20260115).xls - 상세.csv` — The upstream BIN table (3,612 rows) from which `src/data.dart` was generated. CSV headers (Korean): `순번, 발급사, BIN, 전표인자명, 개인/법인, 브랜드, 신용/체크, 등록/수정일자, 변경사항, 비고`.

### Public API surface

`lib/index.dart` currently only exports `src/card_bin.detector.dart`. The `types/` layer functions (`detectCCType`, etc.) and the `data` list are not part of the public API yet. When wiring things together, be intentional about what gets exported.

## Linting & Analysis

- Strict analysis via `very_good_analysis` with `strict-casts`, `strict-inference`, `strict-raw-types` all enabled.
- Several rules are explicitly ignored in `analysis_options.yaml`: `avoid_equals_and_hash_code_on_mutable_classes`, `constant_identifier_names`, `directives_ordering`, `lines_longer_than_80_chars`, `public_member_api_docs`.
- Line length limit is 120 chars (VSCode setting), not the default 80.
- `import_sorter` is active — imports are grouped and prefixed with emoji comments (e.g., `// 📦 Package imports:`, `// 🌎 Project imports:`). Run the sorter after adding imports.

## CI

GitHub Actions (`.github/workflows/main.yaml`) runs on push/PR to `main`:

- Semantic PR title check
- Spell check on `*.md` files (custom dictionary at `.cspell/card-specific.txt` for card-related terms)
- Dart package build/test/analyze via Very Good Workflows

## Known state / things to be aware of

- `CreditCardTypeDetectorKorean` class is a placeholder with no logic. The core work of this package — looking up a card number against the Korean BIN database and returning issuer info — has not been implemented yet.
- `types/detector.dart` operates on a module-level mutable `_customCards` variable (cloned from `_defaultCCTypes` at load time). This is stateful; `resetCardTypes()` restores defaults.
- `CreditCardType.hipercard()` named constructor is a copy-paste bug: it sets `type = TYPE_HIPER` instead of `TYPE_HIPERCARD` (same for `prettyType`, `lengths`, `patterns`, `securityCode`). Same issue exists in the upstream package.
