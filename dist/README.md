# Credit Card Manager — Android APK

Download: `credit-card-manager-0.3.1.apk`

- Package: `app.creditcardmanager`
- Version: `0.3.1` (versionCode 5)
- Min Android: 7.0 (API 24)
- ABIs: `arm64-v8a`, `armeabi-v7a`, `x86_64`
- SHA-256: `7994a465a26853098411877e07c3ff43f94d31b156e8797472395bf142ea35b7`

## Install

1. Download the APK on your Android phone.
2. Allow installs from the browser/file manager when prompted.
3. Open the APK and tap **Install**.
4. This build uses the same debug signing key as 0.1.0, so an in-place upgrade should work. If a build with a different signature is installed, uninstall it first — that removes local app data, so export a backup beforehand.

This build is signed with the Android debug certificate. It is installable by sideloading but is **not** Play Store-ready.

Fresh installs start with no cards and no transactions. Cards and transactions are created only from SMS/statements the user allows the app to read or from manual entry. The add/complete card flow includes a curated catalogue of 46 Indian banks and card issuers with card-model and network selection, plus an **Other card** fallback. Only the last four digits are stored; full card numbers and CVVs are never requested or saved.

## Gmail

Android Gmail uses Google Play services and does not need a client ID in the APK. Create an Android OAuth client in Google Cloud with:

- Package: `app.creditcardmanager`
- SHA-1: `09:7C:95:19:FE:C0:84:65:4A:43:B7:55:FE:04:D6:C9:BC:BF:EB:26`

Enable the Gmail API, configure the OAuth consent screen, and add your Google account as a test user. Then open **Settings → Gmail statements → Connect Gmail**. The in-app **Setup help** dialog shows the same values.

## SMS

SMS import only accepts credit-card alerts. Debit-card, bank-account, UPI, ATM, and wallet alerts are skipped. **Clear imported SMS** removes SMS-imported transactions and SMS review/import history from the app; it does not delete messages from the phone inbox.
