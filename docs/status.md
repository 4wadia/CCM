# Project status

Updated at the end of each milestone. The specification and implementation plan remain
the source of truth.

## Milestones

| Milestone | Status | Notes |
|---|---|---|
| M0 Environment and foundation | Complete | Toolchain installed; app, router, tests, docs, and debug APK verified |
| M1 Encrypted database and keys | Implemented (validation partial) | Host encryption/schema/repository tests pass; Android APK builds with SQLCipher and the Keystore channel. On-device keystore and iOS Keychain runtime tests are blocked |
| M2 Cards and dashboard | Complete (host-verified) | Cards, reconciled outstanding balances, currency totals, available credit, utilisation, per-card summaries, archive confirmation, and schema v2. Static analysis clean; 69/69 tests pass; debug APK builds. Device and iOS runtime checks remain blocked |
| M3 Transaction engine | Not started | |
| M4 Android SMS | Not started | Needs a physical device and anonymized samples |
| M5 Gmail | Not started | Needs a Google Cloud project and OAuth client IDs |
| M6 PDF and adapters | Not started | Needs statement fixtures and a PDF library decision |
| M7 Rewards and analytics | Not started | |
| M8 Backup and restore | Not started | |
| M9 iOS validation | Blocked | Requires a macOS host |
| M10 Release hardening | Not started | Needs signing identities and store accounts |

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
- [x] `flutter analyze` clean
- [x] 5 unit/widget tests passing
- [x] Architecture, testing, security, release, and decision docs
- [x] `tool/check.sh` verification gate
- [x] Git repository initialized with the M0 commit
- [x] Debug APK built and inspected
- [ ] iOS build (requires macOS)

## M0 build evidence

| Check | Result |
|---|---|
| `dart format --set-exit-if-changed .` | Pass (15 files, no changes) |
| `flutter analyze` | No issues |
| `flutter test` | 5/5 pass |
| `flutter build apk --debug` | Success, 637 s cold / 7 s warm |
| APK | `build/app/outputs/flutter-apk/app-debug.apk`, 157 MB |
| Package | `app.creditcardmanager`, version `0.1.0+1` |
| Label | `Credit Card Manager` |
| compileSdk / targetSdk | 36 / 36 |
| iOS build | Not run (no macOS host) |

Flutter installed NDK `28.2.13676358` automatically on the first Android build.

## M1 checklist

- [x] SQLCipher selected and enabled through the `sqlite3` 3.x hook
- [x] `sqlcipher_flutter_libs` removed (obsolete with `sqlite3` 3.x)
- [x] Fail-closed `cipher_version` check and wrong-key rejection
- [x] Android Keystore AES-256-GCM key wrapping (`SecurityChannel.kt`)
- [x] iOS Keychain device-only key storage in `AppDelegate.swift`
- [x] Typed `DatabaseKeyProvider` failure handling; no automatic key recreation
- [x] Schema v1: banks, cards, categories, transactions, sources, import jobs, settings
- [x] Required indexes, foreign keys, secure delete, WAL
- [x] Idempotent system-category seeding
- [x] Forward-migration harness that fails loudly on a missing step
- [x] Domain entities and repositories for banks, cards, categories, and settings
- [x] Riverpod database and repository providers (lazy; not yet consumed by UI)
- [x] Android backup disabled and all data domains excluded from transfer
- [x] Encryption-at-rest test covering database, WAL, and SHM files
- [x] Reopen, wrong-key, deleted-key, and background-isolate tests
- [x] `dart format`, `flutter analyze`, `flutter test`, and debug APK build
- [x] Security, database, architecture, testing, and decision docs updated
- [ ] Android Keystore round-trip on a device or emulator (no `/dev/kvm`, no device)
- [ ] iOS build and Keychain runtime test (no macOS host)

## M1 build and test evidence

| Check | Result |
|---|---|
| `dart format --set-exit-if-changed .` | Pass (45 files, 0 changed) |
| `flutter analyze` | No issues |
| `flutter test` | 35/35 pass |
| `flutter build apk --debug` | Success, 65.8 s warm |
| APK | `build/app/outputs/flutter-apk/app-debug.apk`, 223 MB |
| Package / version | `app.creditcardmanager`, `0.1.0+1` |
| minSdk / targetSdk / compileSdk | 24 / 36 / 36 |
| Cipher in host tests | SQLCipher `4.19.0 community` |
| Cipher in APK | `libsqlcipher.so` for arm64-v8a, armeabi-v7a, x86_64 |
| Manifest | `allowBackup=false`; `dataExtractionRules` resource present |
| Kotlin channel | `SecurityChannel` present in `classes5.dex` |
| iOS build | Not run (no macOS host) |
| Device tests | Not run (no hardware device; no `/dev/kvm`) |

