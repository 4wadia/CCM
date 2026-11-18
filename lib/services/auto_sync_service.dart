import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/entities/sms_message.dart';
import '../integrations/gmail/android_google_auth_service.dart';
import '../integrations/gmail/oauth_service.dart';
import '../integrations/sms/sms_parser.dart';
import '../integrations/sms/sms_platform.dart';
import '../models/financial_models.dart';

class SyncResult {
  final List<TransactionModel> transactions;
  final double monthSpend;
  final int statementPoints;
  final double cashbackEarned;
  final String statementDueDate;
  final int syncedCount;
  final String sourceDescription;

  const SyncResult({
    required this.transactions,
    required this.monthSpend,
    required this.statementPoints,
    required this.cashbackEarned,
    required this.statementDueDate,
    required this.syncedCount,
    required this.sourceDescription,
  });
}

class FirstTimeSetupResult {
  final List<CreditCardModel> addedCards;
  final List<TransactionModel> transactions;
  final int totalScanned;
  final int validCreditCardPaymentCount;
  final int duplicatesIgnored;
  final int billRemindersIgnored;
  final bool readFromNativeSms;

  const FirstTimeSetupResult({
    required this.addedCards,
    required this.transactions,
    required this.totalScanned,
    required this.validCreditCardPaymentCount,
    required this.duplicatesIgnored,
    required this.billRemindersIgnored,
    this.readFromNativeSms = false,
  });
}

class _CardAggregation {
  final IndianBank bank;
  final String last4;
  final CardSupplier brand;
  double totalSpent = 0;
  int txCount = 0;

  _CardAggregation({
    required this.bank,
    required this.last4,
    required this.brand,
  });
}

class AutoSyncService {
  final SmsPlatform _smsPlatform;
  final OAuthService _googleAuth;
  final http.Client _httpClient;

  AutoSyncService({
    SmsPlatform? smsPlatform,
    OAuthService? googleAuth,
    http.Client? httpClient,
  }) : _smsPlatform = smsPlatform ?? MethodChannelSmsPlatform(),
       _googleAuth = googleAuth ?? AndroidGoogleAuthService(),
       _httpClient = httpClient ?? http.Client();

  /// Requests all necessary permissions (SMS, Notifications).
  Future<Map<String, bool>> requestAllPermissions() async {
    bool smsGranted = false;
    bool notificationGranted = false;

    try {
      smsGranted = await _smsPlatform.requestPermission();
    } catch (_) {}

    try {
      notificationGranted = await _smsPlatform.requestNotificationPermission();
    } catch (_) {}

    return {'sms': smsGranted, 'notifications': notificationGranted};
  }

  /// Checks current status of all permissions.
  Future<Map<String, bool>> checkPermissions() async {
    bool sms = false;
    bool notif = false;
    try {
      sms = await _smsPlatform.hasPermission();
    } catch (_) {}
    try {
      notif = await _smsPlatform.hasNotificationPermission();
    } catch (_) {}
    return {'sms': sms, 'notifications': notif};
  }

  /// Authorizes Google Account and fetches user profile name & photo.
  Future<UserProfileModel?> connectGoogleAccount() async {
    try {
      final tokens = await _googleAuth.connect();
      return await fetchGoogleUserProfile(tokens.accessToken);
    } catch (_) {
      // OAuth is optional. Never invent a profile when the real Google flow is
      // unavailable; the caller keeps the user in the unconnected state.
      return null;
    }
  }

