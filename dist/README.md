# Credit Card Manager — Android APK

Download: `credit-card-manager-0.3.4.apk`

- Package: `app.creditcardmanager`
- Version: `0.3.4` (versionCode 8)
- Min Android: 7.0 (API 24)
- ABIs: `arm64-v8a`, `armeabi-v7a`, `x86_64`
- SHA-256: `4d0974f3e7d9263ea76e46b1162e3d6c1696a74040304f9deddef66b23048c84`
- Signing SHA-1: `09:7C:95:19:FE:C0:84:65:4A:43:B7:55:FE:04:D6:C9:BC:BF:EB:26`

## What changed in 0.3.4

- **Slice added to the card catalogue.** Choose **Slice Small Finance Bank →
  UPI Credit Card**. The generated card face uses Slice's magenta "super
  slicer" colour and wordmark.
- **SBI Card Eternal added.** Official SBI card artwork loads automatically.
  The Eternal card is issued on RuPay and Mastercard; the network selector lets
  you pick the one printed on your card.
- **PhonePe SBI Card SELECT BLACK and PURPLE added.** Both variants include
  official SBI artwork. Their vertical card faces now keep the correct portrait
  shape instead of being cropped into a horizontal frame.
- **HDFC Swiggy split into BLCK and Ornge.** Both variants use the official
  Swiggy HDFC Bank artwork and the correct black/orange colours.
- **Catalogue now covers 47 banks and issuers.** Every bank still has an
  **Other card** fallback, and the bank/model/network selectors work as before.
- **Google "Access blocked" troubleshooting is now in the app.** The setup help
  dialog explains the Testing/test-user fix and the permission reset steps.

The 0.3.3 improvements remain in place: Google sign-in errors are visible,
cards can be deleted with their imported transactions, Manage Card uses only
real card data, and the UI/card-artwork polish is included.

## Install / update

1. Download the APK on your Android phone.
2. Allow installs from the browser/file manager when prompted.
3. Open the APK and tap **Install**.
4. If you already have **0.3.1, 0.3.2, or 0.3.3**, this installs over it in
   place. You should not need to uninstall.

**One-time exception:** 0.3.0 and earlier used a different signing key. If you
are still on 0.3.0 or earlier, Android will refuse the update. Uninstall the old
app once, then install 0.3.4. Every release from 0.3.1 onward uses the same
sideload key, so future updates install in place.

This build is signed with the public Android debug certificate for sideloading.
It is installable outside the Play Store but is **not** Play Store-ready; use a
private Play signing key before publishing to a store.

Fresh installs start with no cards and no transactions. Cards and transactions
are created only from SMS/statements the user allows the app to read or from
manual entry. Only the last four digits are stored; full card numbers and CVVs
are never requested or saved.

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

If Google shows **Access blocked: CCM has not completed the google verification
process**, the OAuth app is still in production mode without verification. For
personal use, set the consent screen's publishing status to **Testing**, add the
exact Gmail account you sign in with under **Test users**, and retry after a few
minutes. Production use with the restricted `gmail.readonly` scope requires
Google's verification review.

## SMS

SMS import only accepts credit-card alerts. Debit-card, bank-account, UPI, ATM,
and wallet alerts are skipped. **Clear imported SMS** removes SMS-imported
transactions and SMS review/import history from the app; it does not delete
messages from the phone inbox.
