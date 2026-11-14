# Project status

Updated after the M3–M10 implementation pass. The specification and implementation plan
remain the source of truth.

## Milestones

| Milestone | Status | Notes |
|---|---|---|
| M0 Environment and foundation | Complete | Toolchain installed; app, router, tests, docs, and debug APK verified |
| M1 Encrypted database and keys | Implemented (validation partial) | Host encryption/schema/repository tests pass; Android APK builds with SQLCipher and the Keystore channel. On-device keystore and iOS Keychain runtime tests are blocked |
| M2 Cards and dashboard | Complete (host-verified) | Cards, reconciled outstanding balances, currency totals, available credit, utilisation, per-card summaries, archive confirmation, and schema v2 |
| M3 Transaction engine | Implemented (host-verified) | Canonical ledger, filters, source provenance, fingerprints, idempotent import, review queue, card assignment, CSV export |
| M4 Android SMS | Implemented (host-verified) | Permission-gated method channel, credit-card-only filtering, clear-imported-SMS cleanup, synthetic parser tests, import checkpointing, review fallback. No device or real-sample validation |
| M5 Gmail | Implemented (host-verified) | Android Google Play services authorization, iOS PKCE, secure token storage, classifier, statement sync, checkpoints, review fallback. Real OAuth not exercised |
| M6 PDF and adapters | Implemented (host-verified) | Encrypted PDF storage, Syncfusion extraction, declarative password rules, generic parser, reconciliation. No verified bank fixtures |
| M7 Rewards and analytics | Implemented (host-verified) | Integer cashback calculator, basis-point rules, caps, reward accounts/entries, point estimates, analytics, rewards UI |
| M8 Backup and restore | Implemented (host-verified) | Encrypted `.ccmbackup` create/restore, Argon2id + AES-256-GCM, statement re-encryption, token cleanup, local wipe |
| M9 iOS validation | Blocked | Requires a macOS host |
| M10 Release hardening | Partially implemented | UI, docs, tests, and debug build complete. Signing identities, store accounts, and device validation are owner/environment-blocked |

## Current verification

| Check | Result |
|---|---|
| `dart format` | Clean |
| `flutter analyze` | No issues |
| `flutter test` | 176/176 pass |
| `flutter build apk --debug` | Success |
| APK | `build/app/outputs/flutter-apk/app-debug.apk`, 213 MB debug build |
| Schema | v3, with v1/v2 forward migrations |
| Host cipher | SQLCipher `4.19.0 community` |
| Android APK cipher | `libsqlcipher.so` linked for shipped ABIs |
| iOS build | Not run (Linux host; requires macOS) |
| Device tests | Not run (no hardware device; no `/dev/kvm`) |

The wrong-key test prints SQLCipher `hmac check failed` and `error decrypting page` lines
to stderr. These are expected cipher diagnostics with no data content and the test passes.

## M0 checklist

- [x] Flutter 3.47.9 stable installed and pinned in documentation
- [x] JDK 17.0.21 (Temurin) installed
- [x] Android SDK 36, build-tools 36.0.0, platform-tools 37.0.1
- [x] All Android licenses accepted
- [x] Android and iOS project targets generated
- [x] Application ID set to `app.creditcardmanager`
- [x] Riverpod `3.4.3` wired at the root
- [x] GoRouter `18.1.3` with five destinations and state-preserving shell
- [x] Strict analysis options and formatting
- [x] Architecture, testing, security, release, and decision docs
- [x] `tool/check.sh` verification gate
- [x] Git repository initialized
- [x] Debug APK built and inspected
- [ ] iOS build (requires macOS)

## M1 checklist

- [x] SQLCipher selected and enabled through the `sqlite3` 3.x hook
- [x] Fail-closed `cipher_version` check and wrong-key rejection
- [x] Android Keystore AES-256-GCM key wrapping (`SecurityChannel.kt`)
- [x] iOS Keychain device-only key storage in `AppDelegate.swift`
- [x] Typed `DatabaseKeyProvider` failure handling; no automatic key recreation
- [x] Schema v1 and required indexes, foreign keys, secure delete, WAL
- [x] Idempotent system-category seeding
- [x] Forward-migration harness that fails loudly on a missing step
- [x] Riverpod database and repository providers
- [x] Android backup disabled and data domains excluded from transfer
- [x] Encryption-at-rest test covering database, WAL, and SHM files
- [x] Reopen, wrong-key, deleted-key, and background-isolate tests
- [ ] Android Keystore round-trip on a device or emulator (no `/dev/kvm`, no device)
- [ ] iOS build and Keychain runtime test (no macOS host)

