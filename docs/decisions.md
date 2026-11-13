# Decision log

Decisions are recorded when made. A decision marked **proposed** uses the recommended
default until the owning milestone validates it; if validation fails, the entry is
superseded and the reason recorded.

| ID | Decision | Status | Milestone | Rationale / notes |
|---|---|---|---|---|
| D-01 | App ID `app.creditcardmanager`, display name "Credit Card Manager" | Proposed | M0 | Cheap to change before store registration; revisit before M10 |
| D-02 | Encrypted SQLite implementation: SQLCipher 4.19 community via `sqlite3` 3.x hooks | Accepted | M1 | SQLCipher met the encryption, WAL, migration, reopen, and wrong-key requirements first, so SQLite3MultipleCiphers was not prototyped. Host tests report `cipher_version 4.19.0 community`; the debug APK bundles `libsqlcipher.so` for all shipped ABIs |
| D-03 | PDF engine: `syncfusion_flutter_pdf` | Accepted | M6 | Local AES-256 PDF open and text extraction on-device; no content leaves the device. Generic parser only; bank adapters remain unverified until anonymized fixtures exist |
| D-04 | OAuth: Android Google Play services authorization; iOS Authorization Code + PKCE | Accepted | M5 | Android uses `AuthorizationClient` because Google no longer accepts custom URI schemes on Android; no client ID or refresh token is embedded. iOS uses `flutter_appauth`. Tokens stay in platform secure storage; the DB stores only an opaque reference. Real Google Cloud validation remains pending |
| D-05 | Android SMS target device | Open | M4 | Restricted permission behavior varies by installer/OEM; physical device required |
| D-06 | Bank fixture corpus | Open | M4/M6 | Synthetic/redacted only; no verified label without representative samples |
| D-07 | Backup: `.ccmbackup` v1, Argon2id + AES-256-GCM | Accepted | M8 | Argon2id (64 MiB, 3 iterations, parallelism 2) derives an independent key; AES-256-GCM authenticates magic/salt as AAD. Logical table allow-list excludes tokens, keys, email accounts, and sync checkpoints |
| D-08 | Biometric gate at app launch; DB key device-unlock protected | Proposed | M1 | Not implemented in M1. Current protection is device unlock plus Keystore/Keychain; the Keystore wrapping key does not require user authentication. Must be resolved before M10 |
| D-09 | Separate totals per currency | Accepted | M2 | No conversion in v1 per specification §14.3 |
| D-10 | iOS validation requires macOS hardware | Blocked | M9 | No iOS support claim until device/TestFlight validation |
| D-11 | Signing identities and store accounts | Open | M10 | Owner-supplied |
| D-12 | First-wave banks: HDFC, ICICI, SBI Card, Axis, Amex | Proposed | M4/M6 | Candidates only; adapter tier reflects actual fixture coverage |
| D-13 | Calendar dates stored date-only; audit timestamps UTC | Accepted | M1/M3 | Transaction/statement days are normalized to date-only; import, review, and sync audit timestamps are UTC |
| D-14 | Merchant normalization stored unencrypted for indexing | Accepted | M3 | Follows specification §15.1; the whole database remains SQLCipher-encrypted and the residual indexing risk is documented |
| D-15 | No forced base currency | Accepted | M2 | Per-card currency; dashboard groups totals |
| D-16 | Whole-database encryption, no application-level column cipher | Accepted | M1 | SQLCipher encrypts the database, WAL, and SHM files. Sensitive columns keep clear names (`merchant_original`, `notes`, `cardholder_name`) instead of an `_encrypted` suffix because a second AES layer would add complexity without protecting against a different threat. `app_settings.encrypted_value` remains the reserved slot for values needing an inner cipher |
| D-17 | Key storage implementation | Accepted | M1 | Android generates a random 32-byte key and wraps it with a non-exportable AES-256-GCM Keystore key; only ciphertext is persisted in app-private preferences. iOS stores the 32-byte key as a non-synchronizing Keychain generic-password item with `AfterFirstUnlockThisDeviceOnly`. Both fail closed on loss and never auto-recreate a key |
| D-19 | Reconciled `current_outstanding_minor` on `credit_cards` (schema v2) | Accepted | M2 | Specification §14.2 requires `activeCard.currentOutstanding` and forbids deriving it from lifetime purchases, but §15.1 does not list a balance column. Schema v2 stores a user-entered reconciled balance in integer minor units, defaulting to 0 for existing cards. M3/M6 will reconcile it against transactions and statements while preserving source values |
| D-20 | Platform typography, no runtime font fetching | Accepted | M2 | The app is local-first and must render offline without unsolicited network requests. The direct `google_fonts` and `intl` dependencies were removed; typography uses the platform font stack and currency formatting uses a maintained ISO minor-digit table |
| D-18 | No plaintext fallback or automatic database reset | Accepted | M1 | Opening verifies `cipher_version` and reads the schema before the database is returned. Missing SQLCipher, a wrong key, a corrupt file, or a missing migration step aborts the open. Recovery is deferred to encrypted backups (M8) |
| D-21 | Cashback percentages use basis points; caps and flat amounts use minor units | Accepted | M7 | Avoids floating-point money. Reward points are integers and estimated value is explicitly labelled; points are never assumed without a rule |
| D-22 | Statement PDFs: AES-256-GCM under opaque names with a separate secure-storage file key | Accepted | M6 | Plaintext exists only in memory for extraction. The database stores the opaque name, SHA-256 hash, and size |
| D-23 | Every imported record is accounted for; uncertainty goes to review | Accepted | M3 | Unmatched, ambiguous, low-confidence, failed, duplicate-ambiguous, and non-reconciling records keep provenance and create review items rather than being dropped |
| D-24 | Gmail tokens only in platform secure storage; DB stores an opaque reference | Accepted | M5 | Backups exclude email accounts, checkpoints, and tokens. Disconnect revokes remotely when possible and always removes local tokens |
| D-25 | Backup restore re-encrypts statement files and removes stale tokens | Accepted | M8 | Restore writes new `.ccmenc` files under the target device key, updates statement paths in a transaction, deletes old files, and removes tokens for pre-restore accounts |
| D-26 | Generic SMS/PDF parsers are conservative; no bank adapter is labelled verified without fixtures | Accepted | M4/M6 | Ambiguous or unparsed transactional-looking input becomes review data. Verified labels require anonymized real-world samples |

## Format for new decisions

```text
ID: D-XX
Title:
Status: proposed | accepted | superseded
Date:
Context:
Decision:
Consequences:
Supersedes / superseded by:
```
