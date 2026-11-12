import '../entities/email_account.dart';

abstract interface class EmailAccountRepository {
  Future<void> save(EmailAccount account);

  Future<EmailAccount?> getById(String id);

  Future<EmailAccount?> firstConnected();

  Future<List<EmailAccount>> getAll();

  Future<void> markDisconnected(String id);

  Future<void> recordSuccessfulSync(String id, DateTime at);

  Future<void> saveCheckpoint(SyncCheckpoint checkpoint);

  Future<SyncCheckpoint?> checkpointFor(String emailAccountId);

  Future<void> deleteAll();
}

abstract interface class BankRuleRepository {
  Future<void> save(BankRule rule);

  Future<List<BankRule>> forBank(String bankId);

  Future<List<BankRule>> getAll();
}
