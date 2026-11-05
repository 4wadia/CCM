# Project status

Updated at the end of each milestone. The specification and implementation plan remain
the source of truth.

## Milestones

| Milestone | Status | Notes |
|---|---|---|
| M0 Environment and foundation | Complete | Toolchain installed; app, router, tests, docs, and debug APK verified |
| M1 Encrypted database and keys | Not started | Blocked only on M0 sign-off |
| M2 Cards and dashboard | Not started | |
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
- **`/tmp` is a 1.6 GB tmpfs:** all SDKs and caches are redirected to `$HOME`;
  commands must source `~/development/env.sh`.
- **No CI configured:** the workspace has no CI runner. `tool/check.sh` is the local
  equivalent and must be run before each milestone is signed off.
- **No bank samples yet:** adapters cannot be labeled verified until anonymized SMS and
  statement fixtures exist.

## Next milestone

M1 — encrypted database and key management:

1. Cipher spike (SQLCipher vs SQLite3MultipleCiphers) with Drift.
2. Keystore/Keychain key wrapping.
3. Schema v1 plus migration harness.
4. Encryption-at-rest, reopen, rollback, and key-loss tests.