## M2 checklist

- [x] `Money` value object plus a maintained ISO 4217 minor-digit table
- [x] Card add/edit flow backed by bank and card repositories
- [x] Card identity limited to last four digits; no full number, CVV, or PIN fields
- [x] Issuer, network, currency, limit, reconciled outstanding, cardholder, reward programme, and billing-day fields
- [x] Positive credit-limit validation using ISO currency fraction digits
- [x] Non-negative outstanding validation with per-currency precision
- [x] Schema v2 `current_outstanding_minor` with a populated v1-to-v2 migration test
- [x] Archive, restore, and close lifecycle actions without deleting history
- [x] Archive confirmation dialog
- [x] Home totals grouped by currency; unlike currencies are never summed
- [x] Utilisation omitted when a limit is zero or currencies are not comparable
- [x] Per-card summaries, loading, error, and empty dashboard states
- [x] Multiple cards and balances persist across a database close/reopen
- [x] Offline platform typography; no runtime font fetching

## M3 checklist

- [x] Schema v3 transaction fingerprint columns and source date
- [x] `CardTransaction`, `TransactionSource`, filter, and review entities
- [x] `TransactionRepository` with search/count/recent, atomic insert+source, updates, fingerprint lookup, fuzzy candidates, source linking, and deletion
- [x] `ImportJobRepository` and `ReviewRepository` with idempotent job counters and review lifecycle
- [x] SHA-256 versioned fingerprinting over card, signed amount, currency, day, normalized merchant, and type
- [x] Merchant normalization and conservative fuzzy matching
- [x] Category classification and card matching by last four/issuer with no guessing on ambiguity
- [x] Import service that never silently discards records
- [x] Transaction list, filters, add/edit/detail sheets, card assignment, review banner/queue, and CSV export
- [x] Unit/integration/widget coverage

## M4 checklist

- [x] Android `READ_SMS` manifest permission and runtime request
- [x] `SmsChannel.kt` read-only query with sender/body/date/ID only
- [x] `MethodChannelSmsPlatform`; iOS returns unsupported
- [x] Generic conservative SMS parser with OTP/promotional exclusion, purchase/refund/payment/cash-advance/fee detection, and declined status
- [x] SMS import service with permission gate, lookback window, checkpoint, and unparsed-message review
- [x] Credit-card-only relevance filtering; debit-card, account, UPI, ATM, and wallet alerts are skipped and counted
- [x] Clear imported SMS data without deleting phone messages
- [x] Synthetic SMS parser and filtering tests
- [x] Account permission/import/clear controls
- [ ] Physical-device permission/runtime validation
- [ ] Verified bank SMS adapters (requires anonymized samples)

## M5 checklist

- [x] Android Google Play services authorization; no client ID or secret in the APK
- [x] iOS Authorization Code + PKCE through `flutter_appauth` with build-time client configuration
- [x] Secure token storage through `flutter_secure_storage`; opaque DB reference only
- [x] Gmail client with pagination, MIME attachment discovery, retries, and typed failures
- [x] Statement-email classifier using metadata only
- [x] Sync checkpoints and import-job accounting
- [x] Encrypted PDF attachment import into the statement pipeline
- [x] Low-confidence/no-PDF/oversized/failed attachment review records
- [x] Connect/sync/disconnect UI and remote-revocation fallback
- [x] Email classifier tests
- [ ] Real OAuth/sync validation (requires Google Cloud project and test users)

## M6 checklist

- [x] PDF magic/size validation
- [x] AES-256-GCM encrypted statement file store with opaque names
- [x] Syncfusion local text extraction
- [x] Declarative password strategies (name/birth date, customer ID/date, card suffix/date, user password)
- [x] Generic statement parser for metadata and table-like rows
- [x] Card matching, statement-row persistence, and total reconciliation
- [x] Password-protected/unreadable/duplicate/mismatch/unmatched review paths
- [x] Statement list/detail/import UI and encrypted PDF picker
- [x] Parser/password/file-store/import tests
- [ ] Verified bank statement adapters (requires anonymized fixtures)

