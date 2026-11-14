# Security

**Status:** M3–M10 host-verified. Encrypted database and key management, encrypted
statement files, encrypted backups, secure OAuth token storage, and local wipe are
implemented. Host tests and the Android debug build pass. iOS code is written but not
compiled or run because there is no macOS host, and no Android device or emulator is
available for runtime permission/keystore tests.

## Assets to protect

- Card metadata and transaction history.
- Statement PDFs and email metadata.
- SMS messages used for import.
- OAuth access and refresh tokens.
- Database, statement-file, and backup encryption keys.
- PDF passwords and the personal values used to derive them.

## Threats considered

| Threat | Control direction |
|---|---|
| Device loss / theft | Encrypted database; device-level key protection; biometric app gate deferred |
| Backup extraction | Android backup disabled; iOS Keychain item is device-only; encrypted `.ccmbackup` requires a separate password; iOS file exclusion pending M9 |
| Malicious PDF | Local validation, size limit, no script execution, no network |
| Log leakage | Single logging facade; no payload logging; redaction tests |
| Malicious or buggy bank adapter | Constrained declarative password/cashback rules; no code/eval from email or statement content |
| Token theft | Platform secure storage only; opaque reference in DB; revoke on disconnect; backups exclude tokens |
| Shoulder surfing / screenshots | Deferred to the design workstream; platform secure-flag support evaluated |
| Rooted/jailbroken device | Out of scope for v1; documented as a residual risk |
| Backup tampering | AES-256-GCM authentication; wrong password/tamper fails before table replacement |

## Non-negotiable controls

- Database encrypted at rest with a vetted SQLite cipher; no custom crypto.
- Keys generated randomly, wrapped by Android Keystore / stored in iOS Keychain, never
  hardcoded.
- Journal, WAL, temporary, and backup files verified not to leak plaintext.
- Statement files encrypted at rest with AES-256-GCM and opaque names in app-private
  storage. Plaintext exists only in memory during extraction.
- No CVV, PIN, internet-banking password, or full card number stored.
- No sensitive content in logs, error messages, analytics, or crash reports.
- Gmail tokens never stored in ordinary database columns or preferences.
- Backup envelopes are authenticated and exclude OAuth tokens and device keys.
- Full local wipe destroys the database, statement files, keys, and tokens.

## Implemented controls

### Database and keys

- **Cipher:** SQLCipher 4.19.0 community, linked through the `sqlite3` 3.x hook
  (`hooks.user_defines.sqlite3.source: sqlcipher`). The Android APK contains
  `libsqlcipher.so` for arm64-v8a, armeabi-v7a, and x86_64.
- **Fail closed:** every connection verifies `PRAGMA cipher_version` before use. If
  SQLCipher is absent, opening fails instead of writing plaintext.
- **Key verification:** a schema read runs during setup; a wrong or corrupt key fails the
  open and is wrapped in `DatabaseOpenException`.
- **Encryption at rest:** integration tests write a sentinel, then inspect the database,
  WAL, and SHM files. No plaintext sentinel or plaintext SQLite header is present.
- **Key protection:**
  - Android: a random 256-bit database key is wrapped with a non-exportable AES-256-GCM
    Android Keystore key. Only ciphertext is stored in app-private preferences.
  - iOS: a random 256-bit key is stored as a Keychain generic-password item with
    `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` and synchronization disabled.
- **Key loss is terminal by design:** if wrapped/Keychain material exists but cannot be
  read, the channel returns a typed error. It never generates a replacement key.
- **Memory hygiene:** raw key bytes are zeroed in Dart after hex encoding, in Kotlin after
  wrapping/unwrapping, and in Swift after copying to Keychain data. The hex form is
  required by SQLCipher's raw-key pragma and remains in memory for connection setup only.

### Encrypted statement files

- `EncryptedFileStore` derives a separate 32-byte file key from platform secure storage.
- Every file is AES-256-GCM encrypted with a fresh nonce and authenticated with a
  `CCMF1` magic prefix.
- Stored names are random base64url tokens plus a short hash of the suggested name; the
  original filename is not used as a path.
- Path traversal and non-`.ccmenc` names are rejected.
- Reads authenticate before returning plaintext; a wrong key fails with `CCM-FILE-003`.
- Statement text is extracted locally with `syncfusion_flutter_pdf` from in-memory bytes;
  no plaintext PDF is written to disk and no content leaves the device.

### Gmail OAuth and tokens

- Android uses Google Play services `AuthorizationClient`; no client ID, client secret, or
  refresh token is embedded in the APK. The Android OAuth client is identified by the
  package name and signing certificate registered in Google Cloud.
- iOS uses Authorization Code + PKCE through `flutter_appauth`; the public client
  configuration is supplied at build time with `GMAIL_CLIENT_ID` and optionally
  `GMAIL_REDIRECT_URI`.
- Access tokens are stored only in `flutter_secure_storage` (Android Keystore-backed or
  iOS Keychain), under an opaque reference. iOS may also store a refresh token there.
- The database stores only `email_accounts.secure_token_reference`.
- Disconnect attempts remote revocation, then always deletes local tokens and marks the
  account disconnected.
