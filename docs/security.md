# Security

**Status:** M1 — encrypted database and key management are implemented. Host tests and
the Android build pass. iOS code is written but not compiled or run because there is no
macOS host, and no Android device or emulator is available for keystore runtime tests.

## Assets to protect

- Card metadata and transaction history.
- Statement PDFs and email metadata.
- SMS messages used for import.
- OAuth access and refresh tokens.
- Database encryption key.
- PDF passwords and the personal values used to derive them.

## Threats considered

| Threat | Control direction |
|---|---|
| Device loss / theft | Encrypted database; device-level key protection; biometric app gate deferred |
| Backup extraction | Android backup disabled; iOS Keychain item is device-only; iOS file exclusion pending M8/M9 |
| Malicious PDF | Local validation, size/time limits, no script execution, no network |
| Log leakage | Single logging facade; no payload logging; redaction tests |
| Malicious or buggy bank adapter | Constrained declarative rules; no code/eval from email content |
| Token theft | Platform secure storage only; opaque reference in DB; revoke on disconnect |
| Shoulder surfing / screenshots | Deferred to the design workstream; platform secure-flag support evaluated |
| Rooted/jailbroken device | Out of scope for v1; documented as a residual risk |

## Non-negotiable controls

- Database encrypted at rest with a vetted SQLite cipher; no custom crypto.
- Key generated randomly, wrapped by Android Keystore / iOS Keychain, never hardcoded.
- Journal, WAL, temporary, and backup files verified not to leak plaintext.
- Statement files encrypted at rest with opaque names in app-private storage.
- Temporary plaintext PDFs deleted after processing, including on failure paths.
- No CVV, PIN, internet-banking password, or full card number stored.
- No sensitive content in logs, error messages, analytics, or crash reports.
- Gmail tokens never stored in ordinary database columns or preferences.

## Implemented controls (M1)

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
  read, the channel returns a typed error. It never generates a replacement key, which
  would silently point the app at an empty database.
- **Memory hygiene:** raw key bytes are zeroed in Dart after hex encoding, in Kotlin after
  wrapping/unwrapping, and in Swift after copying to Keychain data. The hex form is
  required by SQLCipher's raw-key pragma and remains in memory for connection setup only.
- **Backups:** Android sets `android:allowBackup="false"` and excludes every data domain
  from cloud backup and device transfer. The iOS Keychain item cannot migrate or sync.
- **No secret logging:** channel errors carry a stable code only; exception messages and
  key material are never returned to Dart or logged.

## Key lifecycle (implemented)

1. First launch generates 32 random bytes on the native side.
2. Android wraps them with a Keystore AES-GCM key; iOS stores them as a device-only
   Keychain item protected by the OS Keychain.
3. Dart receives the key only to open the database, computes the SQLCipher raw-key hex
   form, and zeroes the byte buffer.
4. `NativeDatabase.createInBackground` opens SQLite on a dedicated isolate in production.
5. On reopen, the same wrapped/Keychain key is recovered. Losing the key or failing
   authentication surfaces an error; the database is not recreated.
6. Recovery requires a future encrypted backup (M8). No recovery mechanism exists yet.

**Biometric gate:** D-08 remains proposed. M1 does not implement an app-launch biometric
prompt. Protection is currently device unlock plus Keystore/Keychain; Android's wrapping
key does not require user authentication. The biometric design workstream must revisit
D-08 before M10.

## Platform backup exclusion

- **Android:** `allowBackup=false` plus `res/xml/data_extraction_rules.xml`; verified in
  the built APK manifest.
- **iOS:** the Keychain item is `ThisDeviceOnly` and non-synchronizing. The database file
  itself lives in Application Support and is **not yet** marked
  `NSURLIsExcludedFromBackupKey`. This is a release-blocking item for the iOS validation
  milestone (M9) and the backup milestone (M8).

## Backup feature (M8, not implemented)

- Argon2id key derivation (fallback only if no vetted implementation exists) and
  AES-256-GCM authenticated encryption.
- Backup key is independent of the device key.
- Manifest and integrity metadata are versioned.
- Restore validates fully into a staging area before replacing active data.

## Logging rules

Never log: card numbers, CVV, PIN, SMS content, email content, statement text, PDF
passwords, OAuth tokens, encryption keys, or birth dates used in password rules.

Allowed: stable error codes, counts, durations, parser IDs and versions, adapter tier,
and non-identifying status values.

## Residual risks

- Merchant normalization is indexed and stored in the whole-database-encrypted file but is
  not separately encrypted (specification §15.1, D-14, D-16).
- Background database work opens without an interactive biometric check by design.
- iOS Keychain and file backup behavior is statically reviewed only; no iOS runtime
  evidence exists.
- The SQLCipher test vector is the host Linux build from the `sqlite3` hook. Android use
  is proven by linkage in the APK, not by an on-device open.
- Rooted/jailbroken devices and memory scraping by a privileged attacker are out of scope.
- PDF encryption variants unsupported by the chosen library must fail closed.
