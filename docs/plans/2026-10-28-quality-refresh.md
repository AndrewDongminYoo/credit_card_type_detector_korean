# Quality Tooling Refresh Plan

## Work

1. Verify repository identity, instructions, current changes and Oracle precedent → verify: exact Git root, personal origin, branch/status, SDK version and protected-file hashes.
2. Refresh compatible dependency and linter versions with existing package managers → verify: public `pub.dev` metadata, generated lockfile and effective Trunk configuration.
3. Run declared Dart gates, CI-equivalent coverage, scanner controls and the full no-fix Trunk scan → verify: commands below, nonzero negative controls and zero protected-file drift.
4. Reconcile affected knowledge and review the scoped candidate → verify: documented commands, SDK requirements, format width, exports and Git diff checks.
5. Return the candidate and visible evidence to the root agent for independent review and local commits.
   Publication remains gated by repository-specific approval.

## Execution Constraints

Use the existing Dart SDK without global activation or SDK changes.
Run public Pub commands with `PUB_HOSTED_URL=https://pub.dev`.
Keep dependency resolution, tests, code generation and full scans in the root agent's shared slot; queue while the one-minute load is at least 10.
Do not hand-edit generated models or the CSV-derived BIN data/version.
Model generation is required only if a dependency change requires it; report that need before running the configured generator.

## Declared Gates

- `dart pub get --enforce-lockfile`
- `dart analyze`
- `dart test --coverage=coverage`
- `dart run coverage:format_coverage --lcov --check-ignore --ignore-files="**/*.g.dart,**/*.freezed.dart" --in=coverage --out=coverage/lcov.info --package=. --report-on=lib`
- CI-equivalent LCOV threshold check using the declared Very Good Workflows revision and its CLI 1.5.0 coverage semantics; prove an uncovered-line fixture fails before reading the real report.
- `dart format --output=none --set-exit-if-changed --line-length 160 lib test tool`
- `dart run tool/generate_data.dart`
- `dart format --line-length 160 lib/src/data.dart lib/src/dataset_version.dart`
- `git diff --exit-code -- lib/src/data.dart lib/src/dataset_version.dart` plus original SHA-256 comparison
- `osv-scanner scan source --lockfile=pubspec.lock --format=json --all-packages`
- `python3 -B .trunk/configs/tests/test_trufflehog_to_sarif.py`
- Literal, encoded and clean TruffleHog controls using the configured offline flags and project JSONL reader
- Managed Node version/engine check and a tracked Markdown CSpell canary with exact restoration
- `trunk check --all --no-fix --jobs=2`
- `git diff --check`

## Verified Baseline

Repository identity, SDK, public dependency metadata, the declared reusable workflow, scanner definitions and original hashes are captured.
Public Pub resolution retains every direct dependency, including `build_runner ^2.16.2`.
`build_runner` 2.17.0 and `build` 4.1.0 are retracted; 2.17.1 requires `build` 5, which conflicts with retained Mockito's `build <5` requirement.
The retained runner holds `build_config` below 1.4.0 and `built_collection` below 6.0.0; current `built_value` also requires `built_collection` 5.x.
The generated lock records compatible transitive updates to `crypto` 3.0.8 and `web` 1.1.2.
TruffleHog is raised from 3.99.2 to 3.99.7, OSV is enabled at 2.7.0, and Pinact remains `4.1.1!` with both commands.
Lockfile enforcement, analysis, 52 tests, the 160-character format check, and the CSV generator roundtrip passed.
The CI-equivalent LCOV reader measured 33 covered lines out of 33 included lines; an uncovered control failed before the real report passed.
OSV scanned the same 74 hosted packages as the native Pub graph and found no vulnerabilities; the graph has no Git or SDK dependencies.
The Dart SDK binary itself is outside the Pub lock scan, and the consumer minimum SDK was preserved without a separate Dart 3.10 runtime test.
An offline random-token canary failed the scanner with exit 183, produced a GitHub SARIF finding at line 2, and failed Trunk with exit 1; the clean control passed both readers and the temporary directory was removed.
The initial sequential-token experiment produced no finding and is retained as a failed fixture experiment, not scanner-pass evidence.
The initial uncached full no-fix Trunk scan returned no issues over 55 files before the managed Node compatibility follow-up.
Original hashes of the CSV-derived data/version and existing generated models remained unchanged; no model regeneration was needed.
The existing VS Code 120-character override is documented as an advisory; the repository's analyzer/CI format width is 160.

## Compatibility Follow-up

Raise only Trunk's managed Node to 22.23.4 to satisfy CSpell 10.4.0's Node `>=22.18.0` requirement.
Use the reviewed project reader to preserve encoded TruffleHog findings that the inherited converter dropped.
The reader and ten tests are copied byte-identically from the root-verified source; the expected SHA-256 values are `304dd73de26d39ca2bc7fb3aed50f9844ba8c9228c77d4d6bd3c32f3aed6a573` and `e09a236268aff901c1afb872e3ab89246d6b5d50e07b08f35725fdca543ed13a`.
Keep the existing scanner flags, sandbox, OSV converter and Pinact command allowlist.
Root's actual OSV Pub controls found both expected advisories for `archive` 3.3.1 and blocked Trunk, while 3.3.8 passed; the converter's line 0 affects position accuracy while advisory blocking remains functional.
Reuse the Dart, coverage, CSV and generated-model baseline by exact hash because this follow-up does not change their inputs.
The granted-slot check confirmed the CSpell shim uses managed Node 22.23.4 and the installed CSpell 10.4.0 package requires Node `>=22.18.0`.
Actual encoded and literal controls each produced scanner exit 183, one preserved reader finding, and Trunk exit 1; the clean control returned zero throughout.
The encoded control used the real BASE64 decoder and retained a file-level location, while the literal control identified line 2.
The same encoded finding still vanished through the inherited reader, confirming the regression that the project reader fixes.
The first restored Markdown CSpell check failed and its evidence is retained.
Full word triage recorded 17 case-sensitive terms at 46 locations; new prose was corrected and only observed source/platform vocabulary was registered.
The wire-identifier exception uses word matching that ignores case and applies only to the reviewed reader test.
Both the tracked Markdown and a different misspelling in that test file followed full-surface pass → expected failure → exact restoration → pass sequences.
Existing imports, scan paths, source bytes, CSV labels and reviewed reader/test hashes remained intact.
The final evidence receipt records the full no-fix Trunk result after this follow-up.