- Backups exclude `email_accounts` and `sync_checkpoints`; a restore removes tokens for
  accounts that existed before the restore.
- Gmail message bodies are not stored. Candidate metadata keeps sender domain, timestamp,
  and reason; raw email content is not logged.
- Gmail search is restricted to credit-card statement PDFs. Debit-card, bank-account,
  savings, UPI, ATM, and wallet subjects are excluded before download, and a classifier
  skips any remaining non-card candidates without creating review items.
- Gmail sync refuses to start until at least one active card exists, so no inbox data is
  fetched for an empty portfolio.

### Android SMS

- `READ_SMS` is declared and requested at runtime only on Android.
- iOS reports SMS import as unsupported; the app never claims iOS SMS inbox access.
- Only transaction-alert-shaped messages are parsed. Unparsed transactional-looking
  messages become review items.
- Review metadata for unparsed SMS stores sender and timestamp, not the message body.
- Raw SMS bodies are never uploaded or logged.
- SMS import requires an active card and permission before the inbox query runs; the
  no-card guard is tested with a fake platform that records reads.

### PDF statement processing

- Files must begin with a PDF marker and are limited to 25 MB.
- Duplicate file hashes return the existing statement instead of creating another.
- Password candidates come from constrained declarative bank rules or a user-provided
  password. Rules are JSON data, never executable code.
- Passwords and derived personal values are held only in memory for the extraction
  attempt and are never logged or stored.
- Password-protected or unreadable files are retained encrypted for review; they are not
  discarded.
- Parsed transactions are reconciled against previous balance plus line sum and total due.
  A mismatch creates a review item rather than silently trusting the statement.

### Backup and restore

- `.ccmbackup` v1 uses Argon2id (parallelism 2, 64 MiB memory, 3 iterations) to derive a
  256-bit key from a password of at least 12 characters.
- The payload is AES-256-GCM encrypted with a random salt and nonce; magic and salt are
  authenticated as additional data.
- The logical export contains only an allow-listed set of tables: banks, cards,
  categories, imports, transactions, sources, settings, reviews, statements, statement
  rows, cashback, rewards, and bank rules.
- OAuth tokens, secure-storage keys, `email_accounts`, and `sync_checkpoints` are excluded.
- Statement PDFs are decrypted from device storage and re-encrypted inside the backup
  envelope. On restore they are re-encrypted under the target device's file key and the
  old files are deleted.
- Restore validates magic, format version, schema compatibility, and password before
  replacing tables. It writes new statement files first; on table failure it deletes the
  new files and the database transaction rolls back.
- After a successful restore, tokens for accounts that existed before the restore are
  deleted from secure storage.

### Local wipe

`LocalDataService.wipeAll` deletes Gmail tokens, all encrypted statement files, the
database, the statement-file key, and the database key. There is no remote copy to delete.
The UI requires explicit confirmation.

## Key lifecycle

1. First launch generates 32 random bytes on the native side.
2. Android wraps them with a Keystore AES-GCM key; iOS stores them as a device-only
   Keychain item protected by the OS Keychain.
3. Dart receives the key only to open the database, computes the SQLCipher raw-key hex
   form, and zeroes the byte buffer.
4. `NativeDatabase.createInBackground` opens SQLite on a dedicated isolate in production.
5. On reopen, the same wrapped/Keychain key is recovered. Losing the key or failing
   authentication surfaces an error; the database is not recreated.
6. Recovery requires an encrypted backup created before key loss.

**Biometric gate:** D-08 remains proposed. The app does not implement an app-launch
biometric prompt. Protection is currently device unlock plus Keystore/Keychain; Android's
wrapping key does not require user authentication. The biometric design workstream must
revisit D-08 before release hardening.

## Platform backup exclusion

- **Android:** `allowBackup=false` plus `res/xml/data_extraction_rules.xml`; verified in
  the built APK manifest.
- **iOS:** the Keychain item is `ThisDeviceOnly` and non-synchronizing. The database file
  itself lives in Application Support and is **not yet** marked
  `NSURLIsExcludedFromBackupKey`. This remains release-blocking for the iOS validation
  milestone.

## Logging rules

Never log: card numbers, CVV, PIN, SMS content, email content, statement text, PDF
passwords, OAuth tokens, encryption keys, backup passwords, or birth dates used in
password rules.

Allowed: stable error codes, counts, durations, parser IDs and versions, adapter tier,
sender domains, and non-identifying status values.

## Residual risks

- Merchant normalization is indexed and stored in the whole-database-encrypted file but is
  not separately encrypted (specification §15.1, D-14, D-16).
- Background database work opens without an interactive biometric check by design.
- iOS Keychain, file backup exclusion, and OAuth behavior are statically reviewed only;
  no iOS runtime evidence exists.
- The SQLCipher test vector is the host Linux build from the `sqlite3` hook. Android use
  is proven by linkage in the APK, not by an on-device open.
- Android SMS permission behavior varies by OEM and installer; no device test has run.
- Real Gmail OAuth has not been exercised; it requires a Google Cloud project and test
  users.
- PDF encryption variants unsupported by Syncfusion must fail closed into review.
- Rooted/jailbroken devices and memory scraping by a privileged attacker are out of scope.
