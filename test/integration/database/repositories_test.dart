import 'dart:io';

import 'package:credit_card_manager/data/database/app_database.dart';
import 'package:credit_card_manager/data/database/database_factory.dart';
import 'package:credit_card_manager/data/repositories/bank_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/category_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/credit_card_repository_impl.dart';
import 'package:credit_card_manager/data/repositories/settings_repository_impl.dart';
import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/entities/transaction_category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

import '../../fakes/in_memory_key_provider.dart';

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late BankRepositoryImpl banks;
  late CreditCardRepositoryImpl cards;

  final now = DateTime.utc(2026, 11, 5);

  Bank bank() => Bank(
    id: 'bank_test',
    displayName: 'Test Bank',
    countryCode: 'IN',
    region: 'India',
    createdAt: now,
    updatedAt: now,
  );

  CreditCard card({
    String id = 'card_test',
    CardStatus status = CardStatus.active,
    String displayName = 'Everyday card',
  }) {
    return CreditCard(
      id: id,
      bankId: 'bank_test',
      displayName: displayName,
      network: CardNetwork.visa,
      lastFour: '4242',
      creditLimitMinor: 25000000,
      currencyCode: 'INR',
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ccm_repository_test');
    database = await openEncryptedDatabase(
      file: File(p.join(tempDir.path, 'ccm.sqlite')),
      keyProvider: InMemoryKeyProvider(),
      background: false,
    );
    banks = BankRepositoryImpl(database);
    cards = CreditCardRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  test('round-trips banks and cards', () async {
    await banks.upsert(bank());
    await cards.upsert(card());

    final storedBank = await banks.getById('bank_test');
    expect(storedBank?.displayName, 'Test Bank');

    final storedCard = await cards.getById('card_test');
    expect(storedCard, isNotNull);
    expect(storedCard!.lastFour, '4242');
    expect(storedCard.creditLimitMinor, 25000000);
    expect(storedCard.network, CardNetwork.visa);
    expect(storedCard.status, CardStatus.active);
    expect(storedCard.currencyCode, 'INR');
  });

  test('archive hides a card without deleting it', () async {
    await banks.upsert(bank());
    await cards.upsert(card());

    await cards.archive('card_test');

    expect(await cards.getAll(), isEmpty);
    final all = await cards.getAll(includeArchived: true);
    expect(all, hasLength(1));
    expect(all.single.status, CardStatus.archived);
  });

  test('restore and close change lifecycle state', () async {
    await banks.upsert(bank());
    await cards.upsert(card());

    await cards.archive('card_test');
    await cards.restore('card_test');
    expect((await cards.getById('card_test'))?.status, CardStatus.active);

    await cards.close('card_test');
    expect(await cards.getAll(), isEmpty);
    expect((await cards.getById('card_test'))?.status, CardStatus.closed);
  });

  test('settings upsert updates in place and removes', () async {
    final settings = SettingsRepositoryImpl(database);

    expect(await settings.getPlain('theme'), isNull);

    await settings.setPlain('theme', 'dark');
    expect(await settings.getPlain('theme'), 'dark');

    await settings.setPlain('theme', 'light');
    expect(await settings.getPlain('theme'), 'light');

    await settings.remove('theme');
    expect(await settings.getPlain('theme'), isNull);
  });

  test('user categories can be added and updated', () async {
    final categories = CategoryRepositoryImpl(database);

    await categories.upsert(
      const TransactionCategory(
        id: 'cat_custom',
        name: 'Pets',
        isSystemCategory: false,
      ),
    );

    var all = await categories.getAll();
    expect(all, hasLength(13));

    await categories.upsert(
      const TransactionCategory(
        id: 'cat_custom',
        name: 'Pet care',
        isSystemCategory: false,
      ),
    );

    all = await categories.getAll();
    expect(all, hasLength(13));
    expect(
      all.singleWhere((category) => category.id == 'cat_custom').name,
      'Pet care',
    );
  });
}
