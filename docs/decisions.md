# Decision log

Decisions are recorded when made. A decision marked **proposed** uses the recommended
default until the owning milestone validates it; if validation fails, the entry is
superseded and the reason recorded.

| ID | Decision | Status | Milestone | Rationale / notes |
|---|---|---|---|---|
| D-01 | App ID `app.creditcardmanager`, display name "Credit Card Manager" | Proposed | M0 | Cheap to change before store registration; revisit before M10 |
| D-02 | Encrypted SQLite implementation | Open | M1 | Spike SQLCipher vs SQLite3MultipleCiphers with Drift; require encryption, WAL, migration, reopen tests |
| D-03 | PDF engine | Open | M6 | Require on-device AES-256 (R6) open, text extraction, license approval |
| D-04 | OAuth: Authorization Code + PKCE, no client secret | Proposed | M5 | Native mobile flow; prove refresh/revoke behavior before building on it |
| D-05 | Android SMS target device | Open | M4 | Restricted permission behavior varies by installer/OEM; physical device required |
| D-06 | Bank fixture corpus | Open | M4/M6 | Synthetic/redacted only; no verified label without representative samples |
| D-07 | Backup: `.ccmbackup` v1, Argon2id + AES-256-GCM | Proposed | M8 | Versioned manifest, integrity metadata, independent of device key |
| D-08 | Biometric gate at app launch; DB key device-unlock protected | Proposed | M1 | Keeps background sync viable; documented in security docs |
| D-09 | Separate totals per currency | Proposed | M2 | No conversion in v1 per specification §14.3 |
| D-10 | iOS validation requires macOS hardware | Blocked | M9 | No iOS support claim until device/TestFlight validation |
| D-11 | Signing identities and store accounts | Open | M10 | Owner-supplied |
| D-12 | First-wave banks: HDFC, ICICI, SBI Card, Axis, Amex | Proposed | M4/M6 | Candidates only; adapter tier reflects actual fixture coverage |
| D-13 | Calendar dates stored date-only; audit timestamps UTC | Proposed | M1 | Avoids timezone drift in statement matching |
| D-14 | Merchant normalization stored unencrypted for indexing | Proposed | M3 | Follows specification §15.1; residual privacy risk documented |
| D-15 | No forced base currency | Proposed | M2 | Per-card currency; dashboard groups totals |

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