## M7 checklist

- [x] Integer cashback calculator with percentage basis points, flat amounts, and monthly caps
- [x] Ineligibility for credits/payments/refunds, zero/negative purchases, and currency mismatch
- [x] Category/merchant eligibility and cap tracking
- [x] Cashback rule repository and application service
- [x] Reward accounts and point entries with labelled estimated value
- [x] Active-point calculation excluding expired entries
- [x] Rewards page for cashback, accounts, adjustments, and rules
- [x] Home cashback and reward-point summaries
- [x] Unit/repository/widget coverage

## M8 checklist

- [x] `.ccmbackup` v1 magic/version and allow-listed logical table export
- [x] Argon2id key derivation and AES-256-GCM authenticated envelope
- [x] Minimum 12-character backup password
- [x] OAuth tokens, secure-storage keys, email accounts, and sync checkpoints excluded
- [x] Statement PDFs decrypted into the backup and re-encrypted on restore
- [x] Restore validation before table replacement and file cleanup on failure
- [x] Stale token deletion after successful restore
- [x] Full local wipe of database, statement files, keys, and tokens
- [x] Account backup/restore/wipe UI
- [x] Backup/restore integration tests
- [ ] Device-level backup file picking and wipe validation

## M9 / M10 blockers

| Blocker | Impact |
|---|---|
| No macOS host | No iOS build, Keychain runtime, OAuth, backup, or TestFlight validation |
| No physical Android device / no `/dev/kvm` | No Keystore, SMS permission, file picker, backup, or wipe runtime validation |
| No Google Cloud project | Gmail OAuth and sync cannot be validated end to end |
| No anonymized bank samples | SMS/PDF adapters cannot be labelled verified |
| Owner-supplied signing/store accounts | Release APK/AAB and store distribution cannot be produced |

## Known limitations

- **No macOS host:** iOS code is generated and statically reviewed, but iOS build,
  Keychain runtime, and TestFlight validation are blocked. No iOS support is claimed.
- **No `/dev/kvm`:** emulator acceleration is unavailable; device-level testing requires a
  physical device or another host.
- **Android Keystore path unexercised at runtime:** host tests prove encryption and
  database behavior; the APK proves SQLCipher linkage and channel presence.
- **iOS backup exclusion incomplete:** the Keychain key is device-only, but the database
  file is not yet marked `NSURLIsExcludedFromBackupKey`.
- **Biometric app gate not implemented:** D-08 remains proposed.
- **No background sync:** Gmail/SMS sync is user-triggered; no WorkManager/BGTask job.
- **No real OAuth validation:** Gmail is wired but unproven against Google's servers.
- **No verified bank fixtures:** the generic SMS/PDF parsers are conservative and create
  review items rather than claiming bank-specific accuracy.
- **`/tmp` is a 1.6 GB tmpfs:** all SDKs and caches are redirected to `$HOME`; commands
  must source `~/development/env.sh`.
- **No CI configured:** `tool/check.sh` is the local equivalent.
- **Outstanding remains reconciled manually:** transaction/statement data is preserved
  separately; conflicting balances are not silently overwritten.

## Environment record

| Item | Value |
|---|---|
| Project | `/home/parthwadia/Downloads/credit_card_manager` |
| Flutter | 3.47.9 (revision c197ca5199) |
| Dart | 3.13.7 |
| JDK | Temurin 17.0.21+9 |
| Android SDK | `~/development/sdk` (platform 36, build-tools 36.0.0) |
| Toolchain script | `~/development/env.sh` |
| Gradle cache | `~/.gradle` (kept off `/tmp`) |

## Next work

1. Run the app on a physical Android device to validate Keystore, SMS permission/import,
   file picker, backup/restore, and local wipe.
2. Configure a Google Cloud OAuth client and validate Gmail connect/refresh/sync/revoke.
3. Add anonymized bank SMS/PDF fixtures and promote adapters only when verified.
4. On a macOS host, build iOS, mark data files excluded from backup, and validate Keychain,
   OAuth, statement import, backup/restore, and TestFlight.
5. Obtain owner signing identities/store accounts for release hardening.
