/// Reads the Korean BIN CSV and writes `lib/src/data.dart`.
///
/// Usage:
///   dart tool/generate_data.dart [path/to/csv]
///
/// If no path is given the script searches the project root for a file whose
/// name starts with "신용카드 BIN_Table" and ends with ".csv".
///
/// The output file is overwritten unconditionally.
library;

import 'dart:io';

void main(List<String> args) {
  final projectRoot = _projectRoot();
  final csvPath = args.isNotEmpty ? args[0] : _findCsv(projectRoot);
  final csvFile = File(csvPath);

  if (!csvFile.existsSync()) {
    _exit('CSV file not found: $csvPath');
  }

  final lines = csvFile.readAsLinesSync();
  if (lines.length < 2) {
    _exit('CSV is empty or has no data rows.');
  }

  // Skip the header row (index 0).
  final entries = <String>[];
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;

    final fields = _parseCsvLine(line);
    if (fields.length < 7) {
      stderr.writeln('Warning: skipping row $i — fewer than 7 fields.');
      continue;
    }

    entries.add(_toCardBinModel(fields));
  }

  final output = _buildFile(entries);

  File('$projectRoot/lib/src/data.dart').writeAsStringSync(output);

  final version = _datasetVersion(csvPath);
  File('$projectRoot/lib/src/dataset_version.dart').writeAsStringSync(_buildVersionFile(version));

  // ignore: avoid_print
  print('Generated ${entries.length} entries (dataset $version) → $projectRoot/lib/src/');
}

// ---------------------------------------------------------------------------
// CSV parsing
// ---------------------------------------------------------------------------

/// Minimal RFC-4180-aware CSV field splitter.
/// Handles quoted fields containing commas and escaped quotes ("").
List<String> _parseCsvLine(String line) {
  final fields = <String>[];
  var i = 0;
  while (i <= line.length) {
    if (i == line.length) {
      fields.add('');
      break;
    }
    if (line[i] == '"') {
      // Quoted field — scan until closing quote.
      final sb = StringBuffer();
      i++; // skip opening quote
      while (i < line.length) {
        if (line[i] == '"') {
          if (i + 1 < line.length && line[i + 1] == '"') {
            sb.write('"');
            i += 2;
          } else {
            i++; // skip closing quote
            break;
          }
        } else {
          sb.write(line[i]);
          i++;
        }
      }
      fields.add(sb.toString());
      // Skip the comma after the closing quote (if any).
      if (i < line.length && line[i] == ',') {
        i++;
      }
    } else {
      // Unquoted field — read until next comma or end.
      final start = i;
      while (i < line.length && line[i] != ',') {
        i++;
      }
      fields.add(line.substring(start, i));
      i++; // skip comma
    }
  }
  return fields;
}

// ---------------------------------------------------------------------------
// Dart source generation
// ---------------------------------------------------------------------------

/// Escape single quotes and backslashes for use inside a Dart single-quoted string.
String _dartString(String value) {
  // The escaped strings here are intentional — we are generating Dart source
  // code that must contain literal backslashes and escaped single quotes.
  // ignore: prefer_raw_strings
  return value.replaceAll(r'\\', r'\\\\').replaceAll("'", r"\\'");
}

String _toCardBinModel(List<String> fields) {
  // CSV columns (0-indexed):
  // 0: 순번   1: 발급사   2: BIN   3: 전표인자명
  // 4: 개인/법인   5: 브랜드   6: 신용/체크
  // 7: 등록/수정일자   8: 변경사항   9: 비고
  //
  // Each entry is emitted on a single line; `dart format` (run after
  // generation) wraps only the few entries that exceed the page width. This
  // keeps the generated file byte-identical to the committed one so the CI
  // integrity gate can regenerate and diff it.
  final args = <String>[
    'id: ${int.parse(fields[0].trim())}',
    "cardIssuer: '${_dartString(fields[1].trim())}'",
    "bin: '${_dartString(fields[2].trim())}'",
    "factorName: '${_dartString(fields[3].trim())}'",
  ];

  // Fields backed by a model-level @Default — emit only when the value differs
  // from the default, matching the compact form committed to the repo.
  final corporate = fields[4].trim();
  if (corporate.isNotEmpty && corporate != '개인') {
    args.add("corporate: '${_dartString(corporate)}'");
  }
  final brand = fields[5].trim();
  if (brand.isNotEmpty && brand != '로컬') {
    args.add("brand: '${_dartString(brand)}'");
  }
  final creditDebit = fields[6].trim();
  if (creditDebit.isNotEmpty && creditDebit != '신용') {
    args.add("creditDebit: '${_dartString(creditDebit)}'");
  }

  // Optional fields — only emit when non-empty.
  if (fields.length > 7 && fields[7].trim().isNotEmpty) {
    args.add("updatedAt: '${_dartString(fields[7].trim())}'");
  }
  if (fields.length > 8 && fields[8].trim().isNotEmpty) {
    args.add("changed: '${_dartString(fields[8].trim())}'");
  }
  if (fields.length > 9 && fields[9].trim().isNotEmpty) {
    args.add("remarks: '${_dartString(fields[9].trim())}'");
  }

  return '  CardBinModel(${args.join(', ')})';
}

