// ignore_for_file: prefer_initializing_formals
import 'dart:convert';

import '../../core/errors/app_failure.dart';
import '../../domain/entities/email_account.dart';
import '../../domain/entities/import_job.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/credit_card_repository.dart';
import '../../domain/repositories/email_account_repository.dart';
import '../../domain/repositories/import_job_repository.dart';
import '../../domain/services/ids.dart';
import '../pdf/password_strategy.dart';
import '../pdf/statement_import_service.dart';
import 'email_classifier.dart';
import 'gmail_client.dart';
import 'oauth_service.dart';
import 'secure_token_store.dart';

class GmailSyncResult {
  const GmailSyncResult({
    required this.messagesExamined,
    required this.statementsProcessed,
    required this.requiresReview,
    required this.errors,
    this.ignored = 0,
  });

  final int messagesExamined;
  final int statementsProcessed;
  final int requiresReview;
  final int errors;

  /// Messages returned by Gmail that were not credit-card messages.
  final int ignored;
}

/// Orchestrates one local Gmail sync. The checkpoint is advanced only after the
/// run completes; candidate processing is idempotent through statement hashes.
class GmailSyncService {
  GmailSyncService({
    required OAuthService oauth,
    required SecureTokenStore tokens,
    required GmailClient client,
    required EmailAccountRepository accounts,
    required ImportJobRepository jobs,
    required ReviewRepository reviews,
    required StatementImportService statements,
    required CreditCardRepository cards,
  }) : _oauth = oauth,
       _tokens = tokens,
       _client = client,
       _accounts = accounts,
       _jobs = jobs,
       _reviews = reviews,
       _statements = statements,
       _cards = cards;

  final OAuthService _oauth;
  final SecureTokenStore _tokens;
  final GmailClient _client;
  final EmailAccountRepository _accounts;
  final ImportJobRepository _jobs;
  final ReviewRepository _reviews;
  final StatementImportService _statements;
  final CreditCardRepository _cards;

  bool get isConfigured => _oauth.isConfigured;

