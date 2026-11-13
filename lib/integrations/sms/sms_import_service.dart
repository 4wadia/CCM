// ignore_for_file: prefer_initializing_formals
import '../../core/errors/app_failure.dart';
import '../../domain/entities/bank.dart';
import '../../domain/entities/import_job.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/credit_card_repository.dart';
import '../../domain/repositories/import_job_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/services/ids.dart';
import '../../domain/services/import_service.dart';
import 'sms_parser.dart';
import 'sms_platform.dart';
import 'sms_relevance.dart';

class SmsImportResult {
  const SmsImportResult({
    required this.imported,
    required this.skipped,
    required this.requiresReview,
    required this.messagesRead,
    required this.creditCardAlerts,
    required this.ignored,
  });

  final int imported;
  final int skipped;
  final int requiresReview;
  final int messagesRead;

  /// Messages that looked like credit-card alerts and were parsed.
  final int creditCardAlerts;

  /// Messages deliberately skipped because they were not credit-card alerts.
  final int ignored;
}

class SmsClearResult {
  const SmsClearResult({
    required this.deletedTransactions,
    required this.deletedSources,
    required this.deletedReviews,
    required this.deletedJobs,
  });

  final int deletedTransactions;
  final int deletedSources;
  final int deletedReviews;
  final int deletedJobs;
}

class SmsImportService {
  SmsImportService({
    required SmsPlatform platform,
    required ImportService importer,
    required SettingsRepository settings,
    required ReviewRepository reviews,
    required BankRepository banks,
    required CreditCardRepository cards,
    required TransactionRepository transactions,
    required ImportJobRepository jobs,
    SmsParser parser = const GenericSmsParser(),
  }) : _platform = platform,
       _importer = importer,
       _settings = settings,
       _reviews = reviews,
       _banks = banks,
       _cards = cards,
       _transactions = transactions,
       _jobs = jobs,
       _parser = parser;

  final SmsPlatform _platform;
  final ImportService _importer;
  final SettingsRepository _settings;
  final ReviewRepository _reviews;
  final BankRepository _banks;
  final CreditCardRepository _cards;
  final TransactionRepository _transactions;
  final ImportJobRepository _jobs;
  final SmsParser _parser;

  static const String checkpointKey = 'sms.last_import_at';

  bool get isSupported => _platform.isSupported;

  Future<bool> hasPermission() => _platform.hasPermission();

  Future<bool> requestPermission() => _platform.requestPermission();

  Future<SmsImportResult> importRecent({int days = 30, int limit = 500}) async {
    if (!isSupported) {
      throw const AppFailure(
        code: 'CCM-SMS-002',
        message: 'SMS import is available only on Android.',
      );
    }
    if (!await _platform.hasPermission()) {
      throw const AppFailure(
        code: 'CCM-SMS-005',
        message: 'SMS permission is required to import transaction alerts.',
      );
    }

    final now = DateTime.now();
    final checkpoint = DateTime.tryParse(
      await _settings.getPlain(checkpointKey) ?? '',
    );
    final from = checkpoint != null
        ? checkpoint.subtract(const Duration(days: 1))
        : now.subtract(Duration(days: days));
    final messages = await _platform.readMessages(
      from: from,
      to: now,
      limit: limit,
    );
    final banks = await _banks.getAll();
    final cards = await _cards.getAll(includeArchived: false);
    final knownLastFour = cards.map((card) => card.lastFour).toSet();
    final parsed = <ParsedTransaction>[];
    var lastDate = checkpoint;
    var creditCardAlerts = 0;
    var ignored = 0;
    var unparsedReview = 0;

    for (final message in messages) {
      if (lastDate == null || message.receivedAt.isAfter(lastDate)) {
        lastDate = message.receivedAt;
      }
      final relevance = SmsRelevanceClassifier.classify(message.body);
      if (relevance == SmsRelevance.notCreditCard) {
        ignored++;
        continue;
      }

      final bankHint = _bankHint(message.sender, banks);
      final results = _parser.parse(message, bankHint: bankHint);
      if (results.isEmpty) {
        if (relevance == SmsRelevance.creditCard &&
            _looksTransactional(message.body)) {
          await _reviews.add(
            ReviewItem(
              id: Ids.next('review'),
              entityType: 'sms',
              reasonCode: 'sms_unparsed',
              userMessage:
                  'A credit-card SMS looked like a transaction alert but could '
                  'not be read confidently. Review it rather than losing it.',
              sourceType: TransactionSourceType.sms.name,
              sourceReference: 'sms:${message.id}',
              details:
                  '{"sender":"${_escape(message.sender)}","receivedAt":"${message.receivedAt.toIso8601String()}"}',
              status: ReviewStatus.open,
              createdAt: DateTime.now().toUtc(),
            ),
          );
          unparsedReview++;
        } else {
          ignored++;
        }
        continue;
      }

      if (relevance == SmsRelevance.ambiguous) {
        final matchesKnownCard = results.any(
          (record) =>
              record.cardLastFour != null &&
              knownLastFour.contains(record.cardLastFour),
        );
        if (!matchesKnownCard) {
          ignored++;
          continue;
        }
      }

      creditCardAlerts++;
      parsed.addAll(results);
    }

    final result = await _importer.importParsed(
      sourceType: TransactionSourceType.sms,
      records: parsed,
      sourceReferencePrefix: 'sms-batch',
    );

    if (messages.isNotEmpty) {
      await _settings.setPlain(
        checkpointKey,
        (lastDate ?? now).toUtc().toIso8601String(),
      );
    }

    return SmsImportResult(
      imported: result.imported,
      skipped: result.skipped,
      requiresReview: result.requiresReview + unparsedReview,
      messagesRead: messages.length,
      creditCardAlerts: creditCardAlerts,
      ignored: ignored,
    );
  }

  /// Removes SMS-imported transactions and SMS review/import history from this
  /// app. It never deletes messages from the phone's inbox.
  Future<SmsClearResult> clearImported() async {
    final cleanup = await _transactions.clearImportedSource(
      TransactionSourceType.sms,
    );
    final deletedReviews = await _reviews.deleteBySourceType(
      TransactionSourceType.sms.name,
    );
    final deletedJobs = await _jobs.deleteBySourceType(
      TransactionSourceType.sms.name,
    );
    await _settings.remove(checkpointKey);
    return SmsClearResult(
      deletedTransactions: cleanup.deletedTransactions,
      deletedSources: cleanup.deletedSources,
      deletedReviews: deletedReviews,
      deletedJobs: deletedJobs,
    );
  }

  bool _looksTransactional(String body) {
    return RegExp(
          r'\b(?:spent|purchase|debited|charged|refund|credited|withdrawn|payment)\b',
          caseSensitive: false,
        ).hasMatch(body) &&
        RegExp(r'[\d,]+(?:\.\d{1,2})?').hasMatch(body);
  }

  String? _bankHint(String sender, List<Bank> banks) {
    final lower = sender.toLowerCase();
    for (final bank in banks) {
      final name = bank.displayName.toLowerCase();
      if (name.isNotEmpty && lower.contains(name)) return bank.displayName;
    }
    const known = <String, String>{
      'hdfc': 'HDFC',
      'icici': 'ICICI',
      'sbi': 'State Bank',
      'axis': 'Axis',
      'kotak': 'Kotak',
      'amex': 'American Express',
      'americanexpress': 'American Express',
      'hsbc': 'HSBC',
      'citi': 'Citibank',
    };
    for (final entry in known.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return null;
  }

  String _escape(String value) =>
      value.replaceAll('\\', '\\\\').replaceAll('"', '\\"');
}
