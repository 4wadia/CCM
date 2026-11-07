# Agent Instructions

## Start Here

- Use [README.md](README.md) for toolchain setup, project layout, and common commands.
- Follow [docs/architecture.md](docs/architecture.md) for layer boundaries and dependency direction.
- Consult [docs/security.md](docs/security.md) and [docs/database.md](docs/database.md) before changing storage, imports, keys, or sensitive data handling.
- Use [docs/testing.md](docs/testing.md) for test requirements and [docs/decisions.md](docs/decisions.md) for current technical choices. Check [docs/status.md](docs/status.md) for milestone state and [docs/release.md](docs/release.md) for platform limitations.

## Project Conventions

- Keep `lib/domain` pure Dart. Presentation code must not access SQL, parse imports, or perform financial calculations; use Riverpod providers and domain APIs.
- Data implements domain repository contracts. Keep platform and external integrations behind narrow interfaces; do not introduce global singletons.
- Represent money as integer minor units and keep totals separate by currency. Never use floating point for financial values.
- Preserve ambiguous imported records for user review; do not silently discard or assign them.
- Never store full card numbers, CVV, PINs, banking credentials, or secrets in ordinary storage. Never put financial or authentication data in logs, diagnostics, or test fixtures. Use synthetic or irreversibly anonymized fixtures only.
- Preserve fail-closed encryption and key handling. Never add plaintext fallback or automatically recreate a lost database key.
- For schema changes, add forward migrations and update schema tests. Treat generated files as outputs; modify their source and regenerate rather than hand-editing generated code.
- Add or update focused regression tests with behavior changes. Do not skip security or data-integrity tests to make checks pass.

## Verification

- In a fresh shell, source `~/development/env.sh` to configure the documented Flutter, Android, and home-directory cache environment.
- Run `./tool/check.sh` for the repository gate: format check, static analysis, tests, and Android debug build. Use `SKIP_BUILD=1 ./tool/check.sh` only when the build is unrelated to the change or unavailable; say which checks were omitted.
- For a focused change, run the relevant formatter, `flutter analyze`, or targeted `flutter test` first, then the full gate when appropriate.
- Do not claim iOS runtime validation from this Linux workspace; iOS build and device checks require macOS. Record unavailable device/platform checks as limitations rather than weakening tests.