The Android build installed SDK Platform 35 and CMake 3.22.1 automatically to compile
the SQLCipher native asset. The debug APK is large because it contains Flutter debug
artifacts for all ABIs; this is not a release-size measurement.

The wrong-key test prints SQLCipher `hmac check failed` and `error decrypting page`
lines to stderr. Those lines are expected cipher diagnostics, contain no data, and the
test passes.

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
- [x] Home totals for limit, outstanding, and available credit grouped by currency; unlike currencies are never summed
- [x] Utilisation omitted when a limit is zero or currencies are not comparable
- [x] Per-card summaries, loading, error, and empty dashboard states
- [x] Multiple cards and balances persist across a database close/reopen
- [x] Offline platform typography; no runtime font fetching
- [x] Repository-wide `flutter analyze` clean
- [x] `dart format`, 69/69 tests, and Android debug APK build
- [ ] Android Keystore device round-trip and iOS build/runtime checks (environment unavailable)

## M2 build and test evidence

| Check | Result |
|---|---|
| `dart format --output=none --set-exit-if-changed .` | Pass (80 files, 0 changed) |
| `flutter analyze` | No issues |
| `flutter test` | 69/69 pass |
| `flutter build apk --debug` | Success, 33.9 s warm |
| APK | `build/app/outputs/flutter-apk/app-debug.apk`, 204 MB |
| Package / version | `app.creditcardmanager`, `0.1.0+1` |
| minSdk / targetSdk / compileSdk | 24 / 36 / 36 |
| Schema | v2, with a populated v1-to-v2 upgrade test |
| iOS build | Not run (Linux host; requires macOS) |
| Device tests | Not run (no hardware device; no `/dev/kvm`) |

The dashboard displays a reconciled outstanding balance that the user enters for each
card. It does not add lifetime purchases to estimate a balance. Transaction- and
statement-derived balances arrive in M3/M6; when they conflict with the reconciled value,
both must be preserved for review rather than silently overwriting one.

The wrong-key test still prints SQLCipher `hmac check failed` and `error decrypting page`
lines to stderr. These are expected cipher diagnostics with no data content.

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

## Known limitations

- **No macOS host:** iOS code is generated and statically reviewed, but iOS build,
  Keychain runtime, and TestFlight validation are blocked. No iOS support is claimed.
- **No `/dev/kvm`:** emulator acceleration is unavailable, so device-level testing
  (SMS permissions, biometrics, keychain) requires a physical device or another host.
  M1's Keystore path and the app's real database open are therefore unexercised at runtime.
- **M1 validation gap:** encryption, schema, repositories, migrations, and the
  background-isolate path are proven by host tests. The APK is proven to link SQLCipher
  and contain the Keystore channel, but no Android Keystore round-trip has executed.
- **iOS backup exclusion incomplete:** the Keychain key is device-only, but the database
  file is not yet marked `NSURLIsExcludedFromBackupKey`. This is release-blocking for
  M8/M9 rather than silently accepted.
- **Biometric app gate not implemented:** D-08 remains proposed. M1 relies on device
  unlock plus Keystore/Keychain protection.
- **`/tmp` is a 1.6 GB tmpfs:** all SDKs and caches are redirected to `$HOME`;
  commands must source `~/development/env.sh`.
- **No CI configured:** the workspace has no CI runner. `tool/check.sh` is the local
  equivalent and must be run before each milestone is signed off.
- **No bank samples yet:** adapters cannot be labeled verified until anonymized SMS and
  statement fixtures exist.
- **Outstanding is reconciled manually in M2:** the value is persisted exactly and drives
  available credit and utilisation, but it is not yet produced by transaction or statement
  reconciliation. M3/M6 must preserve both values when they disagree.

## Next milestone

M2 is complete on this host and ready for review. M1 still lacks Android Keystore runtime
validation and both milestones lack iOS build/runtime validation because the required
hardware is unavailable. After explicit acceptance of those limits, M3 begins the canonical
transaction engine, idempotent import, and review queue.
