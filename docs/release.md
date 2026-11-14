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

**Android** uses Google Play services `AuthorizationClient`. No client ID, client secret, or
refresh token is embedded in the APK. Google no longer accepts custom URI redirect schemes
on Android, so the old `flutter_appauth` custom-scheme flow is not used on that platform.

1. Create or select a Google Cloud project.
2. Enable the Gmail API.
3. Configure the OAuth consent screen and add test users.
4. Create an OAuth client ID of type **Android** with package `app.creditcardmanager` and
   the signing certificate SHA-1.
5. Install the APK and use **Account → Connected Gmail → Connect Gmail**.

The in-app **Setup help** dialog shows the debug SHA-1 for the published debug-signed APK.
If the signing key changes, create a new Android OAuth client for the new SHA-1.

**iOS** still uses Authorization Code + PKCE through `flutter_appauth` and needs a public
client ID at build time:

```bash
flutter build ios --debug \
  --dart-define=GMAIL_CLIENT_ID=<client-id>.apps.googleusercontent.com \
  --dart-define=GMAIL_REDIRECT_URI=com.googleusercontent.apps.<client-id>:/oauth2redirect
```

For iOS, register the same reversed-client-ID URL scheme in the Xcode target. Configure the
Google Cloud OAuth client with the same redirect URI and add test users before validating
sync.

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
