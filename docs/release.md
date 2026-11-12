# Release

**Status:** M3–M10 host-verified implementation. Release signing, store accounts, iOS
build, and device validation remain owner- or environment-blocked.

## Targets

| Platform | Artifact | Distribution |
|---|---|---|
| Android | Signed APK (and AAB if store distribution is chosen) | Direct install / store |
| iOS | Archive → TestFlight | TestFlight / App Store |

## Versioning

- `pubspec.yaml` `version: <semver>+<build>`.
- Android `versionCode` and iOS `CFBundleVersion` derive from the build number.
- Database schema version is separate from app version and is migrated forward only.
- Backup format and schema versions are validated on restore; incompatible backups are
  rejected rather than partially applied.

## Build configuration

### Gmail (optional)

Gmail is disabled unless a public OAuth client is supplied at build time. No client secret
is used.

```bash
flutter build apk --debug \
  --dart-define=GMAIL_CLIENT_ID=<client-id>.apps.googleusercontent.com \
  --dart-define=GMAIL_REDIRECT_URI=com.googleusercontent.apps.<client-id>:/oauth2redirect
```

For Android, `flutter_appauth` also needs the redirect scheme in the manifest. Set it with
the `GMAIL_REDIRECT_SCHEME` environment variable or the `-PappAuthRedirectScheme` Gradle
property:

```bash
GMAIL_REDIRECT_SCHEME=com.googleusercontent.apps.<client-id> flutter build apk --debug
```

The Gradle default is `app.creditcardmanager`, which keeps the build working when Gmail is
not configured. Configure the Google Cloud OAuth client with the same redirect URI and add
test users before validating sync.

### SMS

Android SMS import requires `READ_SMS`, requested at runtime. The permission is not needed
for any other feature. iOS must not claim SMS inbox access.

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
      no background sync, no verified bank fixtures).

## Android signing

- Release keystore is held by the owner, never committed.
- `key.properties` is git-ignored.
- Build: `flutter build apk --release --split-per-abi` (and/or `appbundle`).
- Verify install and in-place upgrade on a physical device.
- Validate runtime SMS permission, encrypted database reopen, backup export/import, and
  full local wipe on the release artifact.

## iOS

- Requires a macOS host with Xcode; **not available in this Linux workspace**.
- Signing identities and provisioning profiles are owner-supplied.
- Build: `flutter build ipa --release`, then upload with Transporter/Xcode.
- Mark the database and statement directory with `NSURLIsExcludedFromBackupKey` before
  claiming iOS backup safety.
- Validate Keychain access, Gmail OAuth, statement import, backup/restore, and local wipe on
  a real device before claiming support.

## Store declarations

- No analytics SDK, ad SDK, cloud database, or remote financial processing.
- Gmail is optional and uses read-only scope for statement discovery.
- Android SMS is optional, permission-gated, and never uploaded.
- Backups are user-initiated, password-protected, and exclude OAuth tokens and device keys.
- The app stores card metadata, last four digits, transactions, statements, rewards, and
  cashback locally.

## Build environment notes

- Keep `GRADLE_USER_HOME`, `PUB_CACHE`, and `TMPDIR` under `$HOME`; `/tmp` is small.
- Pin SDK and package versions in documentation and CI.
- The debug APK is large because it contains Flutter debug artifacts for all ABIs; it is
  not a release-size measurement.
