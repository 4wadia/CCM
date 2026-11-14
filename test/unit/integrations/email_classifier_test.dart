import 'package:credit_card_manager/domain/entities/email_account.dart';
import 'package:credit_card_manager/integrations/gmail/email_classifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final receivedAt = DateTime.utc(2026, 11, 5);

  EmailAttachment pdf({String name = 'statement.pdf'}) => EmailAttachment(
    attachmentId: 'attachment_1',
    fileName: name,
    mimeType: 'application/pdf',
    sizeBytes: 1024,
  );

  EmailAttachment image() => const EmailAttachment(
    attachmentId: 'attachment_2',
    fileName: 'receipt.png',
    mimeType: 'image/png',
    sizeBytes: 2048,
  );

  test('scores a full statement candidate and extracts card metadata', () {
    final candidate = EmailClassifier.classify(
      messageId: 'message_1',
      sender: 'statements@hdfcbank.com',
      subject: 'Your HDFC credit card statement for card ending 4242',
      receivedAt: receivedAt,
      attachments: [pdf()],
    );

    expect(candidate.confidence, 1.0);
    expect(candidate.cardLastFour, '4242');
    expect(candidate.bankHint, 'HDFC');
    expect(candidate.reason, contains('PDF attachment'));
    expect(candidate.reason, contains('statement subject'));
    expect(candidate.reason, contains('known issuer sender'));
    expect(candidate.reason, contains('card suffix'));
  });

  test('scores a PDF attachment without a statement subject', () {
    final candidate = EmailClassifier.classify(
      messageId: 'message_2',
      sender: 'someone@example.com',
      subject: 'Please find the attached document',
      receivedAt: receivedAt,
      attachments: [pdf()],
    );

    expect(candidate.confidence, closeTo(0.45, 0.0001));
    expect(candidate.cardLastFour, isNull);
    expect(candidate.bankHint, isNull);
  });

  test('returns zero confidence for unrelated email', () {
    final candidate = EmailClassifier.classify(
      messageId: 'message_3',
      sender: 'news@example.com',
      subject: 'Weekly newsletter',
      receivedAt: receivedAt,
      attachments: [image()],
    );

    expect(candidate.confidence, 0);
    expect(candidate.reason, isEmpty);
  });

  test('does not classify a non-PDF attachment as a statement', () {
    final candidate = EmailClassifier.classify(
      messageId: 'message_4',
      sender: 'alerts@icicibank.com',
      subject: 'Credit card bill',
      receivedAt: receivedAt,
      attachments: [image()],
    );

    expect(candidate.confidence, closeTo(0.5, 0.0001));
  });

  test('accepts credit-card statement messages', () {
    final candidate = EmailClassifier.classify(
      messageId: 'message_5',
      sender: 'statements@hdfcbank.com',
      subject: 'Your HDFC credit card statement for card ending 4242',
      receivedAt: receivedAt,
      attachments: [pdf()],
    );

    expect(EmailClassifier.isCreditCardMessage(candidate), isTrue);
  });

  test('rejects debit-card and bank-account statements', () {
    final debit = EmailClassifier.classify(
      messageId: 'message_6',
      sender: 'statements@hdfcbank.com',
      subject: 'Debit card statement for account ending 4242',
      receivedAt: receivedAt,
      attachments: [pdf()],
    );
    final account = EmailClassifier.classify(
      messageId: 'message_7',
      sender: 'statements@icicibank.com',
      subject: 'Your savings account statement',
      receivedAt: receivedAt,
      attachments: [pdf()],
    );

    expect(EmailClassifier.isCreditCardMessage(debit), isFalse);
    expect(EmailClassifier.isCreditCardMessage(account), isFalse);
  });

  test('accepts card-only issuer statements without a card subject', () {
    final candidate = EmailClassifier.classify(
      messageId: 'message_8',
      sender: 'statements@americanexpress.com',
      subject: 'Your monthly statement',
      receivedAt: receivedAt,
      attachments: [pdf()],
    );

    expect(EmailClassifier.isCreditCardMessage(candidate), isTrue);
  });
}
