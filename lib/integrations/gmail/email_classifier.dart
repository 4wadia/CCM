import '../../domain/entities/email_account.dart';

/// Scores statement candidates without reading or storing the message body.
abstract final class EmailClassifier {
  static const Set<String> _knownDomains = <String>{
    'hdfcbank',
    'icicibank',
    'sbi',
    'onlinesbi',
    'axisbank',
    'kotak',
    'americanexpress',
    'amex',
    'hsbc',
    'citibank',
    'citi',
  };

  static const List<String> _subjectKeywords = <String>[
    'statement',
    'e-statement',
    'estatement',
    'credit card bill',
    'card bill',
    'monthly statement',
    'account statement',
  ];

  static const List<String> _creditCardTerms = <String>[
    'credit card',
    'creditcard',
    'card statement',
    'card bill',
    'card e-statement',
    'credit card statement',
    'credit card bill',
  ];

  static const List<String> _nonCreditCardTerms = <String>[
    'debit card',
    'account statement',
    'bank statement',
    'savings account',
    'current account',
    'fixed deposit',
    'recurring deposit',
    'upi',
    'atm',
    'wallet',
  ];

  /// Issuers that only send card statements. Other banks may send both card
  /// and bank-account statements, so they still need a credit-card subject.
  static const Set<String> _cardOnlyIssuers = <String>{
    'amex',
    'americanexpress',
  };

  /// Returns whether a message is specifically a credit-card message.
  ///
  /// This is deliberately stricter than [classify]: a message that only looks
  /// like a generic bank statement is skipped instead of entering the review
  /// queue.
  static bool isCreditCardMessage(EmailCandidate candidate) {
    final text = '${candidate.sender} ${candidate.subject}'.toLowerCase();
    if (_nonCreditCardTerms.any(text.contains)) return false;
    if (_creditCardTerms.any(text.contains)) return true;
    final cardOnlyIssuer = _cardOnlyIssuers.any(text.contains);
    if (cardOnlyIssuer &&
        (text.contains('statement') || text.contains('bill'))) {
      return true;
    }
    return false;
  }

  static EmailCandidate classify({
    required String messageId,
    required String sender,
    required String subject,
    required DateTime receivedAt,
    required List<EmailAttachment> attachments,
  }) {
    final lowerSender = sender.toLowerCase();
    final lowerSubject = subject.toLowerCase();
    var confidence = 0.0;
    final reasons = <String>[];

    if (attachments.any((attachment) => attachment.isPdf)) {
      confidence += 0.45;
      reasons.add('PDF attachment');
    }
    if (_subjectKeywords.any(lowerSubject.contains)) {
      confidence += 0.3;
      reasons.add('statement subject');
    }
    if (_knownDomains.any(lowerSender.contains)) {
      confidence += 0.2;
      reasons.add('known issuer sender');
    }
    final cardSuffix = _lastFour('$subject $sender');
    if (cardSuffix != null) {
      confidence += 0.1;
      reasons.add('card suffix');
    }
    if (confidence > 1) confidence = 1;

    return EmailCandidate(
      messageId: messageId,
      sender: sender,
      subject: subject,
      receivedAt: receivedAt,
      attachments: attachments,
      confidence: confidence,
      cardLastFour: cardSuffix,
      bankHint: _bankHint(lowerSender),
      reason: reasons.join(', '),
    );
  }

  static String? _lastFour(String value) {
    final match = RegExp(
      r'(?:ending(?:\s+with)?|xx+|\*+|••+)\s*(\d{4})\b',
      caseSensitive: false,
    ).firstMatch(value);
    return match?.group(1);
  }

  static String? _bankHint(String sender) {
    const banks = <String, String>{
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
    for (final entry in banks.entries) {
      if (sender.contains(entry.key)) return entry.value;
    }
    return null;
  }
}
