# Task Completion Checklist

- Run `dart format .`.
- Run `dart test` (or targeted test file).
- Run `dart analyze` if relevant to change scope.
- If imports changed, run `dart run import_sorter:main`.
- If BIN source CSV changes, regenerate `lib/src/data.dart` (do not edit by hand).
