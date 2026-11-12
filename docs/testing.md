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
| Flow | `test/integration` | `flutter_test` with real repositories | Import → match → review, statement import, backup/restore |
| Platform | manual scripts | Devices/emulators | Permissions, keychain, background, install/upgrade |

## Coverage through M2

- App boots inside a `ProviderScope`; all five destinations render and are reachable via
  the bottom navigation bar; router state is preserved per branch.
- SQLCipher is linked in `flutter test` through the `sqlite3` native-assets hook;
  `PRAGMA cipher_version` is asserted, so encryption tests cannot silently run against
  plain SQLite.
- A sentinel is written and searched for in the database, WAL, and SHM files. None may
  contain the plaintext or a plaintext SQLite header.
- Closing and reopening with the same key preserves data; wrong and deleted keys fail with
  typed errors. A database whose `user_version` is newer than this build is refused.
- The production `NativeDatabase.createInBackground` path is exercised.
- Schema tests assert every table/index, 12 seeded categories, foreign-key enforcement,
  and unique transaction source references.
- Repository tests cover bank/card round-trips, archive/restore/close, settings upsert and
  removal, custom categories, and multi-card persistence across reopen.
- Migration sequencing is unit-tested for order, no-op, downgrade rejection, and a missing
  step. A populated v1 database is upgraded and checked.
- Pure-domain tests group card limits, outstanding, available credit, and utilisation by
  currency; archived/closed cards are excluded and mixed currencies are never added.
- Money tests cover integer minor-unit parsing/formatting, precision, malformed input,
  zero limits, non-negative balances, and unlike-currency arithmetic guards.
- Widget tests cover Home totals, per-card summaries, add/edit validation, outstanding
  persistence, archive confirmation, and last-four-only identity fields.

## Coverage M3–M10

### Transactions and imports

- Fingerprint tests cover determinism, day-only normalization, merchant noise, version
  changes, card/amount/currency/type sensitivity, and null card behavior.
- Card-matcher tests cover unique suffix, masked input, issuer-hint disambiguation,
  ambiguous candidates, unmatched cards, archived cards, and issuer-only matching.
- Import-pipeline tests use the real encrypted database and repositories to cover:
  high-confidence import with provenance, exact duplicate fingerprint linking, idempotent
  source references, ambiguous/unmatched cards, low-confidence review, empty imports, and
  archived-card exclusion.
- Transaction repository tests cover atomic transaction/source insert, filters (card,
  review-only, unassigned, type, date, amount, merchant, source), category/merchant/card/
  status updates, fingerprint lookup, fuzzy candidates, source linking, and deletion.
- Review repository tests cover add/deduplicate, open count/list, resolve-for-entity,
  resolve, dismiss, and delete-all.

### SMS

- Synthetic SMS tests cover purchases with amount/merchant/date/card, amount-before-
  currency, timestamp fallback, OTP/promotional exclusion, declined alerts, refunds,
  payments, cash advances, fees, and malformed/zero-amount messages.
- Regression tests cover `refunded`/`reversed` recognition and merchant extraction
  stopping at `using`/`with`.
- No real SMS corpus or device permission test exists.

### Gmail and email classification

- Classifier tests cover PDF + statement subject + known issuer + card suffix, PDF-only
  candidates, unrelated email, and non-PDF attachments.
- Gmail sync is implemented with fakeable client/token interfaces, but real OAuth and
  network sync are not exercised because no Google Cloud project is configured.

### PDF statements

- Password-strategy tests cover user-provided passwords, name + birth date, month-name
  formats, customer ID + date, card suffix + date, inactive/invalid rules, missing inputs,
  and deduplication.
- Statement-parser tests cover metadata, date/period/due-date extraction, total/minimum/
  previous balance, table-like rows, refund/fee markers, undated fallback rows, currency
  and card defaults, and summary-line skipping.
- Encrypted-file tests cover opaque names, ciphertext at rest, round-trip, unique names,
  wrong-key authentication failure, path traversal rejection, deletion, and key-loss
  failure.
- Statement-import integration tests cover successful extraction/matching/reconciliation,
  rule-derived password retry, duplicate file hash, password-protected fallback review,
  extraction-failure fallback, total mismatch review, unmatched-card review, and invalid/
  oversized/non-PDF input.
- Real bank statement fixtures are not available; the generic parser is not labelled as
  verified for any bank.

### Rewards and analytics

- Reward-calculator tests cover percentage basis points, flat cashback, monthly caps,
  exhausted caps, ineligible credits/payments/refunds, zero/negative purchases, currency
  mismatch, category/merchant eligibility, labelled point estimates, and expired points.
- Repository tests cover cashback rules/entries, reward accounts/entries, and deletion.
- Widget tests cover cashback summary, reward accounts, rule descriptions, and recent
  entries.

### Backup and wipe

- Backup tests cover encrypted output with no plaintext merchant/email/token/file name,
  manifest counts, restore/re-encrypt statement files, removal of stale transactions,
  token removal, wrong-password rejection without data change, short-password rejection,
  malformed/tampered envelopes, table allow-list, and stable magic.
- Local wipe is covered by implementation review and settings UI; device-level deletion
  still needs a physical-device check.

### Widget coverage

`test/unit/features/feature_pages_test.dart` covers:

- Transactions: review banner, ledger list, filter sheet, transaction detail, sources,
  review queue, assign/resolve/dismiss controls.
- Statements: statement list, totals, review status, detail sheet, extracted rows.
- Rewards: cashback totals, reward accounts, declarative rules, recent entries.
- Settings: local-only messaging, Gmail-disabled state, Android SMS controls, backup
  explanation, import history, and footer.
- Card detail: metrics, recent transactions, reward points, billing days, and navigation.

## Commands

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
```

`./tool/check.sh` runs the local gate.

## Current result

- `dart format`: clean.
- `flutter analyze`: no issues.
- `flutter test`: 165/165 pass on the Linux host.
- `flutter build apk --debug`: success; APK at
  `build/app/outputs/flutter-apk/app-debug.apk`.

## Required but not run

| Check | Reason |
|---|---|
| iOS build, Keychain, TestFlight | No macOS host |
| Android Keystore/SMS/permission runtime | No physical device; no `/dev/kvm` |
| Real Gmail OAuth/sync | Requires Google Cloud project, client ID, test users |
| Verified bank SMS/PDF adapters | Requires anonymized real-world samples |
| Release signing/store install | Owner-supplied credentials |

## Fixture policy

- `test/fixtures/` holds generated or synthetic data with a documented origin.
- PDFs are generated by a checked-in script so they can be regenerated and reviewed.
- SMS fixtures use fictional senders, card suffixes, and merchants.
- A pre-commit review must confirm no fixture resembles real account data.

## Reporting

Each milestone report includes: test count, pass/fail, coverage notes, commands run,
device/build results, and any tests that could not run with the reason.
