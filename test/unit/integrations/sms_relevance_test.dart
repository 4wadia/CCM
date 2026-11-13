import 'package:credit_card_manager/integrations/sms/sms_relevance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recognizes explicit credit-card alerts', () {
    expect(
      SmsRelevanceClassifier.classify(
        'Payment of INR 5,000 received towards your HDFC Credit Card ending 4242.',
      ),
      SmsRelevance.creditCard,
    );
    expect(
      SmsRelevanceClassifier.classify(
        'Your credit card bill is ready. Log in to view it.',
      ),
      SmsRelevance.creditCard,
    );
  });

  test('rejects debit-card, account, UPI, ATM, and wallet alerts', () {
    expect(
      SmsRelevanceClassifier.classify(
        'INR 500.00 debited from A/c XX1234 on 05/11/2026 at Amazon.',
      ),
      SmsRelevance.notCreditCard,
    );
    expect(
      SmsRelevanceClassifier.classify(
        'INR 1,000 spent using your debit card ending 1111.',
      ),
      SmsRelevance.notCreditCard,
    );
    expect(
      SmsRelevanceClassifier.classify('INR 250 paid via UPI to merchant@upi.'),
      SmsRelevance.notCreditCard,
    );
    expect(
      SmsRelevanceClassifier.classify('INR 2,000 withdrawn at ATM.'),
      SmsRelevance.notCreditCard,
    );
    expect(
      SmsRelevanceClassifier.classify('INR 300 paid from wallet.'),
      SmsRelevance.notCreditCard,
    );
  });

  test('keeps card-only alerts ambiguous for last-four matching', () {
    expect(
      SmsRelevanceClassifier.classify(
        'INR 99.00 spent at Corner Cafe using card xx4242.',
      ),
      SmsRelevance.ambiguous,
    );
    expect(
      SmsRelevanceClassifier.classify('INR 99.00 spent at Corner Cafe.'),
      SmsRelevance.ambiguous,
    );
  });

  test('prefers credit-card context when a bank account is also mentioned', () {
    expect(
      SmsRelevanceClassifier.classify(
        'Payment of INR 5,000 made to your credit card from A/c XX1234.',
      ),
      SmsRelevance.creditCard,
    );
  });
}
