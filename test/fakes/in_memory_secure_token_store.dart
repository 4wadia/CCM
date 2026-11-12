import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/integrations/gmail/secure_token_store.dart';

/// In-memory OAuth token store for tests. Tokens never touch secure storage.
class InMemorySecureTokenStore implements SecureTokenStore {
  final Map<String, OAuthTokens> tokens = <String, OAuthTokens>{};
  final List<String> deletedReferences = <String>[];

  @override
  Future<OAuthTokens?> read(String reference) async => tokens[reference];

  @override
  Future<void> write(String reference, OAuthTokens value) async {
    tokens[reference] = value;
  }

  @override
  Future<void> delete(String reference) async {
    deletedReferences.add(reference);
    tokens.remove(reference);
  }
}
