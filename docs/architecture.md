# Architecture

**Status:** M0 foundation. Database, integrations, and feature modules are added in later
milestones; this document describes the boundaries those additions must respect.

## Layers

| Layer | Location | Allowed dependencies |
|---|---|---|
| Presentation | `lib/features/*/presentation`, `lib/shared/widgets` | domain, Riverpod, Flutter |
| Domain | `lib/domain` | Dart only (`dart:core`, `dart:math`, etc.) |
| Data | `lib/data` | domain, Drift, platform storage APIs |
| Integration | `lib/integrations` | domain contracts, HTTP/native bridges |
| Platform | `android/`, `ios/` | native SDKs, exposed through narrow channels |

Dependency direction:

```text
Presentation ──> Domain <── Data
                    ^
                    │
               Integrations ──> Platform
```

Rules:

- Domain imports no Flutter widgets, no Drift generated code, no Android/iOS APIs.
- Presentation never runs SQL, parses SMS/PDFs, or performs financial arithmetic.
- Data implements domain repository interfaces; the domain never knows Drift exists.
- Native code is reached through a versioned interface (Pigeon where practical).
- Repositories return domain entities, not database rows.

## Feature modules

Each feature uses only the layers it needs:

```text
features/<name>/
  data/          datasources, models, repository implementations
  domain/        entities, repository interfaces, use cases
  presentation/  pages, widgets, providers
```

Empty layers are not created for symmetry.

## Application bootstrap

```text
main.dart
  └─ bootstrap.dart      error handling, ProviderScope, future app-wide init
       └─ app.dart       MaterialApp.router
            └─ router.dart  GoRouter, StatefulShellRoute with 5 destinations
```

M0 has no database, network, or platform initialization. Those hooks belong in
`bootstrap.dart` and are added only when the owning milestone lands.

## Navigation

Five top-level destinations from the specification §17.1:

1. Home
2. Cards
3. Transactions
4. Rewards
5. Settings

`StatefulShellRoute.indexedStack` preserves per-tab state. Feature pages are registered
as branches so deep links and future nested routes do not require a router rewrite.

## State management

Riverpod is the only state/dependency mechanism:

- Repositories and services are provided through providers, never global singletons.
- Widgets watch focused providers; they do not hold business state in `setState`.
- Tests override providers instead of mocking widget internals.
- Provider lifetimes are explicit; nothing is `keepAlive` without a reason.

## Errors

- Domain and data return typed failures (`core/errors`), not raw exceptions, at boundaries.
- Stable error codes use the `CCM-<DOMAIN>-<NNN>` format with a safe user message and a
  diagnostic that contains no sensitive content.
- Imports that cannot be fully resolved create review-queue records instead of dropping data.

## Logging

- `core/logging` is the only logging entry point.
- Sensitive values are never passed as log arguments. Call sites log identifiers and
  status codes, not payloads.
- A log-capture test asserts that fixtures' secrets never appear in output.

## Platform channels

Planned integrations and their owning milestone:

| Channel | Milestone |
|---|---|
| Keystore / Keychain key wrap | M1 |
| SMS read + permission | M4 |
| OAuth broker / secure token storage | M5 |
| Background tasks | M5/M10 |

Channels are versioned and expose the minimum surface. No channel returns bulk SMS,
email, or PDF content to callers that do not need it.

## Milestone boundaries

M0 intentionally contains **no** database, SMS, Gmail, PDF, reward, or networking code.
Per specification §25, those begin only after M1 validates encryption and migrations.