  /// Fetches Google User Profile (Name, Email, Profile Photo).
  Future<UserProfileModel> fetchGoogleUserProfile(String accessToken) async {
    final response = await _httpClient.get(
      Uri.parse('https://www.googleapis.com/oauth2/v3/userinfo'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw StateError('Google profile could not be loaded.');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    return UserProfileModel(
      name: data['name'] as String? ?? '',
      email: data['email'] as String?,
      photoUrl: data['picture'] as String?,
      isEmailConnected: true,
      lastSyncedAt: DateTime.now(),
    );
  }

  /// Reads last month's SMS and email statement data for the newly added card.
  Future<SyncResult> syncLastMonthForCard({
    required CreditCardModel card,
  }) async {
    final now = DateTime.now();
    final oneMonthAgo = now.subtract(const Duration(days: 30));
    final last4 = card.lastFour;

    final foundTransactions = <TransactionModel>[];
    bool readFromNativeSms = false;

    // 1. Try reading real SMS messages from Android Inbox
    try {
      final messages = await _smsPlatform.readMessages(
        from: oneMonthAgo,
        to: now,
        limit: 200,
      );

      if (messages.isNotEmpty) {
        readFromNativeSms = true;
        const parser = GenericSmsParser();
        for (final msg in messages) {
          final parsedList = parser.parse(
            msg,
            bankHint: card.bankName.displayName,
          );
          for (final parsed in parsedList) {
            // Check if matches this card's last 4 or bank hint
            if (parsed.cardLastFour == null || parsed.cardLastFour == last4) {
              final amountRupees = parsed.amountMinor / 100.0;
              final ref =
                  parsed.sourceReference?.replaceAll(':', '-') ??
                  '${DateTime.now().millisecondsSinceEpoch}';
              foundTransactions.add(
                TransactionModel(
                  id: 'tx-sms-$ref',
                  title: parsed.description,
                  category: _categorize(parsed.description),
                  amount: amountRupees,
                  type: parsed.transactionType.isDebit
                      ? TransactionType.expense
                      : TransactionType.income,
                  date: _formatShortDate(parsed.transactionDate),
                  time: '14:30',
                  cardLast4: last4,
                  cardBank: card.bankName,
                  cardBrand: card.brand,
                  merchant: parsed.merchant ?? parsed.description,
                  referenceId: 'SMS-$ref',
                  status: TransactionStatus.completed,
                ),
              );
            }
          }
        }
      }
    } catch (_) {}

    double totalSpent = 0;
    for (final tx in foundTransactions) {
      if (tx.type == TransactionType.expense) {
        totalSpent += tx.amount;
      }
    }

    final isCashback =
        card.cardTier.toLowerCase().contains('amazon') ||
        card.cardTier.toLowerCase().contains('cashback') ||
        card.cardTier.toLowerCase().contains('millennia') ||
        card.cardTier.toLowerCase().contains('ace');

    final statementPoints = isCashback ? 0 : ((totalSpent / 150) * 4).round();
    final cashbackEarned = isCashback
        ? (totalSpent * 0.05).roundToDouble()
        : (totalSpent * 0.015).roundToDouble();

    return SyncResult(
      transactions: foundTransactions,
      monthSpend: totalSpent,
      statementPoints: statementPoints,
      cashbackEarned: cashbackEarned,
      statementDueDate: foundTransactions.isEmpty
          ? ''
          : '05 ${formatMonthShort(now.month + 1)}',
      syncedCount: foundTransactions.length,
      sourceDescription: readFromNativeSms
          ? 'Live SMS & Statement Extraction'
          : 'No matching SMS found',
    );
  }

  static final RegExp _billPaymentReminderRegex = RegExp(
    r'\b(?:bill\s*(?:payment\s*)?reminder|payment\s*due|bill\s*generated|'
    r'total\s*amount\s*due|minimum\s*amount\s*due|min(?:imum)?\s*due|'
    r'total\s*due|is\s*due\s*on|due\s*date(?:\s*is|:)?|please\s*pay|'
    r'pay\s*(?:your\s*)?bill|to\s*avoid\s*late\s*fee|bill\s*of\s*rs|'
    r'e-statement|statement\s*generated)\b',
    caseSensitive: false,
  );

  static final RegExp _debitCardOrAccountRegex = RegExp(
    r'\b(?:debit\s*card|using\s*dc\b|a/c\s*(?:no\.?\s*)?(?:xx+|\*+)?\d+|'
    r'account\s*(?:no\.?\s*)?(?:xx+|\*+)?\d+\s*debited)\b',
    caseSensitive: false,
  );

  static final RegExp _otpRegex = RegExp(
    r'\b(?:otp|one[\s-]?time|verification code|do not share)\b',
    caseSensitive: false,
  );

  static final RegExp _creditCardContextRegex = RegExp(
    r'\b(?:credit\s*card|creditcard|\bcc\b|card\s*(?:no\.?\s*)?(?:xx+|\*+)?\d{4}|'
    r'card\s*ending(?:\s*with)?\s*\d{4}|using\s*card(?:\s*ending)?\s*\d{4})\b',
    caseSensitive: false,
  );

  static final RegExp _spendPaymentRegex = RegExp(
    r'\b(?:spent|spend|purchase|debited|charged|paid|payment(?:\s*of)?|swiped|txn)\b',
    caseSensitive: false,
  );

  static final RegExp _amountRegex = RegExp(
    r'(?:(?:INR|USD|Rs\.?|₹|\$)\s*)([\d,]+(?:\.\d{1,2})?)|([\d,]+(?:\.\d{1,2})?)\s*(?:INR|USD|Rs\.?|₹|\$)',
    caseSensitive: false,
  );

  static final RegExp _lastFourRegex = RegExp(
    r'(?:ending(?:\s+with)?|card\s*(?:no\.?\s*)?(?:xx+|\*+)?|xx+|\*+)[\s:.-]*(\d{4})\b',
    caseSensitive: false,
  );

  /// Checks if message is a bill payment reminder or due alert.
  static bool isBillPaymentReminder(String body) {
    return _billPaymentReminderRegex.hasMatch(body);
  }

  /// Strictly filters for credit card payment/spend messages only.
  static bool isCreditCardPaymentMessage(String body, {String? sender}) {
    // 1. Bill payment reminders must NEVER be read
    if (_billPaymentReminderRegex.hasMatch(body)) return false;

    // 2. Reject OTP / verification messages
    if (_otpRegex.hasMatch(body)) return false;

    // 3. Reject debit cards or generic bank account debits
    final lower = body.toLowerCase();
    if (_debitCardOrAccountRegex.hasMatch(body) &&
        !lower.contains('credit card') &&
        !lower.contains('creditcard')) {
      return false;
    }

    // 4. Must have an amount
    if (!_amountRegex.hasMatch(body)) return false;

    // 5. Must have spend/payment intent
    if (!_spendPaymentRegex.hasMatch(body)) return false;

    // 6. Must have credit card context (in body or sender)
    final senderUpper = sender?.toUpperCase() ?? '';
    final isKnownCardSender =
        senderUpper.contains('SBICRD') ||
        senderUpper.contains('HDFCBK') ||
        senderUpper.contains('ICICIB') ||
        senderUpper.contains('AXISBK') ||
        senderUpper.contains('KOTAKB') ||
        senderUpper.contains('INDUSB') ||
        senderUpper.contains('RBLCRD') ||
        senderUpper.contains('IDFC') ||
        senderUpper.contains('YESBK') ||
        senderUpper.contains('FEDBK') ||
        senderUpper.contains('AUBANK') ||
        senderUpper.contains('BOBCRD') ||
        senderUpper.contains('PNBCRD') ||
        senderUpper.contains('CANARA') ||
        senderUpper.contains('UNIONB') ||
        senderUpper.contains('BOI') ||
        senderUpper.contains('CENTBK') ||
        senderUpper.contains('INDIANB') ||
        senderUpper.contains('IOB') ||
        senderUpper.contains('UCOBK') ||
        senderUpper.contains('MAHABK') ||
        senderUpper.contains('PSB') ||
        senderUpper.contains('IDBIBK') ||
        senderUpper.contains('CUB') ||
        senderUpper.contains('SIB') ||
        senderUpper.contains('KVB') ||
        senderUpper.contains('DCB') ||
        senderUpper.contains('CSB') ||
        senderUpper.contains('BANDHAN') ||
        senderUpper.contains('DBS') ||
        senderUpper.contains('SCB') ||
        senderUpper.contains('HSBC') ||
        senderUpper.contains('CITI') ||
        senderUpper.contains('AMEX') ||
        senderUpper.contains('SBM') ||
        senderUpper.contains('EQUITAS') ||
        senderUpper.contains('UJJIVAN') ||
        senderUpper.contains('JANA') ||
        senderUpper.contains('ESAF') ||
        senderUpper.contains('SURYODAY') ||
        senderUpper.contains('UTKARSH') ||
        senderUpper.contains('CAPITAL') ||
        senderUpper.contains('NESFB') ||
        senderUpper.contains('UNITY') ||
        senderUpper.contains('SHIVALIK');

    final hasCardContext =
        _creditCardContextRegex.hasMatch(body) ||
        (isKnownCardSender && _lastFourRegex.hasMatch(body));

    return hasCardContext;
  }

  /// Extracts bank from sender address or body text.
  static IndianBank? detectBank(String sender, String body) {
    final s = sender.toUpperCase();
    final b = body.toLowerCase();

    if (s.contains('HDFC') || b.contains('hdfc')) {
      return IndianBank.hdfc;
    }
    if (s.contains('ICICI') || b.contains('icici')) {
      return IndianBank.icici;
    }
    if (s.contains('SBICRD') ||
        s.contains('SBI') ||
        b.contains('sbi card') ||
        b.contains('state bank')) {
      return IndianBank.sbi;
    }
    if (s.contains('AXIS') || b.contains('axis bank')) {
      return IndianBank.axis;
    }
    if (s.contains('KOTAK') || b.contains('kotak')) {
      return IndianBank.kotak;
    }
    if (s.contains('INDUS') || b.contains('indusind')) {
      return IndianBank.indusInd;
    }
    if (s.contains('IDFC') || b.contains('idfc')) {
      return IndianBank.idfcFirst;
    }
    if (s.contains('RBL') || b.contains('rbl bank')) {
      return IndianBank.rbl;
    }
    if (s.contains('YESBK') || b.contains('yes bank')) {
      return IndianBank.yesBank;
    }
    if (s.contains('AUBANK') || b.contains('au small')) {
      return IndianBank.auSmallFinance;
    }
    if (s.contains('FEDBK') || b.contains('federal bank')) {
      return IndianBank.federal;
    }
    if (s.contains('BOBCRD') ||
        s.contains('BARB') ||
        b.contains('bank of baroda')) {
      return IndianBank.bob;
    }
    if (s.contains('PNBCRD') || b.contains('punjab national')) {
      return IndianBank.pnb;
    }
    if (s.contains('CANARA') || b.contains('canara bank')) {
      return IndianBank.canara;
    }
    if (s.contains('UNIONB') || b.contains('union bank of india')) {
      return IndianBank.unionBank;
    }
    if (s.contains('BOI') || b.contains('bank of india')) {
      return IndianBank.bankOfIndia;
    }
    if (s.contains('CENTBK') || b.contains('central bank of india')) {
      return IndianBank.centralBank;
    }
    if (s.contains('INDIANB') || b.contains('indian bank')) {
      return IndianBank.indianBank;
    }
    if (s.contains('IOB') || b.contains('indian overseas')) {
      return IndianBank.indianOverseasBank;
    }
    if (s.contains('UCOBK') || b.contains('uco bank')) {
      return IndianBank.ucoBank;
    }
    if (s.contains('MAHABK') || b.contains('bank of maharashtra')) {
      return IndianBank.bankOfMaharashtra;
    }
    if (s.contains('PSB') || b.contains('punjab & sind')) {
      return IndianBank.punjabAndSindBank;
    }
    if (s.contains('IDBI') || b.contains('idbi bank')) {
      return IndianBank.idbi;
    }
    if (s.contains('CUB') || b.contains('city union bank')) {
      return IndianBank.cityUnionBank;
    }
    if (s.contains('SIB') || b.contains('south indian bank')) {
      return IndianBank.southIndianBank;
    }
    if (s.contains('KVB') || b.contains('karur vysya')) {
      return IndianBank.karurVysyaBank;
    }
    if (s.contains('DCB') || b.contains('dcb bank')) {
      return IndianBank.dcb;
    }
    if (s.contains('CSB') || b.contains('csb bank')) {
      return IndianBank.csb;
    }
    if (s.contains('BANDHAN') || b.contains('bandhan bank')) {
      return IndianBank.bandhan;
    }
    if (s.contains('DBS') || b.contains('dbs bank')) {
      return IndianBank.dbs;
    }
    if (s.contains('SCB') || b.contains('standard chartered')) {
      return IndianBank.standardChartered;
    }
    if (s.contains('HSBC') || b.contains('hsbc')) {
      return IndianBank.hsbc;
    }
    if (s.contains('CITI') || b.contains('citibank')) {
      return IndianBank.citibank;
    }
    if (s.contains('AMEX') || b.contains('american express')) {
      return IndianBank.americanExpress;
    }
    if (s.contains('SBM') || b.contains('sbm bank')) {
      return IndianBank.sbm;
    }
    if (s.contains('EQUITAS') || b.contains('equitas')) {
      return IndianBank.equitas;
    }
    if (s.contains('UJJIVAN') || b.contains('ujjivan')) {
      return IndianBank.ujjivan;
    }
    if (s.contains('JANA') || b.contains('jana small finance')) {
      return IndianBank.jana;
    }
    if (s.contains('ESAF') || b.contains('esaf')) {
      return IndianBank.esaf;
    }
    if (s.contains('SURYODAY') || b.contains('suryoday')) {
      return IndianBank.suryoday;
    }
    if (s.contains('UTKARSH') || b.contains('utkarsh')) {
      return IndianBank.utkarsh;
    }
    if (s.contains('CAPITAL') || b.contains('capital small finance')) {
      return IndianBank.capitalSmallFinance;
    }
    if (s.contains('NESFB') || b.contains('north east small finance')) {
      return IndianBank.northEastSmallFinance;
    }
    if (s.contains('UNITY') || b.contains('unity small finance')) {
      return IndianBank.unitySmallFinance;
    }
    if (s.contains('SHIVALIK') || b.contains('shivalik')) {
      return IndianBank.shivalikSmallFinance;
    }
    return null;
  }

  /// Extracts last 4 digits of the credit card.
  static String? detectLast4(String body) {
    final match = _lastFourRegex.firstMatch(body);
    return match?.group(1);
  }

  /// Detects card network (RuPay, Mastercard, Amex, Diners, Visa).
  static CardSupplier detectBrand(String body) {
    final lower = body.toLowerCase();
    if (lower.contains('rupay') || lower.contains('upi')) {
      return CardSupplier.rupay;
    }
    if (lower.contains('mastercard') || lower.contains('master card')) {
      return CardSupplier.mastercard;
    }
    if (lower.contains('amex') || lower.contains('american express')) {
      return CardSupplier.amex;
    }
    if (lower.contains('diners')) {
      return CardSupplier.diners;
    }
    return CardSupplier.visa;
  }

  /// Computes a unique fingerprint to prevent importing duplicate messages.
  static String computeMessageFingerprint(
    String body,
    String sender,
    DateTime date,
  ) {
    final amountMatch = _amountRegex.firstMatch(body);
    final amount = (amountMatch?.group(1) ?? amountMatch?.group(2) ?? '')
        .replaceAll(',', '');
    final last4 = detectLast4(body) ?? '';
    final dateKey = '${date.year}-${date.month}-${date.day}';
    final normalized = body
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
        .toLowerCase();
    final sample = normalized.length > 25
        ? normalized.substring(0, 25)
        : normalized;
    return '${sender.toUpperCase()}_${amount}_${last4}_${dateKey}_$sample';
  }

  /// First-time auto card detection & sync:
  /// Reads inbox, filters credit card payments ONLY, drops duplicates and bill reminders,
  /// auto-adds detected cards with `isNeedsCompletion: true`, and extracts transactions.
  Future<FirstTimeSetupResult> autoDetectCardsAndSync({
    required UserProfileModel userProfile,
    required List<CreditCardModel> currentCards,
  }) async {
    final now = DateTime.now();
    final oneMonthAgo = now.subtract(const Duration(days: 30));

    final rawMessages = <SmsMessage>[];
    bool readFromNativeSms = false;

    try {
      final nativeMsgs = await _smsPlatform.readMessages(
        from: oneMonthAgo,
        to: now,
        limit: 500,
      );
      if (nativeMsgs.isNotEmpty) {
        rawMessages.addAll(nativeMsgs);
        readFromNativeSms = true;
      }
    } catch (_) {}

    final seenMessageIds = <String>{};
    final seenFingerprints = <String>{};
    int duplicatesIgnored = 0;
    int billRemindersIgnored = 0;
    final validMessages = <SmsMessage>[];

    for (final msg in rawMessages) {
      // 1. Discard bill payment reminders ("bill payment reminder no need to read that")
      if (isBillPaymentReminder(msg.body)) {
        billRemindersIgnored++;
        continue;
      }

      // 2. Strictly filter for credit card payments ONLY
      if (!isCreditCardPaymentMessage(msg.body, sender: msg.sender)) {
        continue;
      }

      // 3. Deduplicate messages ("also check for duplicate msg")
      if (msg.id.isNotEmpty && seenMessageIds.contains(msg.id)) {
        duplicatesIgnored++;
        continue;
      }

      final fp = computeMessageFingerprint(
        msg.body,
        msg.sender,
        msg.receivedAt,
      );
      if (seenFingerprints.contains(fp)) {
        duplicatesIgnored++;
        continue;
      }

      seenMessageIds.add(msg.id);
      seenFingerprints.add(fp);
      validMessages.add(msg);
    }

    // Group valid messages by card
    final detectedCardMap = <String, _CardAggregation>{};
    final parsedTransactions = <TransactionModel>[];
    const parser = GenericSmsParser();

    for (final msg in validMessages) {
      final bank = detectBank(msg.sender, msg.body) ?? IndianBank.other;
      final brand = detectBrand(msg.body);
      final parsedList = parser.parse(msg, bankHint: bank.displayName);

      String? last4 = detectLast4(msg.body);
      for (final parsed in parsedList) {
        last4 ??= parsed.cardLastFour;
      }
      if (last4 == null) continue;
      final resolvedLast4 = last4;

      final key = '${bank.name}_$resolvedLast4';
      for (final parsed in parsedList) {
        final amountRupees = parsed.amountMinor / 100.0;
        final ref =
            parsed.sourceReference?.replaceAll(':', '-') ??
            '${DateTime.now().millisecondsSinceEpoch}';

        final agg = detectedCardMap.putIfAbsent(
          key,
          () =>
              _CardAggregation(bank: bank, last4: resolvedLast4, brand: brand),
        );
        if (parsed.transactionType.isDebit) {
          agg.totalSpent += amountRupees;
        }
        agg.txCount++;

        parsedTransactions.add(
          TransactionModel(
            id: 'tx-auto-$ref',
            title: parsed.description,
            category: _categorize(parsed.description),
            amount: amountRupees,
            type: parsed.transactionType.isDebit
                ? TransactionType.expense
                : TransactionType.income,
            date: _formatShortDate(parsed.transactionDate),
            time: '14:30',
            cardLast4: resolvedLast4,
            cardBank: bank,
            cardBrand: brand,
            merchant: parsed.merchant ?? parsed.description,
            referenceId: 'SMS-$ref',
            status: TransactionStatus.completed,
          ),
        );
      }
    }

    // Build newly detected CreditCardModel objects. The user completes the bank,
    // variant, network and limit in the completion dialog; nothing is invented
    // here beyond the details actually seen in the SMS.
    final addedCards = <CreditCardModel>[];
    for (final agg in detectedCardMap.values) {
      final alreadyExists = currentCards.any(
        (c) => c.bankName == agg.bank && c.lastFour == agg.last4,
      );
      if (!alreadyExists) {
        final newCard = CreditCardModel(
          id: 'card-detected-${agg.bank.name}-${agg.last4}',
          bankName: agg.bank,
          holderName: userProfile.name.trim().isNotEmpty
              ? userProfile.name.toUpperCase()
              : 'CARDHOLDER',
          maskedNumber: '•••• ${agg.last4}',
          expiry: '',
          balance: agg.totalSpent,
          limit: 0,
          brand: agg.brand,
          cardTier: 'Credit Card',
          dailyLimit: 0,
          isNeedsCompletion: true,
        );
        addedCards.add(newCard);
      }
    }

    return FirstTimeSetupResult(
      addedCards: addedCards,
      transactions: parsedTransactions,
      totalScanned: rawMessages.length,
      validCreditCardPaymentCount: validMessages.length,
      duplicatesIgnored: duplicatesIgnored,
      billRemindersIgnored: billRemindersIgnored,
      readFromNativeSms: readFromNativeSms,
    );
  }

  static String _categorize(String desc) {
    final lower = desc.toLowerCase();
    if (lower.contains('swiggy') ||
        lower.contains('zomato') ||
        lower.contains('starbucks') ||
        lower.contains('food')) {
      return 'Food & Dining';
    }
    if (lower.contains('amazon') ||
        lower.contains('flipkart') ||
        lower.contains('myntra')) {
      return 'Shopping';
    }
    if (lower.contains('uber') ||
        lower.contains('ola') ||
        lower.contains('metro')) {
      return 'Transport';
    }
    if (lower.contains('apollo') ||
        lower.contains('pharmacy') ||
        lower.contains('hospital')) {
      return 'Health';
    }
    if (lower.contains('bookmyshow') ||
        lower.contains('netflix') ||
        lower.contains('pvr')) {
      return 'Entertainment';
    }
    return 'General';
  }

  static String _formatShortDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  static String formatMonthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final m = ((month - 1) % 12) + 1;
    return months[m - 1];
  }
}