  Future<EmailAccount> connect({String? loginHint}) async {
    if (!isConfigured) {
      throw const AppFailure(
        code: 'CCM-GMAIL-001',
        message:
            'Gmail is not configured in this build. Add GMAIL_CLIENT_ID and '
            'GMAIL_REDIRECT_URI at build time.',
      );
    }
    final existing = await _accounts.firstConnected();
    final tokens = await _oauth.connect(loginHint: loginHint);
    final profile = await _client.getProfile(tokens.accessToken);
    final email = tokens.emailAddress ?? profile.emailAddress;
    final accountId = existing?.id ?? Ids.next('email_account');
    final reference = existing?.secureTokenReference ?? Ids.next('gmail_token');
    await _tokens.write(reference, tokens);
    final now = DateTime.now().toUtc();
    final account = EmailAccount(
      id: accountId,
      provider: 'gmail',
      emailAddress: email,
      secureTokenReference: reference,
      status: 'connected',
      syncEnabled: true,
      connectedAt: existing?.connectedAt ?? now,
      lastSuccessfulSync: existing?.lastSuccessfulSync,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    await _accounts.save(account);
    final checkpoint = await _accounts.checkpointFor(accountId);
    await _accounts.saveCheckpoint(
      SyncCheckpoint(
        id: checkpoint?.id ?? Ids.next('sync_checkpoint'),
        emailAccountId: accountId,
        providerCheckpoint: checkpoint?.providerCheckpoint,
        lastSyncStarted: checkpoint?.lastSyncStarted,
        lastSyncCompleted: checkpoint?.lastSyncCompleted,
        status: checkpoint?.status ?? 'idle',
        errorCode: null,
        createdAt: checkpoint?.createdAt ?? now,
        updatedAt: now,
      ),
    );
    return account;
  }

  Future<void> disconnect() async {
    final account = await _accounts.firstConnected();
    if (account == null) return;
    final tokens = await _tokens.read(account.secureTokenReference);
    try {
      if (tokens != null) {
        await _oauth.revoke(tokens.refreshToken ?? tokens.accessToken);
      }
    } catch (_) {
      // Local removal still happens. The UI warns that remote revocation may
      // need to be repeated from the Google account page.
    } finally {
      await _tokens.delete(account.secureTokenReference);
      await _accounts.markDisconnected(account.id);
    }
  }

  Future<GmailSyncResult> sync() async {
    if (!isConfigured) {
      throw const AppFailure(
        code: 'CCM-GMAIL-001',
        message:
            'Gmail is not configured in this build. Add GMAIL_CLIENT_ID and '
            'GMAIL_REDIRECT_URI at build time.',
      );
    }
    final cards = await _cards.getAll();
    if (cards.isEmpty) {
      throw const AppFailure(
        code: 'CCM-GMAIL-016',
        message:
            'Add a credit card before fetching card emails. Nothing was '
            'downloaded.',
      );
    }
    final account = await _accounts.firstConnected();
    if (account == null) {
      throw const AppFailure(
        code: 'CCM-GMAIL-002',
        message: 'Connect a Gmail account before syncing.',
      );
    }
    final stored = await _tokens.read(account.secureTokenReference);
    if (stored == null) {
      throw const AppFailure(
        code: 'CCM-GMAIL-003',
        message: 'Gmail credentials are unavailable. Reconnect the account.',
      );
    }
    var tokens = stored;
    if (tokens.expiresAt.isBefore(
      DateTime.now().add(const Duration(minutes: 2)),
    )) {
      tokens = await _oauth.refresh(tokens.refreshToken);
      await _tokens.write(account.secureTokenReference, tokens);
    }

    try {
      return await _runSync(account, tokens);
    } on GmailUnauthorizedException {
      final refreshed = await _oauth.refresh(tokens.refreshToken);
      await _tokens.write(account.secureTokenReference, refreshed);
      return _runSync(account, refreshed);
    }
  }

  Future<GmailSyncResult> _runSync(
    EmailAccount account,
    OAuthTokens tokens,
  ) async {
    final checkpoint = await _accounts.checkpointFor(account.id);
    final since = DateTime.tryParse(checkpoint?.providerCheckpoint ?? '');
    final query = GmailQueryBuilder.build(after: since);
    final now = DateTime.now().toUtc();
    final job = ImportJob(
      id: Ids.next('import'),
      sourceType: 'gmailStatement',
      status: ImportJobStatus.running,
      startedAt: now,
      recordsFound: 0,
      recordsImported: 0,
      recordsSkipped: 0,
      recordsRequiringReview: 0,
      progress: 0,
    );
    await _jobs.save(job);
    await _accounts.saveCheckpoint(
      SyncCheckpoint(
        id: checkpoint?.id ?? Ids.next('sync_checkpoint'),
        emailAccountId: account.id,
        providerCheckpoint: checkpoint?.providerCheckpoint,
        lastSyncStarted: now,
        lastSyncCompleted: checkpoint?.lastSyncCompleted,
        status: 'running',
        errorCode: null,
        createdAt: checkpoint?.createdAt ?? now,
        updatedAt: now,
      ),
    );

    var messages = 0;
    var processed = 0;
    var review = 0;
    var errors = 0;
    var ignored = 0;
    var latest = since;
    try {
      final candidates = await _client.searchMessages(
        accessToken: tokens.accessToken,
        query: query,
        maxResults: 25,
      );
      messages = candidates.length;
      for (final candidate in candidates) {
        if (latest == null || candidate.receivedAt.isAfter(latest)) {
          latest = candidate.receivedAt;
        }
        if (!EmailClassifier.isCreditCardMessage(candidate)) {
          ignored++;
          continue;
        }
        if (candidate.confidence < 0.55) {
          review++;
          await _reviews.add(
            ReviewItem(
              id: Ids.next('review'),
              entityType: 'gmail_message',
              reasonCode: 'gmail_low_confidence',
              userMessage:
                  'An email looked like a statement but its confidence was low. '
                  'Open Gmail and confirm it before relying on it.',
              sourceType: 'gmailStatement',
              sourceReference: 'gmail:${candidate.messageId}',
              details: jsonEncode(<String, Object?>{
                'senderDomain': _domain(candidate.sender),
                'receivedAt': candidate.receivedAt.toIso8601String(),
                'reason': candidate.reason,
                'attachmentCount': candidate.attachments.length,
              }),
              status: ReviewStatus.open,
              createdAt: DateTime.now().toUtc(),
            ),
          );
          continue;
        }
        final pdfs = candidate.attachments
            .where((attachment) => attachment.isPdf)
            .toList(growable: false);
        if (pdfs.isEmpty) {
          review++;
          await _reviews.add(
            ReviewItem(
              id: Ids.next('review'),
              entityType: 'gmail_message',
              reasonCode: 'gmail_no_pdf',
              userMessage:
                  'A likely statement email had no PDF attachment. It was kept '
                  'for review rather than discarded.',
              sourceType: 'gmailStatement',
              sourceReference: 'gmail:${candidate.messageId}',
              details: jsonEncode(<String, Object?>{
                'senderDomain': _domain(candidate.sender),
                'receivedAt': candidate.receivedAt.toIso8601String(),
              }),
              status: ReviewStatus.open,
              createdAt: DateTime.now().toUtc(),
            ),
          );
          continue;
        }
        for (final pdf in pdfs) {
          if (pdf.sizeBytes > 25 * 1024 * 1024) {
            review++;
            await _reviews.add(
              ReviewItem(
                id: Ids.next('review'),
                entityType: 'gmail_message',
                reasonCode: 'gmail_attachment_too_large',
                userMessage:
                    'A statement PDF exceeded the safe import size. It was '
                    'kept for review.',
                sourceType: 'gmailStatement',
                sourceReference:
                    'gmail:${candidate.messageId}:${pdf.attachmentId}',
                details: jsonEncode(<String, Object?>{
                  'senderDomain': _domain(candidate.sender),
                  'sizeBytes': pdf.sizeBytes,
                }),
                status: ReviewStatus.open,
                createdAt: DateTime.now().toUtc(),
              ),
            );
            continue;
          }
          try {
            final attachment = await _client.downloadAttachment(
              accessToken: tokens.accessToken,
              messageId: candidate.messageId,
              attachmentId: pdf.attachmentId,
            );
            final result = await _statements.importBytes(
              bytes: attachment.bytes,
              fileName: pdf.fileName,
              bankHint: candidate.bankHint,
              cardLastFour: candidate.cardLastFour,
              passwordInputs: StatementPasswordInputs(
                cardLastFour: candidate.cardLastFour,
              ),
              sourceType: TransactionSourceType.gmailStatement,
            );
            processed++;
            review += result.requiresReview;
          } catch (_) {
            errors++;
            review++;
            await _reviews.add(
              ReviewItem(
                id: Ids.next('review'),
                entityType: 'gmail_message',
                reasonCode: 'gmail_attachment_failed',
                userMessage:
                    'A statement attachment could not be imported. It was kept '
                    'for review.',
                sourceType: 'gmailStatement',
                sourceReference:
                    'gmail:${candidate.messageId}:${pdf.attachmentId}',
                details: jsonEncode(<String, Object?>{
                  'senderDomain': _domain(candidate.sender),
                  'receivedAt': candidate.receivedAt.toIso8601String(),
                }),
                status: ReviewStatus.open,
                createdAt: DateTime.now().toUtc(),
              ),
            );
          }
        }
      }

      final completedAt = DateTime.now().toUtc();
      await _accounts.saveCheckpoint(
        SyncCheckpoint(
          id: checkpoint?.id ?? Ids.next('sync_checkpoint'),
          emailAccountId: account.id,
          providerCheckpoint: (latest ?? completedAt).toUtc().toIso8601String(),
          lastSyncStarted: now,
          lastSyncCompleted: completedAt,
          status: review > 0 ? 'completedWithReview' : 'completed',
          errorCode: null,
          createdAt: checkpoint?.createdAt ?? now,
          updatedAt: completedAt,
        ),
      );
      await _accounts.recordSuccessfulSync(account.id, completedAt);
      await _jobs.save(
        ImportJob(
          id: job.id,
          sourceType: job.sourceType,
          status: review > 0
              ? ImportJobStatus.completedWithReview
              : ImportJobStatus.completed,
          startedAt: job.startedAt,
          completedAt: completedAt,
          progress: 100,
          recordsFound: messages,
          recordsImported: processed,
          recordsSkipped: ignored,
          recordsRequiringReview: review,
          errorCode: errors > 0 ? 'partial_failure' : null,
        ),
      );
      return GmailSyncResult(
        messagesExamined: messages,
        statementsProcessed: processed,
        requiresReview: review,
        errors: errors,
        ignored: ignored,
      );
    } catch (error) {
      await _accounts.saveCheckpoint(
        SyncCheckpoint(
          id: checkpoint?.id ?? Ids.next('sync_checkpoint'),
          emailAccountId: account.id,
          providerCheckpoint: checkpoint?.providerCheckpoint,
          lastSyncStarted: now,
          lastSyncCompleted: checkpoint?.lastSyncCompleted,
          status: 'failed',
          errorCode: 'gmail_sync_failed',
          createdAt: checkpoint?.createdAt ?? now,
          updatedAt: DateTime.now().toUtc(),
        ),
      );
      await _jobs.save(
        ImportJob(
          id: job.id,
          sourceType: job.sourceType,
          status: ImportJobStatus.failed,
          startedAt: job.startedAt,
          completedAt: DateTime.now().toUtc(),
          progress: 100,
          recordsFound: messages,
          recordsImported: processed,
          recordsSkipped: ignored,
          recordsRequiringReview: review,
          errorCode: 'gmail_sync_failed',
        ),
      );
      rethrow;
    }
  }

  String _domain(String sender) {
    final match = RegExp(r'@([A-Za-z0-9.-]+)').firstMatch(sender);
    return match?.group(1)?.toLowerCase() ?? '';
  }
}
