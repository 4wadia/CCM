# Testing

## Principles

- Every feature ships with tests in the same change.
- Tests never contain real card numbers, statements, SMS exports, OAuth tokens, or
  personal password data. Fixtures are synthetic or irreversibly anonymized.
- Security and data-integrity tests are never skipped to make a build pass.
- Platform unavailability (for example, no macOS host) is recorded as a known limitation,
  not silently ignored.
- Bug fixes add a regression test.

## Layers

| Layer | Location | Tooling | Purpose |
|---|---|---|---|
| Unit | `test/unit` | `flutter_test`, `mocktail` | Money, calculations, parsers, matching, rules |
| Widget | `test/unit/...` or feature-local | `flutter_test` | Screen behavior, validation, navigation |
| Data | `test/integration` | Drift test harness | Encryption, migrations, constraints, rollback |
| Flow | `test/integration` | `integration_test` | Card → import → match → dashboard |
| Platform | manual scripts | Devices/emulators | Permissions, keychain, background, install/upgrade |

## M0 coverage

- App boots inside a `ProviderScope`.
- All five destinations render and are reachable via the bottom navigation bar.
- Router state is preserved per branch (indexed stack).
- Provider override works, proving the Riverpod wiring is testable.

No database or network tests exist yet by design.

## M1 coverage

- SQLCipher is linked in `flutter test` through the `sqlite3` native-assets hook;
  `PRAGMA cipher_version` is asserted, so the encryption tests cannot silently run
  against plain SQLite.
- A sentinel bank name is written and then searched for in the database, WAL, and SHM
  files. None may contain the plaintext or a plaintext SQLite header.
- Closing and reopening with the same key preserves data; a wrong key and a deleted key
  both fail with typed errors. A database whose `user_version` is newer than this build
  is refused rather than opened against an unknown schema.
- The production `NativeDatabase.createInBackground` path is exercised, not just the
  direct-connection test path.
- Schema tests assert every v1 table and index, 12 seeded categories, foreign-key
  enforcement, and unique transaction source references.
- Repository tests cover bank/card round-trips, archive/restore/close, settings upsert and
  removal, and custom categories.
- Migration sequencing is unit-tested for order, no-op, downgrade rejection, and a missing
  step. A populated v1 database is upgraded to v2 and checked for the new outstanding
  column, preserved card data, and default value.
- The Dart side of the key channel is tested with a mock binary messenger for valid,
  wrong-length, malformed, platform-error, and delete responses.
- No tests are skipped. The expected SQLCipher stderr lines from the wrong-key test are
  diagnostics, not failures.
- Android and iOS native key stores are compiled/validated only as far as this host
  allows: Android is compiled by the debug APK build; iOS is not compiled.

## M2 coverage

- Pure-domain tests group active card limits, outstanding balances, available credit, and
  utilisation by currency; archived/closed cards are excluded and mixed currencies are
  never added together. Overall utilisation is omitted when currencies are mixed.
- Money tests cover exact integer minor-unit parsing and formatting for zero-, two-,
  three-, and four-fraction-digit currencies, invalid precision, malformed input, zero
  limits, non-negative balances, and unlike-currency arithmetic guards.
- Zero-limit utilisation is asserted to be `null`; over-limit utilisation remains a
  derived percentage above 100 rather than silently clamping the money values.
- Widget tests cover Home currency totals, outstanding/available credit, utilisation,
  per-card summaries, the last-four-only identity fields, add/edit form validation,
  outstanding persistence, and archive confirmation.
- Encrypted repository tests cover card persistence, outstanding round-trips, multiple
  cards surviving a close/reopen, and archive/restore/close lifecycle.
- The v2 migration test upgrades a populated v1 database rather than only creating a
  fresh schema.

## Commands

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test        # when integration tests exist
```

## Planned coverage by milestone

| Milestone | Required tests |
|---|---|
| M1 | Encryption at rest, reopen, FKs, migrations, rollback, wrong/corrupt key |
| M2 | Currency-grouped limits, minor-unit conversion, mixed currency, zero limit, card CRUD/archive |
| M3 | Fingerprint stability, idempotent re-import, ambiguity → review, filters |
| M4 | Synthetic SMS corpus, OTP exclusion, permission denied, no content in logs |
| M5 | MIME parsing, discovery confidence, token absence, resumable sync |
| M6 | Password strategies, corrupt/oversized PDFs, totals validation, reconciliation |
| M7 | Cashback caps, reversals, expiry boundaries, labeled estimates |
| M8 | Backup round-trip, wrong password, tamper detection, failed restore safety |
| M9 | iOS keychain, background delay, TestFlight smoke |
| M10 | Regression matrix, upgrade paths, permission matrix |

## Fixture policy

- `test/fixtures/` holds generated or synthetic data with a documented origin.
- PDFs are generated by a checked-in script so they can be regenerated and reviewed.
- SMS fixtures use fictional senders, card suffixes, and merchants.
- A pre-commit review must confirm no fixture resembles real account data.

## Reporting

Each milestone report includes: test count, pass/fail, coverage notes, commands run,
device/build results, and any tests that could not run with the reason.
