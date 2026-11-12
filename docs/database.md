# Database

**Status:** M3–M10 host-verified. Drift schema v3, SQLCipher encryption, repositories, and
the migration harness are implemented. The schema covers transactions, statements, review
items, rewards, cashback, email metadata, and sync checkpoints.

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
| Statement files | `<application-support>/credit_card_manager/statements/*.ccmenc` |

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

## Schema v3

| Table | Purpose |
|---|---|
| `banks` | Issuer identity and adapter region |
| `credit_cards` | Card metadata, limit, reconciled outstanding balance, billing days, lifecycle |
| `categories` | System and user transaction categories |
| `transactions` | Canonical transactions; unassigned imports may keep `card_id` null; SHA-256 fingerprint |
| `transaction_sources` | Raw source provenance, source date, parser metadata, match status |
| `import_jobs` | Import audit counters, progress, status, error code |
| `app_settings` | Non-secret settings and import checkpoints; encrypted slot reserved |
| `review_items` | Open/resolved/dismissed uncertainty records with source provenance |
| `statements` | Encrypted statement metadata, totals, parser identity, processing status |
| `statement_transactions` | Extracted statement rows and their matched transaction |
| `cashback_rules` | Declarative flat/percentage rules in basis points and minor units |
| `cashback_entries` | Cashback earned, credited, reversed, or adjusted |
| `reward_accounts` | Programme name, current points, labelled estimated value |
| `reward_entries` | Earned/redeemed/adjusted/expired point entries |
| `bank_rules` | Declarative statement-password strategies, never executable code |
| `email_accounts` | Gmail address, status, and an opaque secure-token reference |
| `sync_checkpoints` | Provider checkpoint, timestamps, status, and error code |

Important conventions:

- Money is stored as integer minor units. Floating point is prohibited.
- Cashback percentages are stored in basis points (1% = 100). Caps and flat amounts use
  minor units. Reward points are integers; point value is a labelled estimate only.
- `credit_cards.current_outstanding_minor` (schema v2) is the user-entered reconciled
  balance used by the dashboard. It is never computed by summing lifetime purchases
  (D-19). It defaults to zero when upgrading a v1 database.
- Calendar dates are stored date-only where they represent statement/transaction days;
  audit timestamps are UTC (D-13).
- `credit_cards.cardholder_name` exists only for statement-password rules.
- Full card numbers, CVV, and PIN are never stored.
- `transactions.fingerprint` is versioned. The fingerprint includes card, signed amount,
  currency, day, normalized merchant, and transaction type. A missing card yields no
  fingerprint.
- Transaction source references are unique per source type; ambiguity is preserved in
  review records rather than dropped.
- Gmail access/refresh tokens are never stored in these tables. `email_accounts` stores
  only `secure_token_reference`; tokens live in Android Keystore-backed storage or the
  iOS Keychain.
- Statement PDFs are stored as AES-256-GCM `.ccmenc` files with opaque names. The database
  stores the opaque name, file hash, and size, never plaintext.
- Sensitive text is protected by whole-database encryption. Columns are not named
  `*_encrypted` because there is no second application-level cipher layer (D-16).
- `app_settings.encrypted_value` is reserved for values that need protection inside the
  encrypted database. It is unused so far; secrets belong in platform secure storage.

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
when a database is created or upgraded. No bank or card data is invented. Reopening an
existing database does not reseed.

## Migrations

- `latestSchemaVersion` in `lib/data/database/migrations.dart` is `3`.
- `AppDatabase.migration` supplies numbered steps that reference Drift's generated table
  and column objects.
- The v2 step adds `current_outstanding_minor` with a default of `0`.
- The v3 step creates the new tables and adds `transactions.fingerprint`,
  `transactions.fingerprint_version`, and `transaction_sources.source_date` if missing.
  It recreates indexes and reseeds categories idempotently, so populated v1 and v2
  databases upgrade safely.
- `DatabaseMigrations.run` rejects downgrades and newer schemas before applying steps.
  `applyMigrationPlan` applies steps in ascending order and throws
  `MissingMigrationException` rather than opening a mismatched schema.
- Destructive column drops are not used without an export path.
- Migration sequencing is unit-tested with synthetic steps. The upgrade is tested against
  a populated v1 database created with the old table definition.
- Every migration must be exercised from a populated database, not only a fresh create.

## Connection ownership

`appDatabaseProvider` opens the database lazily and closes it when the provider is
disposed. Repository providers depend on it, and every feature consumes those repositories.
Startup still does not block on key/keystore work. Full local wipe closes the database,
deletes the database and statement files, and removes database/file keys plus Gmail tokens.

## Key handling

`DatabaseKeyProvider` returns 32 bytes from Android Keystore or iOS Keychain. See
`security.md` for wrapping details and failure policy. The key is never stored in the
database, preferences in plaintext, logs, or fixtures. Statement files use a separate
32-byte key in platform secure storage.

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
| Encrypted statement file missing/corrupt | Statement row remains; review/error surfaces; no plaintext fallback |
| Backup restore fails before table replacement | Newly written files are deleted; active data is unchanged |
| Backup restore fails during table replacement | Transaction rolls back; newly written files are deleted |

Recovery of a lost key is possible only through an encrypted backup (M8) created before
key loss. A backup does not contain device keys or OAuth tokens.

## Testing

- `test/integration/database/encryption_test.dart` verifies cipher activation, plaintext
  absence in database/WAL/SHM, reopen, wrong key, deleted key, and the background isolate.
- `test/integration/database/schema_test.dart` verifies all v3 tables, columns, indexes,
  seeds, foreign keys, and source uniqueness.
- `test/integration/database/migration_v2_test.dart` upgrades a populated v1 database,
  checks the new column, preserves the card, and round-trips an outstanding balance.
- `test/integration/database/repositories_test.dart` verifies core repository round-trips,
  multi-card persistence across reopen, and card lifecycle.
- `test/integration/database/repositories_v3_test.dart` covers transaction filters and
  provenance, review lifecycle, statement rows, cashback/reward rules, email checkpoints,
  and bank rules.
- `test/integration/database/import_pipeline_test.dart` covers idempotency, fingerprints,
  review creation, and card matching.
- `test/unit/data/migrations_test.dart` verifies step ordering and fail-loud behavior.

No device or iOS database test has run. See `status.md`.
