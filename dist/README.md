# Credit Card Manager — Android APK

Download: `credit-card-manager-0.3.0.apk`

- Package: `app.creditcardmanager`
- Version: `0.3.0` (versionCode 4)
- Min Android: 7.0 (API 24)
- ABIs: `arm64-v8a`, `armeabi-v7a`, `x86_64`
- SHA-256: `a8656a418b20422d912b6058e3d15a24c4851886ddad974a582ccdc5cac1c3c1`

## Install

1. Download the APK on your Android phone.
2. Allow installs from the browser/file manager when prompted.
3. Open the APK and tap **Install**.
4. This build uses the same debug signing key as 0.1.0, so an in-place upgrade should work. If a build with a different signature is installed, uninstall it first — that removes local app data, so export a backup beforehand.

This build is signed with the Android debug certificate. It is installable by sideloading but is **not** Play Store-ready.

## Gmail

Android Gmail uses Google Play services and does not need a client ID in the APK. Create an Android OAuth client in Google Cloud with:

- Package: `app.creditcardmanager`
- SHA-1: `09:7C:95:19:FE:C0:84:65:4A:43:B7:55:FE:04:D6:C9:BC:BF:EB:26`

Enable the Gmail API, configure the OAuth consent screen, and add your Google account as a test user. Then open **Settings → Gmail statements → Connect Gmail**. The in-app **Setup help** dialog shows the same values.

## SMS

SMS import only accepts credit-card alerts. Debit-card, bank-account, UPI, ATM, and wallet alerts are skipped. **Clear imported SMS** removes SMS-imported transactions and SMS review/import history from the app; it does not delete messages from the phone inbox.
