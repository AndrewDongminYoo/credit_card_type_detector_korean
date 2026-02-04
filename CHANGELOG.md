# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.1.0+1

- Initial public release.
- Korean domestic BIN detection via `CreditCardTypeDetectorKorean.detect()`.
- Combined Korean + international brand detection via `detectCard()`.
- Query helpers: `findByIssuer`, `findByBrand`, `findByCardType`, `findByCorporate`.
- Bundled BIN dataset (3 612 entries) generated from the official KICC BIN table.
- Data-regeneration script at `tool/generate_data.dart`.
