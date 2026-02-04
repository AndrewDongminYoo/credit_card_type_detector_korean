# Style and Conventions

Linting/analysis:
- Uses `very_good_analysis` with strict casts/inference/raw-types enabled.
- `analysis_options.yaml` ignores: `avoid_equals_and_hash_code_on_mutable_classes`, `avoid_types_on_closure_parameters`, `constant_identifier_names`, `directives_ordering`, `lines_longer_than_80_chars`, `public_member_api_docs`, `use_setters_to_change_properties`.
- Line length target is 120 (VS Code setting).

Imports:
- `import_sorter` is enabled with emoji group headers. Run sorter after adding imports.

Generated data:
- `lib/src/data.dart` is generated from the CSV; do not hand-edit.

Commit messages (from `CLAUDE.md` / VS Code GitLens instructions):
- Format:
  <type>: <gitmoji> <subject>

  <body>
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore` only (no scopes).
- Emojis: feat ✨ / fix 🐛 / docs 📝 / style 💄 / refactor ♻️ / test ✅ / chore 🔨 (general) or ⬆️ (deps).
- Subject: lowercase, no trailing period, imperative or past tense.
- Body: explain what/why; dep updates list versions.
