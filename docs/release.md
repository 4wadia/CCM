# Release

**Status:** outline. Release steps are finalized in M10.

## Targets

| Platform | Artifact | Distribution |
|---|---|---|
| Android | Signed APK (and AAB if store distribution is chosen) | Direct install / store |
| iOS | Archive → TestFlight | TestFlight / App Store |

## Versioning

- `pubspec.yaml` `version: <semver>+<build>`.
- Android `versionCode` and iOS `CFBundleVersion` derive from the build number.
- Database schema version is separate from app version and is migrated forward only.

## Pre-release checklist

- [ ] `./tool/check.sh` passes (format, analyze, unit/widget tests, debug build).
- [ ] Integration and regression suites pass.
- [ ] Database migration matrix passes from every supported prior version.
- [ ] Security review: encryption at rest, key storage, log redaction, token storage.
- [ ] Permission review: only required permissions declared, with in-app rationale.
- [ ] Backup/restore round-trip and failed-restore safety verified.
- [ ] Data deletion verified on a real device.
- [ ] No sensitive content in logs, crash output, or diagnostics.
- [ ] Dependencies audited for maintenance, license, and advisories.
- [ ] Privacy policy and store data-safety declarations match actual behavior.
- [ ] Known limitations documented (Android SMS restrictions, iOS SMS absence,
      background scheduling).

## Android signing

- Release keystore is held by the owner, never committed.
- `key.properties` is git-ignored.
- Build: `flutter build apk --release --split-per-abi` (and/or `appbundle`).
- Verify install and in-place upgrade on a physical device.

## iOS

- Requires a macOS host with Xcode; **not available in this Linux workspace**.
- Signing identities and provisioning profiles are owner-supplied.
- Build: `flutter build ipa --release`, then upload with Transporter/Xcode.
- Validate Keychain access, background tasks, and OAuth on a real device before claiming support.

## Build environment notes

- Keep `GRADLE_USER_HOME`, `PUB_CACHE`, and `TMPDIR` under `$HOME`; `/tmp` is small.
- Pin SDK and package versions in documentation and CI.
