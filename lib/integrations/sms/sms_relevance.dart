/// Whether an SMS looks like it belongs to a credit card.
///
/// The Android inbox contains debit-card, bank-account, UPI, and wallet alerts
/// as well as credit-card alerts. SMS import must not turn those into credit
/// card transactions or review items.
enum SmsRelevance {
  /// The message explicitly mentions a credit card or a card bill/statement.
  creditCard,

  /// The message explicitly mentions a debit card, bank account, UPI, ATM,
  /// wallet, or another non-credit-card payment channel.
  notCreditCard,

  /// The message mentions a card but not which kind. The import service can
  /// still accept it when the last four digits match one of the user's credit
  /// cards.
  ambiguous,
}

abstract final class SmsRelevanceClassifier {
  static final RegExp _creditCard = RegExp(
    r'\b(?:credit\s*card|creditcard|credit\s*card\s*(?:bill|statement|payment)|'
    r'card\s*(?:bill|statement))\b',
    caseSensitive: false,
  );

  static final RegExp _notCreditCard = RegExp(
    r'\b(?:debit\s*card|a/c|account|savings|current\s*account|'
    r'upi|imps|neft|rtgs|atm|wallet|net\s*banking|internet\s*banking|'
    r'fixed\s*deposit|recurring\s*deposit)\b',
    caseSensitive: false,
  );

  static final RegExp _cardContext = RegExp(
    r'\b(?:card\s*(?:no\.?\s*)?(?:ending|xx+|\*+)|'
    r'(?:ending|xx+|\*+)[\s:.-]*\d{4}|card\s+\d{4})\b',
    caseSensitive: false,
  );

  /// Classifies a message using only its text. Sender-based bank hints are not
  /// enough because one sender may alert for both debit and credit cards.
  static SmsRelevance classify(String body) {
    if (_creditCard.hasMatch(body)) return SmsRelevance.creditCard;
    if (_notCreditCard.hasMatch(body)) return SmsRelevance.notCreditCard;
    if (_cardContext.hasMatch(body)) return SmsRelevance.ambiguous;
    return SmsRelevance.ambiguous;
  }
}
