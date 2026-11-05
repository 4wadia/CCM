# Decision log

Decisions are recorded when made. A decision marked **proposed** uses the recommended
default until the owning milestone validates it; if validation fails, the entry is
superseded and the reason recorded.

| ID | Decision | Status | Milestone | Rationale / notes |
|---|---|---|---|---|
| D-01 | App ID `app.creditcardmanager`, display name "Credit Card Manager" | Proposed | M0 | Cheap to change before store registration; revisit before M10 |
| D-02 | Encrypted SQLite implementation: SQLCipher 4.19 community via `sqlite3` 3.x hooks | Accepted | M1 | SQLCipher met the encryption, WAL, migration, reopen, and wrong-key requirements first, so SQLite3MultipleCiphers was not prototyped. Host tests report `cipher_version 4.19.0 community`; the debug APK bundles `libsqlcipher.so` for all shipped ABIs |
| D-03 | PDF engine | Open | M6 | Require on-device AES-256 (R6) open, text extraction, license approval |
| D-04 | OAuth: Authorization Code + PKCE, no client secret | Proposed | M5 | Native mobile flow; prove refresh/revoke behavior before building on it |
| D-05 | Android SMS target device | Open | M4 | Restricted permission behavior varies by installer/OEM; physical device required |
| D-06 | Bank fixture corpus | Open | M4/M6 | Synthetic/redacted only; no verified label without representative samples |
| D-07 | Backup: `.ccmbackup` v1, Argon2id + AES-256-GCM | Proposed | M8 | Versioned manifest, integrity metadata, independent of device key |
| D-08 | Biometric gate at app launch; DB key device-unlock protected | Proposed | M1 | Not implemented in M1. Current protection is device unlock plus Keystore/Keychain; the Keystore wrapping key does not require user authentication. Must be resolved before M10 |
| D-09 | Separate totals per currency | Proposed | M2 | No conversion in v1 per specification §14.3 |
| D-10 | iOS validation requires macOS hardware | Blocked | M9 | No iOS support claim until device/TestFlight validation |
| D-11 | Signing identities and store accounts | Open | M10 | Owner-supplied |
| D-12 | First-wave banks: HDFC, ICICI, SBI Card, Axis, Amex | Proposed | M4/M6 | Candidates only; adapter tier reflects actual fixture coverage |
| D-13 | Calendar dates stored date-only; audit timestamps UTC | Proposed | M1 | Avoids timezone drift in statement matching |
| D-14 | Merchant normalization stored unencrypted for indexing | Proposed | M3 | Follows specification §15.1; residual privacy risk documented |
| D-15 | No forced base currency | Proposed | M2 | Per-card currency; dashboard groups totals |
| D-16 | Whole-database encryption, no application-level column cipher | Accepted | M1 | SQLCipher encrypts the database, WAL, and SHM files. Sensitive columns keep clear names (`merchant_original`, `notes`, `cardholder_name`) instead of an `_encrypted` suffix because a second AES layer would add complexity without protecting against a different threat. `app_settings.encrypted_value` remains the reserved slot for values needing an inner cipher |
| D-17 | Key storage implementation | Accepted | M1 | Android generates a random 32-byte key and wraps it with a non-exportable AES-256-GCM Keystore key; only ciphertext is persisted in app-private preferences. iOS stores the 32-byte key as a non-synchronizing Keychain generic-password item with `AfterFirstUnlockThisDeviceOnly`. Both fail closed on loss and never auto-recreate a key |
| D-18 | No plaintext fallback or automatic database reset | Accepted | M1 | Opening verifies `cipher_version` and reads the schema before the database is returned. Missing SQLCipher, a wrong key, a corrupt file, or a missing migration step aborts the open. Recovery is deferred to encrypted backups (M8) |

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
