# Credit Card Manager — Android APK

Download: `credit-card-manager-0.3.5.apk`

- Package: `app.creditcardmanager`
- Version: `0.3.5` (versionCode 9)
- Min Android: 7.0 (API 24)
- ABIs: `arm64-v8a`, `armeabi-v7a`, `x86_64`
- SHA-256: `f31b4fbf5cfb999f0a0b8798cc416053429496417308304f6dc84131cff802de`
- Signing SHA-1: `09:7C:95:19:FE:C0:84:65:4A:43:B7:55:FE:04:D6:C9:BC:BF:EB:26`

## What changed in 0.3.5

- **Adding a card now closes the form and shows the card immediately.** The
  form returns the new card to the portfolio, so it can no longer stay open
  while another dialog opens on top of it.
- **Automatic SMS/statement sync runs in the background.** After the card
  appears, the app scans the last 30 days without covering the portfolio with a
  blocking progress dialog.
- **New animations.** Cards fade/slide into the portfolio, the card count
  animates, card artwork fades in when it finishes loading, cards gently scale
  when pressed, and the top status toast slides in and out.
- **Back navigation follows your history.** Back from a managed card returns to
  the card list, and back from Cards/Profile returns to the previously visited
  tab instead of always jumping to Home. Home is still the only screen that
  exits the app.
- **Card previews animate when you change bank, model, or network.**

The 0.3.4 catalogue additions remain in place: Slice, SBI Card Eternal,
PhonePe SBI SELECT BLACK/PURPLE, HDFC Swiggy BLCK/Ornge, official artwork,
vertical SBI card faces, and 47 banks/issuers.

## Install / update

1. Download the APK on your Android phone.
2. Allow installs from the browser/file manager when prompted.
3. Open the APK and tap **Install**.
4. If you already have **0.3.1 through 0.3.4**, this installs over it in place.
   You should not need to uninstall.

**One-time exception:** 0.3.0 and earlier used a different signing key. If you
are still on 0.3.0 or earlier, Android will refuse the update. Uninstall the old
app once, then install 0.3.5. Every release from 0.3.1 onward uses the same
sideload key, so future updates install in place.

This build is signed with the public Android debug certificate for sideloading.
It is installable outside the Play Store but is **not** Play Store-ready; use a
private Play signing key before publishing to a store.

Fresh installs start with no cards and no transactions. Cards and transactions
are created only from SMS/statements the user allows the app to read or from
manual entry. Only the last four digits are stored; full card numbers and CVVs
are never requested or saved.

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
