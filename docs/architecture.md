# Architecture

**Status:** M3–M10 are implemented and host-verified. Cards, Home, Transactions,
Statements, Rewards, and Settings consume repositories through Riverpod. Android SMS,
Gmail statement sync, encrypted PDF import, encrypted backup/restore, and local wipe are
wired. iOS, physical-device, real-OAuth, and verified bank-fixture validation remain
blocked by the environment (see `status.md`).

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
- Native code is reached through a versioned interface (method channels where practical).
- Repositories return domain entities, not database rows.
- Imported records are never silently discarded. Unmatched, ambiguous, low-confidence,
  failed, or non-reconciling records become review items with source provenance.

## Feature modules

```text
features/<name>/
  presentation/  pages, widgets, providers
```

Feature modules consume domain repositories/services through `lib/app/providers.dart` and
feature providers. Empty layers are not created for symmetry.

| Feature | Responsibility |
|---|---|
| Home | Currency-grouped limits/outstanding/available, recent activity, cashback, reward points, review banner, Gmail status |
| Cards | Card CRUD, lifecycle, metrics, recent transactions, reward account, navigation |
| Transactions | Filtered ledger, add/edit, detail, card assignment, review queue, CSV export |
| Statements | Encrypted PDF import, statement list/detail, extracted transactions, review indicators |
| Rewards | Cashback summary/entries, reward accounts, point adjustments, declarative cashback rules |
| Settings | Gmail connect/sync/disconnect, Android SMS import, PDF import, CSV export, encrypted backup/restore, import history, full local wipe |

## Application bootstrap

```text
main.dart
  └─ bootstrap.dart      error handling, ProviderScope
       └─ app.dart       MaterialApp.router
            └─ router.dart  GoRouter, StatefulShellRoute + Statements route
```

`lib/app/providers.dart` owns the lazy database and every repository/service provider:
transactions, imports, reviews, statements, cashback, rewards, email accounts, bank rules,
SMS, PDF extraction, Gmail OAuth/client/sync, backup, and local wipe. Startup does not
block on key/keystore work; the encrypted database opens when a provider first needs it.

## Navigation

Five top-level destinations from the specification §17.1:

1. Home
2. Cards
3. Transactions
4. Rewards
5. Settings

`StatefulShellRoute.indexedStack` preserves per-tab state. `/statements` is a top-level
route reachable from Settings and card detail, so statement review does not replace the
Transactions tab.

## State management

Riverpod is the only state/dependency mechanism:

- Repositories and services are provided through providers, never global singletons.
- Widgets watch focused providers; they do not hold business state in `setState`.
- Tests override providers instead of mocking widget internals.
- Provider lifetimes are explicit; nothing is `keepAlive` without a reason.
- Shared widget-test overrides live in `test/fakes/test_overrides.dart`.

## Import pipeline

All import sources converge on `ImportService`:

1. Parse source-specific input into `ParsedTransaction` records.
2. Compute a versioned SHA-256 fingerprint from card, signed amount, currency, posting day,
   normalized merchant, and transaction type.
3. Link an exact fingerprint match to the existing transaction and record source provenance.
4. Run a conservative fuzzy check (merchant similarity plus date window). Amount alone
   never merges records.
5. Match cards by last four and issuer hint. Multiple remaining candidates are ambiguous;
   the service never guesses.
6. Create a review item for unmatched, ambiguous, low-confidence, or ambiguous-duplicate
   records while retaining the canonical transaction/source row.
7. Update import-job counters idempotently.

Statement import adds validation, AES-256-GCM encrypted file storage, password-rule
resolution, PDF text extraction, parsing, card matching, transaction import, statement-row
persistence, and total reconciliation. Gmail sync feeds PDF attachments into the same
statement pipeline. Android SMS feeds parsed alerts into the same import pipeline.

## Errors and review

- Domain and data return typed failures (`core/errors`) at boundaries.
- Stable error codes use `CCM-<DOMAIN>-<NNN>` with a safe user message and a diagnostic
  that contains no sensitive content.
- Review items are the explicit home for uncertainty. `ReviewRepository` supports open,
  resolved, and dismissed states; resolving a transaction review also clears related items.
- Backup restore validates the envelope and table allow-list before replacing data.

## Logging

- `core/logging` is the only logging entry point.
- Sensitive values are never passed as log arguments. Call sites log identifiers and
  status codes, not payloads.
- SMS bodies, email bodies, PDF text, passwords, OAuth tokens, keys, full card numbers,
  CVV, and PIN are never logged.

## Platform channels

| Channel | Status |
|---|---|
| Keystore / Keychain key store (`app.creditcardmanager/security`) | Implemented M1 |
| SMS read + permission (`app.creditcardmanager/sms`) | Implemented M4, Android only |
| OAuth broker / secure token storage | Implemented M5 via `flutter_appauth` + `flutter_secure_storage` |
| PDF extraction | Implemented M6 via `syncfusion_flutter_pdf` |
| Background tasks | Not implemented; sync is user-triggered |

Channels expose the minimum surface. iOS deliberately reports SMS import as unsupported;
the app never claims access to the iOS SMS inbox.

## Milestone boundaries

M0 contains the app shell, router, tests, and docs. M1 adds encrypted persistence and keys.
M2 adds card management and schema v2. M3 adds the canonical transaction ledger, idempotent
import, source provenance, and review queue. M4 adds permission-gated Android SMS import.
M5 adds Gmail OAuth and statement-email sync. M6 adds encrypted PDF statement processing
and declarative password rules. M7 adds integer cashback/reward calculations and analytics.
M8 adds encrypted logical backup/restore and full local wipe. M9/M10 remain limited by the
absence of macOS and device hardware.

Database details, pragmas, schema conventions, and migration policy are in
`docs/database.md`. Integration boundaries and bank-adapter limits are in
`docs/bank-adapters.md`.