String _buildFile(List<String> entries) {
  final sb = StringBuffer()
    ..write('// 🌎 Project imports:\n')
    ..write("import 'package:credit_card_type_detector_korean/src/card_bin_model.dart';\n")
    ..write('\n')
    ..write('/// The full Korean BIN dataset.\n')
    ..write('///\n')
    ..write('/// **This file is auto-generated.** Do not edit by hand.\n')
    ..write('///\n')
    ..write('/// It is produced by running:\n')
    ..write('/// ```sh\n')
    ..write('/// dart tool/generate_data.dart\n')
    ..write('/// ```\n')
    ..write('/// which reads the externally-downloaded BIN CSV (신용카드 BIN_Table … .csv)\n')
    ..write('/// located in the project root and overwrites this file.\n')
    ..write('/// When the upstream CSV is updated, re-run the script above.\n')
    ..write('const data = [\n');

  for (final entry in entries) {
    sb
      ..write(entry)
      ..write(',\n');
  }

  sb.write('];\n');
  return sb.toString();
}

/// Extract the dataset release date (`YYYY-MM-DD`) from the CSV file name.
///
/// The KICC export is named like `신용카드 BIN_Table(20260428).xls - 상세.csv`,
/// carrying an 8-digit `YYYYMMDD` stamp that identifies the dataset revision.
String _datasetVersion(String csvPath) {
  final name = _pathBasename(csvPath);
  final match = RegExp(r'(\d{4})(\d{2})(\d{2})').firstMatch(name);
  if (match == null) {
    _exit(
      'Could not extract a YYYYMMDD date from the CSV file name: $name\n'
      'Expected a name like "신용카드 BIN_Table(20260428).xls - 상세.csv".',
    );
  }
  return '${match.group(1)}-${match.group(2)}-${match.group(3)}';
}

/// Render `lib/src/dataset_version.dart` for the given [version].
String _buildVersionFile(String version) {
  final sb = StringBuffer()
    ..write('/// The release date of the bundled Korean BIN dataset, in ISO 8601\n')
    ..write('/// (`YYYY-MM-DD`) form.\n')
    ..write('///\n')
    ..write('/// **This file is auto-generated** by `dart tool/generate_data.dart`,\n')
    ..write('/// derived from the source CSV file name. Do not edit by hand.\n')
    ..write('///\n')
    ..write('/// Read this to tell how current the bundled copy of the BIN table is.\n')
    ..write("const datasetVersion = '$version';\n");
  return sb.toString();
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Locate the project root (directory containing pubspec.yaml) by walking up
/// from the CWD.  Assumes the script is run from the project root or a
/// sub-directory thereof.
String _projectRoot() {
  var dir = Directory.current;
  while (true) {
    if (File('${dir.path}/pubspec.yaml').existsSync()) return dir.path;
    final parent = dir.parent;
    if (parent.path == dir.path) {
      _exit('Could not locate pubspec.yaml — are you inside the project?');
    }
    dir = parent;
  }
}

/// Glob for the BIN CSV in [root].  Throws if zero or more than one match.
///
/// Note: macOS HFS+/APFS normalises Korean file names to NFD, so Korean
/// characters returned by [Directory.listSync] may not compare equal to the
/// NFC literals written in source code.  We therefore match only on the ASCII
/// portion of the expected name (`BIN_Table`) together with the `.csv` extension.
String _findCsv(String root) {
  final csvFiles = Directory(root).listSync().whereType<File>().where((f) => _pathBasename(f.path).contains('BIN_Table') && f.path.endsWith('.csv')).toList();

  if (csvFiles.isEmpty) {
    _exit(
      'No CSV file matching "*BIN_Table*.csv" found in $root.\n'
      'Pass the path explicitly: dart tool/generate_data.dart <path>',
    );
  }
  if (csvFiles.length > 1) {
    _exit(
      'Multiple BIN CSV files found. Pass the exact path explicitly.\n'
      'Found: ${csvFiles.map((f) => f.path).join("\n  ")}',
    );
  }
  return csvFiles[0].path;
}

/// Extract the file name from a path without importing `path`.
String _pathBasename(String p) {
  // ignore: prefer_raw_strings
  final sep = Platform.isWindows ? r'\' : '/';
  return p.contains(sep) ? p.substring(p.lastIndexOf(sep) + 1) : p;
}

Never _exit(String message) {
  stderr.writeln('Error: $message');
  exit(1);
}
