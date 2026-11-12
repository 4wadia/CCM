# Import adapters

**Status:** Generic adapters are implemented and host-verified with synthetic data. No
bank-specific adapter is labelled verified because no anonymized real-world SMS or
statement corpus is available.

## Adapter surface

| Source | Entry point | Platform gate | Output |
|---|---|---|---|
| Android SMS | `SmsImportService` + `GenericSmsParser` | Android runtime `READ_SMS` | `ParsedTransaction` |
| Gmail statement email | `GmailSyncService` + `EmailClassifier` | OAuth configuration + user consent | Encrypted PDF → statement pipeline |
| PDF statement | `StatementImportService` + `GenericStatementParser` | Local file picker | Statement + `ParsedTransaction` |
| Manual/CSV | Transaction editor / CSV export | None | Canonical transaction |

All sources converge on `ImportService`, which owns fingerprinting, card matching,
category classification, duplicate handling, source provenance, import-job accounting, and
review creation.

## Android SMS

### Access

- `SmsChannel.kt` queries the SMS inbox read-only through a narrow method channel.
- `READ_SMS` is declared and requested at runtime only on Android.
- iOS uses `UnsupportedSmsPlatform`; the app never claims iOS SMS inbox access.
- Messages are read within a lookback window (default 30 days, limit 500) and a checkpoint
  in `app_settings` prevents re-reading the same window on every import.

### Parsing

`GenericSmsParser` is intentionally conservative:

- Rejects OTP, one-time-code, and “do not share” messages.
- Requires a transactional keyword and a positive amount.
- Supports amount-before-currency and amount-after-currency forms.
- Extracts merchant text after `at`, `to`, `from`, or `merchant:` and stops at known
  boundary words (`on`, `for`, `ref`, `dated`, `via`, `at`, `using`, `with`).
- Detects refunds/credits, payments, reversals, cash advances, fees, interest, and EMI.
- Marks declined/failed alerts as `TransactionStatus.failed` while retaining the alert.
- Uses the message timestamp when no date is present.
- Extracts only the last four digits; full card numbers are discarded.

If a message looks transactional but cannot be parsed, the import service creates an
`sms_unparsed` review item with sender and timestamp, not the message body. It does not
silently drop the message.

### Adapter tiers

| Tier | Meaning |
|---|---|
| Generic | Implemented and tested with synthetic messages |
| Bank-specific | Not implemented; requires anonymized samples and a regression corpus |
| Verified | Not claimed for any bank |

Known sender hints (HDFC, ICICI, SBI, Axis, Kotak, Amex, HSBC, Citi) are used only to
improve card matching. They do not imply a verified bank adapter.

## Gmail statement email

### Access

- Authorization Code + PKCE through `flutter_appauth`; no client secret.
- Read-only Gmail scope plus `openid` and `email`.
- Tokens are stored only in platform secure storage; the database keeps an opaque
  reference.
- Sync is user-triggered; there is no background scheduler.
- The provider checkpoint is the latest candidate received date. A failed run preserves
  the previous checkpoint.

### Classification

`EmailClassifier` uses metadata only:

- PDF attachment: +0.45
- Statement subject keywords: +0.3
- Known issuer sender domain: +0.2
- Card suffix in sender/subject: +0.05

Candidates below 0.55 confidence create a review item. Likely statements without a PDF,
oversized attachments, and failed downloads also create review items. Message bodies are
not stored or logged.

### Attachment processing

PDF attachments up to 25 MB are downloaded, validated, and passed to the statement
pipeline with the classifier's bank hint and card suffix. Duplicate statement hashes are
idempotent. The Gmail source type is `gmailStatement`.

## PDF statements

### File handling

- Only files beginning with `%PDF-` are accepted; maximum size is 25 MB.
- The file is encrypted with AES-256-GCM under an opaque `.ccmenc` name before parsing.
- The SHA-256 hash prevents duplicate statement imports.
- Plaintext exists only in memory for Syncfusion extraction.
- Password-protected or unreadable files are retained encrypted and create review items.

### Password rules

`PasswordStrategyEngine` supports constrained declarative strategies:

| Strategy | Inputs | Example |
|---|---|---|
| `name_prefix_and_birth_date` | Name, date of birth, character count, date format | `alic0703` |
| `customer_id_and_date` | Customer ID, statement date, date format | `CUST1231126` |
| `card_suffix_and_date` | Card last four, statement date, date format | `42421126` |
| `user_provided` | User password | User-entered value |

Rules are JSON in `bank_rules`; arbitrary expressions and executable code are rejected.
Rules must be `active` and have a supported configuration version. Passwords and personal
values are never stored or logged.

### Parsing and reconciliation

`GenericStatementParser` extracts statement date, period, due date, currency, previous
balance, total due, minimum due, card suffix, and table-like transaction rows. It skips
summary lines and requires decimal amounts.

After parsing:

1. Card matching uses the statement suffix and issuer hint. Multiple remaining candidates
   are ambiguous and are not guessed.
2. Transactions are imported through `ImportService` with `statement:<id>:<index>` source
   references.
3. Statement rows are saved with matched/ambiguous/unmatched status.
4. Reconciliation checks `previous balance + signed line sum` against total due, allowing
   a tolerance of max(1 minor unit, 1% of total).
5. Card ambiguity, non-reconciliation, and extraction/password failures create review
   items. The statement remains available for review.

### Adapter tiers

| Tier | Meaning |
|---|---|
| Generic | Implemented and tested with synthetic statements |
| Bank-specific | Not implemented |
| Verified | Not claimed for any bank |

## Adding a bank adapter

1. Obtain anonymized SMS/PDF samples and written permission to use them as fixtures.
2. Add a parser implementing `SmsParser` or `StatementParser` with a stable `id` and
   `version`.
3. Keep parsing declarative; never execute content from a message or statement.
4. Add regression tests for positive, negative, ambiguous, and malformed cases.
5. Register the parser in the source registry (statement parsers) or inject it into the
   SMS import service.
6. Update the adapter tier only after the fixture corpus passes. Do not label an adapter
   verified without representative samples.
7. Confirm that every unparsed transactional-looking record still becomes a review item.

## Known limitations

- No real bank samples; generic parsers may miss bank-specific formats.
- SMS permission behavior varies by OEM and installer; no device test has run.
- Gmail OAuth has not been exercised against Google's servers.
- PDF encryption variants unsupported by Syncfusion fail into review.
- There is no background sync; users trigger imports manually.
- Cashback and reward rules are user-defined or manually applied; the app does not infer
  bank reward programmes from statements.
