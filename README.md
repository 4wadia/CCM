# Credit Card Manager

Local-first, cross-platform credit card management application built with Flutter.

**Status:** M3–M10 host-verified implementation — transactions, Android SMS, Gmail
statement sync, encrypted PDF processing, rewards, encrypted backup/restore, and local
wipe are implemented. Fresh installs start with no cards or transactions; data is
created only from the user's SMS/statements or manual entry. iOS, physical-device,
real-OAuth, and verified bank-fixture validation remain pending.
**Specification:** `../credit_card_manager_technical_specification.md`
**Implementation plan:** `../credit_card_manager_implementation_plan.md`

## What this is

An Android and iOS application that keeps all financial data on-device:

- Multiple credit cards with limits, balances, and billing details.
- Transaction import from Android SMS (permission-gated) and Gmail statements.
- Local, password-protected PDF statement processing.
- Duplicate-safe reconciliation with full source provenance.
- Cashback, rewards, spending analytics, and payment reminders.
- Encrypted local database, encrypted statement storage, and password-protected
  `.ccmbackup` export/restore.
- Full local wipe of the database, statement files, keys, and OAuth tokens.

There is no backend, cloud database, analytics SDK, or remote processing of financial data.

## Requirements

| Tool | Version used in this workspace |
|---|---|
| Flutter | 3.47.9 (stable) |
| Dart | 3.13.7 |
| JDK | Temurin 17.0.21 |
| Android SDK | command-line tools `latest`, platform/build-tools per `flutter doctor` |

SDKs are installed under `$HOME/development` in this workspace. Set up a shell with:

```bash
source ~/development/env.sh
```

That script exports `JAVA_HOME`, `ANDROID_HOME`, `PATH`, and points Gradle/Pub/TMP
caches at `$HOME` (the system `/tmp` is a small tmpfs and must not hold build output).

## Commands

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --debug
./tool/check.sh          # format check + analyze + tests + debug build
```

Gmail is optional. Android uses Google Play services authorization and does not
need a client ID at build time:

1. Create or select a Google Cloud project.
2. Enable the Gmail API.
3. Configure the OAuth consent screen and add your Google account as a test user.
4. Create an OAuth client ID of type **Android** with package
   `app.creditcardmanager` and the app signing SHA-1. The in-app **Setup help**
   dialog shows the debug SHA-1 for this build.

The app requests read-only Gmail access. It stores an opaque token reference in
the encrypted database and the token itself only in Android secure storage.

iOS still uses Authorization Code + PKCE through `flutter_appauth` and needs a
build-time client ID:

```bash
flutter build ios --debug \
  --dart-define=GMAIL_CLIENT_ID=<client-id>.apps.googleusercontent.com \
  --dart-define=GMAIL_REDIRECT_URI=com.googleusercontent.apps.<client-id>:/oauth2redirect
```

See [`docs/release.md`](docs/release.md).

## Card catalogue and fresh-install behaviour

The add-card and auto-detected-card completion flows include a curated catalogue of
46 Indian banks and card issuers, their common card products, and an **Other card**
fallback for newly launched or unlisted products. Users can select the issuing bank,
card model, and network. Only the last four digits are accepted; full card numbers,
CVVs, PINs, passwords, and OAuth tokens are never stored.

A fresh install contains zero cards and zero transactions. The app only creates records
from messages the user has allowed it to read or from details the user enters manually.

## Project layout

```text
lib/
  app/            bootstrap, app widget, router
  core/           cross-cutting errors, logging, currency, permissions, files
  domain/         entities, repository interfaces, use cases, pure-Dart services
  data/           Drift database, DAOs, models, repository implementations
  integrations/   SMS, Gmail, OAuth, PDF, bank adapters, background, platform
  features/       feature-first presentation modules
  shared/         shared widgets, models, extensions
test/
  unit/           unit and widget tests
  integration/    multi-layer flow tests
  fixtures/       synthetic or anonymized data only
  fakes/          test doubles
```

Architecture rules and dependency direction: [`docs/architecture.md`](docs/architecture.md).
Import-source behavior and bank-adapter limits: [`docs/bank-adapters.md`](docs/bank-adapters.md).

## Verification

On this Linux host: `dart format` is clean, `flutter analyze` reports no issues,
`flutter test` passes 199/199, and `flutter build apk --debug` succeeds. The debug APK is
at `build/app/outputs/flutter-apk/app-debug.apk`.

Not validated here: iOS build/Keychain/TestFlight (no macOS host), Android device
permissions/Keystore/file picker (no device or `/dev/kvm`), real Gmail OAuth (no Google
Cloud project), and verified bank SMS/PDF adapters (no anonymized fixtures). See
[`docs/status.md`](docs/status.md).

## Security rules (non-negotiable)

- Never log card numbers, SMS/email/PDF content, passwords, OAuth tokens, or keys.
- Never store CVV, PIN, or banking credentials.
- Money is integer minor units; never floating point.
- Ambiguous data goes to a review queue; imported records are never silently discarded.
- Statement files and the database are encrypted at rest.

## Documentation

- [`docs/architecture.md`](docs/architecture.md)
- [`docs/bank-adapters.md`](docs/bank-adapters.md)
- [`docs/database.md`](docs/database.md)
- [`docs/security.md`](docs/security.md)
- [`docs/status.md`](docs/status.md)
- [`docs/testing.md`](docs/testing.md)
- [`docs/release.md`](docs/release.md)
- [`docs/decisions.md`](docs/decisions.md)
