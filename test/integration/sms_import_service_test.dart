import 'dart:io';

import 'package:credit_card_manager/core/errors/app_failure.dart';
import 'package:credit_card_manager/data/database/app_database.dart';
import 'package:credit_card_manager/data/database/database_factory.dart';
import 'package:credit_card_manager/data/repositories/bank_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/category_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/credit_card_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/import_repositories_impl.dart';
import 'package:credit_card_manager/data/repositories/settings_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/transaction_repository_impl.dart';
import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/entities/sms_message.dart';
import 'package:credit_card_manager/domain/entities/transaction.dart';
import 'package:credit_card_manager/domain/services/import_service.dart';
import 'package:credit_card_manager/integrations/sms/sms_import_service.dart';
import 'package:credit_card_manager/integrations/sms/sms_platform.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../fakes/in_memory_key_provider.dart';

class FakeSmsPlatform implements SmsPlatform {
  FakeSmsPlatform(this.messages, {this.permission = true});

  final List<SmsMessage> messages;
  bool permission;
  int readCalls = 0;

  @override
  bool get isSupported => true;

  @override
  Future<bool> hasPermission() async => permission;

  @override
  Future<bool> requestPermission() async => permission;

  @override
  Future<List<SmsMessage>> readMessages({
    required DateTime from,
    DateTime? to,
    int limit = 500,
  }) async {
    readCalls++;
    return messages
        .where((message) => !message.receivedAt.isBefore(from))
        .take(limit)
        .toList(growable: false);
  }
}

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late BankRepositoryImpl banks;
  late CreditCardRepositoryImpl cards;
  late TransactionRepositoryImpl transactions;
  late ImportJobRepositoryImpl jobs;
  late ReviewRepositoryImpl reviews;
  late SettingsRepositoryImpl settings;
  late SmsImportService service;
  late FakeSmsPlatform platform;

  final now = DateTime.utc(2026, 11, 5, 12);

  Bank bank() => Bank(
    id: 'bank_1',
    displayName: 'Alpha Bank',
    countryCode: 'IN',
    region: 'India',
    createdAt: now,
    updatedAt: now,
  );

  CreditCard card() => CreditCard(
    id: 'card_1',
    bankId: 'bank_1',
    displayName: 'Alpha Card',
    network: CardNetwork.visa,
    lastFour: '4242',
    creditLimitMinor: 1000000,
    currencyCode: 'INR',
    status: CardStatus.active,
    createdAt: now,
    updatedAt: now,
  );

  SmsMessage sms(String id, String body) =>
      SmsMessage(id: id, sender: 'HDFCBK', body: body, receivedAt: now);

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_sms_import_test');
    database = await openEncryptedDatabase(
      file: File(p.join(tempDir.path, 'ccm.sqlite')),
      keyProvider: InMemoryKeyProvider(),
      background: false,
    );
    banks = BankRepositoryImpl(database);
    cards = CreditCardRepositoryImpl(database);
    transactions = TransactionRepositoryImpl(database);
    jobs = ImportJobRepositoryImpl(database);
    reviews = ReviewRepositoryImpl(database);
    settings = SettingsRepositoryImpl(database);
    await banks.upsert(bank());
    await cards.upsert(card());

    platform = FakeSmsPlatform(<SmsMessage>[
      sms(
        'sms_credit',
        'INR 1,250.50 spent at Coffee House on 05/11/2026 using card ending '
            '4242.',
      ),
      sms(
        'sms_debit',
        'INR 500.00 debited from A/c XX1234 on 05/11/2026 at Amazon.',
      ),
      sms('sms_upi', 'INR 250.00 paid via UPI to merchant@upi on 05/11/2026.'),
      sms(
        'sms_ambiguous_known',
        'INR 99.00 spent at Corner Cafe using card xx4242.',
      ),
      sms(
        'sms_ambiguous_unknown',
        'INR 75.00 spent at Unknown Shop using card xx9999.',
      ),
      sms(
        'sms_credit_unparsed',
        'INR 0.00 spent on your credit card ending 4242.',
      ),
    ]);

    service = SmsImportService(
      platform: platform,
      importer: ImportService(
        transactions: transactions,
        jobs: jobs,
        reviews: reviews,
        cards: cards,
        banks: banks,
        categories: CategoryRepositoryImpl(database),
      ),
      settings: settings,
      reviews: reviews,
      banks: banks,
      cards: cards,
      transactions: transactions,
      jobs: jobs,
    );
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  test(
    'imports credit-card alerts and ignores other payment messages',
    () async {
      final result = await service.importRecent();

      expect(result.messagesRead, 6);
      expect(result.creditCardAlerts, 2);
      expect(result.imported, 2);
      expect(result.ignored, 3);
      expect(result.requiresReview, 1);
      expect(await transactions.count(const TransactionFilter()), 2);

      final stored = await transactions.search();
      expect(
        stored.map((transaction) => transaction.displayMerchant),
        containsAll(<String>['Coffee House', 'Corner Cafe']),
      );

      final open = await reviews.listOpen();
      expect(open, hasLength(1));
      expect(open.single.reasonCode, 'sms_unparsed');
      expect(open.single.sourceType, 'sms');
    },
  );

  test('refuses to read the inbox when no active card exists', () async {
    await cards.archive('card_1');

    await expectLater(
      service.importRecent(),
      throwsA(
        isA<AppFailure>().having((error) => error.code, 'code', 'CCM-SMS-006'),
      ),
    );

    expect(platform.readCalls, 0);
    expect(await transactions.count(const TransactionFilter()), 0);
  });

  test('clears SMS-imported data without touching the phone inbox', () async {
    await service.importRecent();
    expect(await transactions.count(const TransactionFilter()), 2);
    expect(await reviews.countOpen(), 1);
    expect(await settings.getPlain(SmsImportService.checkpointKey), isNotNull);
    final inboxBefore = platform.messages.length;

    final cleared = await service.clearImported();

    expect(cleared.deletedTransactions, 2);
    expect(cleared.deletedSources, 2);
    expect(cleared.deletedReviews, 1);
    expect(cleared.deletedJobs, 1);
    expect(await transactions.count(const TransactionFilter()), 0);
    expect(await reviews.countOpen(), 0);
    expect(await jobs.recent(), isEmpty);
    expect(await settings.getPlain(SmsImportService.checkpointKey), isNull);
    expect(platform.messages, hasLength(inboxBefore));
  });
}
