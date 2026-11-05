# Security

**Status:** M0 — principles only. The cipher, key lifecycle, and verified controls are
completed and tested in M1. Do not treat this document as a completed security review.

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
| Device loss / theft | Encrypted database; biometric app gate; encrypted statement files |
| Backup extraction | Backups are separately encrypted with a user password; OAuth tokens excluded |
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

## Key lifecycle (to be validated in M1)

1. First launch generates a random 256-bit database key.
2. Key is wrapped with a platform-held key (Keystore/Keychain) and stored as ciphertext.
3. On launch, the app unwraps the key after the configured authentication gate.
4. Background work uses a documented, separately protected access path — biometric
   prompts are not assumed to be available.
5. Key invalidation or loss surfaces a typed error. The app never silently deletes and
   recreates the database.
6. Recovery is possible only through a previously created encrypted backup.

## Backup

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

## Residual risks to document

- Merchant normalization is indexed and therefore not encrypted (specification §15.1).
- Background tasks may run without an interactive biometric check by design.
- Platform backup exclusion must be verified per OS version.
- PDF encryption variants unsupported by the chosen library must fail closed.
