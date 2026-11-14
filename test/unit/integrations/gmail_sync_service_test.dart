import 'package:credit_card_manager/core/errors/app_failure.dart';
import 'package:credit_card_manager/domain/repositories/credit_card_repository.dart';
import 'package:credit_card_manager/domain/repositories/email_account_repository.dart';
import 'package:credit_card_manager/domain/repositories/import_job_repository.dart';
import 'package:credit_card_manager/integrations/gmail/gmail_client.dart';
import 'package:credit_card_manager/integrations/gmail/gmail_sync_service.dart';
import 'package:credit_card_manager/integrations/gmail/oauth_service.dart';
import 'package:credit_card_manager/integrations/gmail/secure_token_store.dart';
import 'package:credit_card_manager/integrations/pdf/statement_import_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOAuthService extends Mock implements OAuthService {}

class MockSecureTokenStore extends Mock implements SecureTokenStore {}

class MockGmailClient extends Mock implements GmailClient {}

class MockEmailAccountRepository extends Mock
    implements EmailAccountRepository {}

class MockImportJobRepository extends Mock implements ImportJobRepository {}

class MockReviewRepository extends Mock implements ReviewRepository {}

class MockStatementImportService extends Mock
    implements StatementImportService {}

class MockCreditCardRepository extends Mock implements CreditCardRepository {}

void main() {
  test('Gmail sync refuses to fetch before a card exists', () async {
    final oauth = MockOAuthService();
    final cards = MockCreditCardRepository();
    final accounts = MockEmailAccountRepository();
    final client = MockGmailClient();

    when(() => oauth.isConfigured).thenReturn(true);
    when(() => cards.getAll()).thenAnswer((_) async => []);

    final service = GmailSyncService(
      oauth: oauth,
      tokens: MockSecureTokenStore(),
      client: client,
      accounts: accounts,
      jobs: MockImportJobRepository(),
      reviews: MockReviewRepository(),
      statements: MockStatementImportService(),
      cards: cards,
    );

    await expectLater(
      service.sync(),
      throwsA(
        isA<AppFailure>().having(
          (error) => error.code,
          'code',
          'CCM-GMAIL-016',
        ),
      ),
    );

    verifyNever(() => accounts.firstConnected());
    verifyNever(
      () => client.searchMessages(
        accessToken: any(named: 'accessToken'),
        query: any(named: 'query'),
      ),
    );
  });
}
