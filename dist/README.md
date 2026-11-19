# Credit Card Manager — Android APK

Download: `credit-card-manager-0.3.3.apk`

- Package: `app.creditcardmanager`
- Version: `0.3.3` (versionCode 7)
- Min Android: 7.0 (API 24)
- ABIs: `arm64-v8a`, `armeabi-v7a`, `x86_64`
- SHA-256: `20ab141ebfc05134070d6ca97732eec10b90e6bdec3264b8862788e1329beedc`
- Signing SHA-1: `09:7C:95:19:FE:C0:84:65:4A:43:B7:55:FE:04:D6:C9:BC:BF:EB:26`

## What changed in 0.3.3

- **Google sign-in failures are no longer silent.** The app shows the actual
  error and a new **Google sign-in setup help** dialog with the package name,
  SHA-1, and the Google Cloud steps. A missing OAuth client or a SHA-1 mismatch
  now produces an actionable message.
- **Cards can be removed.** Manage Card has a delete action in the top bar and a
  **Remove this card** button at the bottom. Both ask for confirmation and
  remove the card's imported transactions with it.
- **Manage Card uses real data only.** Fabricated Starbucks/Swiggy/Netflix
  transactions, reward points, cashback, and the fake `1 Oct` due date are
  gone. The screen now shows this card's real transactions, outstanding
  balance, available limit, limit-used percentage, tracked spend, credits, and
  transaction count. The credit limit can be edited in place.
- **Card artwork is fetched automatically.** Selecting a supported bank and
  card variant now loads official artwork in the add/complete preview and on
  the card itself. Unsupported variants keep the generated card face. You can
  still choose a custom photo.
- **UI polish:** cleaner official-artwork rendering, an honest empty state for
  cards without transactions, better narrow-screen layouts, and a quieter
  transaction list.
- **In-place updates fixed.** 0.3.3 is signed with the same key as 0.3.1 and
  0.3.2. The key is now stored in the repository (`android/app/onyx-sideload.keystore`)
  so future builds cannot accidentally switch signing keys.

## Install / update

1. Download the APK on your Android phone.
2. Allow installs from the browser/file manager when prompted.
3. Open the APK and tap **Install**.
4. If you already have **0.3.1 or 0.3.2**, this installs over it in place. You
   should not need to uninstall.

**One-time exception:** 0.3.0 and earlier used a different signing key. If you
are still on 0.3.0 or earlier, Android will refuse the update. Uninstall the old
app once, then install 0.3.3. Every release from 0.3.1 onward uses the same
sideload key, so future updates install in place.

This build is signed with the public Android debug certificate for sideloading.
It is installable outside the Play Store but is **not** Play Store-ready; use a
private Play signing key before publishing to a store.

Fresh installs start with no cards and no transactions. Cards and transactions
are created only from SMS/statements the user allows the app to read or from
manual entry. The add/complete card flow includes a curated catalogue of 46
Indian banks and card issuers with card-model and network selection, plus an
**Other card** fallback. Only the last four digits are stored; full card numbers
and CVVs are never requested or saved.

On Android, the back gesture or button returns to Home from Cards, Profile, or a
managed card before it can close the app.

## Gmail setup

Android Gmail uses Google Play services and does not need a client ID in the
APK. Create an Android OAuth client in Google Cloud with:

- Package: `app.creditcardmanager`
- SHA-1: `09:7C:95:19:FE:C0:84:65:4A:43:B7:55:FE:04:D6:C9:BC:BF:EB:26`

Enable the Gmail API, configure the OAuth consent screen, and add your Google
account as a test user. Then open **Profile → Google Account (Gmail) → Connect
Google Mail**. The in-app **Google sign-in setup help** dialog shows the same
values and explains what each Play services error means.

## SMS

SMS import only accepts credit-card alerts. Debit-card, bank-account, UPI, ATM,
and wallet alerts are skipped. **Clear imported SMS** removes SMS-imported
transactions and SMS review/import history from the app; it does not delete
messages from the phone inbox.
