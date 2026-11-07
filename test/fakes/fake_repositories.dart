import 'package:credit_card_manager/domain/entities/bank.dart';
import 'package:credit_card_manager/domain/entities/credit_card.dart';
import 'package:credit_card_manager/domain/repositories/bank_repository.dart';
import 'package:credit_card_manager/domain/repositories/credit_card_repository.dart';

class FakeBankRepository implements BankRepository {
  final Map<String, Bank> banks = <String, Bank>{};

  @override
  Future<List<Bank>> getAll() async {
    final result = banks.values.toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));
    return result;
  }

  @override
  Future<Bank?> getById(String id) async => banks[id];

  @override
  Future<void> upsert(Bank bank) async {
    banks[bank.id] = bank;
  }
}

class FakeCreditCardRepository implements CreditCardRepository {
  final Map<String, CreditCard> cards = <String, CreditCard>{};
  int archiveCalls = 0;
  int restoreCalls = 0;
  int closeCalls = 0;

  @override
  Future<List<CreditCard>> getAll({bool includeArchived = false}) async {
    final result =
        cards.values.where((card) => includeArchived || card.isActive).toList()
          ..sort((a, b) => a.displayName.compareTo(b.displayName));
    return result;
  }

  @override
  Future<CreditCard?> getById(String id) async => cards[id];

  @override
  Future<void> upsert(CreditCard card) async {
    cards[card.id] = card;
  }

  @override
  Future<void> archive(String id) async {
    archiveCalls++;
    _setStatus(id, CardStatus.archived);
  }

  @override
  Future<void> restore(String id) async {
    restoreCalls++;
    _setStatus(id, CardStatus.active);
  }

  @override
  Future<void> close(String id) async {
    closeCalls++;
    _setStatus(id, CardStatus.closed);
  }

  void _setStatus(String id, CardStatus status) {
    final card = cards[id];
    if (card == null) return;
    cards[id] = CreditCard(
      id: card.id,
      bankId: card.bankId,
      displayName: card.displayName,
      cardholderName: card.cardholderName,
      network: card.network,
      lastFour: card.lastFour,
      creditLimitMinor: card.creditLimitMinor,
      currentOutstandingMinor: card.currentOutstandingMinor,
      currencyCode: card.currencyCode,
      statementDay: card.statementDay,
      dueDay: card.dueDay,
      billingCycleStart: card.billingCycleStart,
      billingCycleEnd: card.billingCycleEnd,
      status: status,
      rewardProgramme: card.rewardProgramme,
      colorValue: card.colorValue,
      createdAt: card.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
  }
}
