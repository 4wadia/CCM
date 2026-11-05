# Fixtures

Test data lives here. It must be synthetic or irreversibly anonymized.

Rules:

- No real card numbers, statement PDFs, SMS inbox exports, email addresses,
  OAuth tokens, or personal password values.
- Prefer generated fixtures (scripts checked in alongside the data).
- Fictional issuers, senders, merchants, and card suffixes only.
- Every fixture set documents its origin and the test that consumes it.

Planned fixture sets:

| Milestone | Fixture |
|---|---|
| M3 | Canonical transaction and duplicate-link examples |
| M4 | Synthetic SMS corpus per bank, including OTP and malformed messages |
| M5 | MIME messages with and without PDF attachments |
| M6 | Generated password-protected statement PDFs per layout |
