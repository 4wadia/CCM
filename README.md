# Credit Card Manager

Local-first, cross-platform credit card management application built with Flutter.

**Status:** M0 — project foundation (in progress)
**Specification:** `../credit_card_manager_technical_specification.md`
**Implementation plan:** `../credit_card_manager_implementation_plan.md`

## What this is

An Android and iOS application that keeps all financial data on-device:

- Multiple credit cards with limits, balances, and billing details.
- Transaction import from Android SMS (permission-gated) and Gmail statements.
- Local, password-protected PDF statement processing.
- Duplicate-safe reconciliation with full source provenance.
- Cashback, rewards, spending analytics, and payment reminders.
- Encrypted local database, encrypted backup, and encrypted statement storage.

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

## Security rules (non-negotiable)

- Never log card numbers, SMS/email/PDF content, passwords, OAuth tokens, or keys.
- Never store CVV, PIN, or banking credentials.
- Money is integer minor units; never floating point.
- Ambiguous data goes to a review queue; imported records are never silently discarded.
- Statement files and the database are encrypted at rest.

## Documentation

- [`docs/architecture.md`](docs/architecture.md)
- [`docs/status.md`](docs/status.md)
- [`docs/testing.md`](docs/testing.md)
- [`docs/release.md`](docs/release.md)
- [`docs/decisions.md`](docs/decisions.md)
