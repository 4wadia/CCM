# Database

**Status:** M1. Drift schema v1, SQLCipher encryption, repositories, and the migration
harness are implemented. Later milestones extend the schema through migrations.

## Storage engine

| Item | Choice |
|---|---|
| Access layer | Drift 2.35 |
| Native SQLite | `sqlite3` 3.8 with native-assets hooks |
| Cipher | SQLCipher 4.19.0 community (`source: sqlcipher`) |
| Journal mode | WAL |
| Foreign keys | Enforced per connection |
| Secure delete | Enabled per connection |
| File | `<application-support>/credit_card_manager/ccm.sqlite` |

`hooks.user_defines.sqlite3.source` in `pubspec.yaml` is the only cipher switch. It
replaces the obsolete `sqlcipher_flutter_libs` package. `sqlite3` 3.x also removes
`open.overrideFor`; do not reintroduce it.

## Open sequence

`lib/data/database/database_factory.dart` performs the following in a `setup` callback,
before returning the connection to callers:

1. `PRAGMA key = "x'<64 hex chars>'"` using a random 256-bit key.
2. Read `PRAGMA cipher_version`; throw `DatabaseCipherUnavailableException` if empty.
3. `PRAGMA cipher_memory_security = ON`.
4. `PRAGMA foreign_keys = ON`.
5. `PRAGMA secure_delete = ON`.
6. `PRAGMA journal_mode = WAL`.
7. Read `sqlite_master` to force key validation.

Any failure closes the connection and becomes a `DatabaseOpenException`. There is no
plaintext fallback and no automatic database recreation.

Production uses `NativeDatabase.createInBackground`; the isolate boundary is covered by
an integration test. Tests that inspect WAL files directly use `background: false`.

## Schema v1

| Table | Purpose |
|---|---|
| `banks` | Issuer identity and adapter region |
| `credit_cards` | Card metadata, limit, billing days, lifecycle |
| `categories` | System and user transaction categories |
| `transactions` | Canonical transactions; unassigned imports may keep `card_id` null |
| `transaction_sources` | Raw source provenance and parser metadata |
| `import_jobs` | Import audit counters and status |
| `app_settings` | Non-secret settings; encrypted slot reserved |

Important conventions:

- Money is stored as integer minor units. Floating point is prohibited.
- Calendar dates are stored date-only; audit timestamps are UTC (D-13).
- `credit_cards.cardholder_name` exists only for statement-password rules.
- Full card numbers, CVV, and PIN are never stored.
- Transaction source references are unique per source type; ambiguity is preserved in
  review records rather than dropped.
- Sensitive text is protected by whole-database encryption. Columns are not named
  `*_encrypted` because there is no second application-level cipher layer (D-16).
- `app_settings.encrypted_value` is reserved for values that need protection inside the
  encrypted database. It is unused in M1; secrets belong in platform secure storage.

## Indexes

Created explicitly from `databaseIndexStatements` so future migrations can recreate them:

- Cards: bank, status.
- Transactions: card, date, card + date, normalized merchant, category.
- Sources: transaction, unique `(source_type, source_reference)`.
- Categories: parent.
- Settings: unique `setting_key`.

The unique source index allows multiple `NULL` references, as SQLite permits, while
rejecting duplicate concrete references.

## Seeding

Twelve stable system categories (`cat_groceries` … `cat_other`) are inserted idempotently
when a database is created. No bank or card data is invented. Reopening an existing
database does not reseed.

## Migrations

- `latestSchemaVersion` in `lib/data/database/migrations.dart` is the schema version
  understood by the binary.
- Each forward change adds one numbered entry to `DatabaseMigrations.stepsFor`.
- `applyMigrationPlan` applies steps in ascending order and throws
  `MissingMigrationException` rather than opening a mismatched schema.
- Downgrades are rejected. Destructive column drops are not used without an export path.
- Real schema upgrades begin when schema v2 lands. The sequencing logic is unit-tested
  now with synthetic steps.
- Every migration must be exercised from a populated database, not only a fresh create.

## Connection ownership

`appDatabaseProvider` opens the database lazily and closes it when the provider is
disposed. Repository providers depend on it. M1 does not yet expose data in the UI; the
cards milestone consumes these providers.

## Key handling

`DatabaseKeyProvider` returns 32 bytes from Android Keystore or iOS Keychain. See
`security.md` for wrapping details and failure policy. The key is never stored in the
database, preferences in plaintext, logs, or fixtures.

## Failure modes

| Failure | Behavior |
|---|---|
| SQLCipher not linked | Refuse to open |
| Wrong key | Refuse to open; SQLCipher reports an HMAC failure |
| Key deleted or invalidated | Typed key error; no new key generated |
| Missing migration step | Refuse to open; loud exception |
| Database from a newer app version | Downgrade refused; no write against unknown schema |
| Corrupt database file | Refuse to open; no destructive recovery |
| Foreign-key violation | Statement fails; transaction rolls back |

Recovery of a lost key is only possible through an encrypted backup, which is not
implemented until M8.

## Testing

- `test/integration/database/encryption_test.dart` verifies cipher activation, plaintext
  absence in database/WAL/SHM, reopen, wrong key, deleted key, and the background isolate.
- `test/integration/database/schema_test.dart` verifies tables, indexes, seeds, foreign
  keys, and source uniqueness.
- `test/integration/database/repositories_test.dart` verifies repository round-trips and
  card lifecycle.
- `test/unit/data/migrations_test.dart` verifies step ordering and fail-loud behavior.

No device or iOS database test has run. See `status.md`.
