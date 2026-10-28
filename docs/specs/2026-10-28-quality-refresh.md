# Quality Tooling Refresh

## Approved Scope

Refresh supported dependencies and existing quality tooling.
Preserve public APIs, generated artifacts and repository-specific boundaries.
Keep the consumer SDK constraint `>=3.10.0 <4.0.0`, upstream vendor ownership, the `detectCard` bridge, and only the existing `detectCCType` / `CreditCardType` upstream re-exports.
Keep BIN values as strings and the CSV as the source of truth.

## Compatibility

Use the existing Dart SDK binary at `/Users/dongminyu/Development/flutter/bin/cache/dart-sdk/bin/dart` (verified as 3.13.7).
Development generators and strict analysis may require a newer SDK than consumers.
Keep `build_runner ^2.16.2`, the latest active release selected by the resolver for the current graph, and regenerate the lockfile with public `pub.dev` metadata.
`build_runner` 2.17.0 and its required `build` 4.1.0 are retracted.
Hold `build_runner` 2.17.1 because it requires `build >=5.0.0 <5.1.0`, while retained `mockito` 5.8.1 requires `build >=3.0.0 <5.0.0`.
The retained runner also holds `build_config` below 1.4.0 and `built_collection` below 6.0.0; current `built_value` also requires `built_collection` 5.x.
Track the generated development lockfile and retain its `.pubignore` exclusion.
The initial ignored lockfile and the changed lockfile observed on resume are preserved in external evidence; the latter's authorship is unknown.
This is a local quality and supply-chain refresh, not a package release.
Keep the Trunk CLI, plugin and Python runtime pins.
Raise only Trunk's managed Node from 22.16.0 to 22.23.4 because CSpell 10.4.0 requires Node `>=22.18.0`.
Do not change global Node or Dart installations.
The resolved `crypto` 3.0.8 and `web` 1.1.2 updates are development-only transitive dependencies; they do not change the runtime dependency graph or public SDK floor.

## Acceptance

- Pinact remains locked to `4.1.1` with `lint` and `upgrade`.
- The full no-fix Trunk scan and declared project gates pass.
- Changed manifests have package-manager-generated lockfiles under repository policy.
- Advisory dispositions have specific evidence and affected knowledge claims are reconciled.
- OSV reads the real Pub lockfile; scan coverage identifies hosted, Git and SDK sources separately.
- TruffleHog runs with `--no-verification` and the reviewed project JSONL reader; literal, encoded and clean controls prove findings remain actionable.
- The project reader and its ten standard-library tests match the reviewed source hashes, and CI runs those tests.
- The reader is a Trunk direct config so it is copied into the sandbox and included in cache invalidation.
- OSV retains its inherited JSON converter after actual vulnerable/clean Pub controls confirmed blocking; line 0 affects position accuracy while advisory blocking remains functional.
- The actual managed Node version satisfies CSpell's engine requirement and a tracked Markdown spelling canary fails before its exact restoration passes.
- Observed spelling terms have exact locations and semantic dispositions; authoritative source text and CSV labels remain unchanged.
- A separate misspelling in the reader test file fails even with its scoped wire-identifier exception, and exact restoration returns the full original CSpell surface to a passing result.
- CI-equivalent coverage is 100% over `lib`, with coverage ignore comments and both `**/*.g.dart` / `**/*.freezed.dart` exclusions.
- The CSV roundtrip leaves `lib/src/data.dart` and `lib/src/dataset_version.dart` byte-identical.
- No dependency change requires a public API or CSV/model-logic change.

## Evidence and Precedent

Store commands, exits, metadata, controls, generated-file hashes and the knowledge audit in `/Volumes/dongminyu/Development/01_personal/pr-loop-reviews/credit_card_type_detector_korean/2026-10-28-quality-refresh`.
Oracle's supplied precedent confirms upstream vendor ownership, CSV source ownership, BIN strings and the narrow combined entry point.
The referenced source paths are `credit_card_type_detector_korean/AGENTS.md`, `credit_card_type_detector_korean/CLAUDE.md`, `credit_card_type_detector_korean/README.md`, and `wiki/concepts/korean-bin-detection-combined-entry.md`.
Its supplied source commit `9670d54de3076c5239713f54900c7a855bd18478` remains unverified, so repository reads govern this change.

## Publication

Push and PR creation require explicit repository-specific approval.
After approval, continue the requested hosted gates, merge, cleanup and memory recording.
