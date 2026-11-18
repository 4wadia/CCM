enum ScreenId { home, cards, profile }

enum IndianBank {
  hdfc('HDFC Bank'),
  icici('ICICI Bank'),
  sbi('SBI Card'),
  axis('Axis Bank'),
  kotak('Kotak Mahindra Bank'),
  indusInd('IndusInd Bank'),
  bob('Bank of Baroda'),
  pnb('Punjab National Bank'),
  idfcFirst('IDFC FIRST Bank'),
  rbl('RBL Bank'),
  yesBank('Yes Bank'),
  auSmallFinance('AU Small Finance Bank'),
  federal('Federal Bank');

  final String displayName;
  const IndianBank(this.displayName);

  String get shortName => displayName
      .replaceAll(' Mahindra Bank', '')
      .replaceAll(' Small Finance Bank', '')
      .replaceAll(' Bank', '')
      .replaceAll(' Card', '');
}

enum CardSupplier {
  rupay('RuPay'),
  visa('VISA'),
  mastercard('Mastercard'),
  amex('AMEX'),
  diners('Diners');

  final String label;
  const CardSupplier(this.label);

  String get tag => switch (this) {
    CardSupplier.visa => 'VISA',
    CardSupplier.rupay => 'RUPAY',
    CardSupplier.mastercard => 'MC',
    CardSupplier.amex => 'AMEX',
    CardSupplier.diners => 'DINERS',
  };
}

enum TransactionType { expense, income }

enum TransactionStatus { completed, pending }

class TransactionModel {
  final String id;
  final String title;
  final String category;
  final double amount;
  final TransactionType type;
  final String date;
  final String time;
  final String cardLast4;
  final IndianBank? cardBank;
  final CardSupplier? cardBrand;
  final String merchant;
  final String referenceId;
  final TransactionStatus status;
  final bool isUpi;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.date,
    required this.time,
    required this.cardLast4,
    this.cardBank,
    this.cardBrand,
    required this.merchant,
    required this.referenceId,
    this.status = TransactionStatus.completed,
    this.isUpi = false,
  });
}

class CreditCardModel {
  final String id;
  final IndianBank bankName;
  final String holderName;
  final String cardNumber;
  final String maskedNumber;
  final String expiry;
  final String cvv;
  final double balance;
  final double limit;
  final CardSupplier brand;
  final String cardTier;
  final int? cardColorValue;
  final bool? isLightCard;
  final bool isFrozen;
  final double dailyLimit;
  final double currentDailySpent;
  final bool contactlessEnabled;
  final bool onlinePaymentsEnabled;
  final bool internationalEnabled;
  final String? cardImagePath;
  final String? cardImageUrl;
  final bool isNeedsCompletion;

  const CreditCardModel({
    required this.id,
    required this.bankName,
    required this.holderName,
    required this.cardNumber,
    required this.maskedNumber,
    required this.expiry,
    required this.cvv,
    required this.balance,
    required this.limit,
    required this.brand,
    required this.cardTier,
    this.cardColorValue,
    this.isLightCard,
    this.isFrozen = false,
    required this.dailyLimit,
    this.currentDailySpent = 0,
    this.contactlessEnabled = true,
    this.onlinePaymentsEnabled = true,
    this.internationalEnabled = true,
    this.cardImagePath,
    this.cardImageUrl,
    this.isNeedsCompletion = false,
  });

  CreditCardModel copyWith({
    String? holderName,
    String? cardNumber,
    String? maskedNumber,
    String? expiry,
    String? cvv,
    double? balance,
    double? limit,
    CardSupplier? brand,
    String? cardTier,
    int? cardColorValue,
    bool? isLightCard,
    bool? isFrozen,
    double? dailyLimit,
    bool? contactlessEnabled,
    bool? onlinePaymentsEnabled,
    bool? internationalEnabled,
    String? cardImagePath,
    String? cardImageUrl,
    bool? isNeedsCompletion,
  }) {
    return CreditCardModel(
      id: id,
      bankName: bankName,
      holderName: holderName ?? this.holderName,
      cardNumber: cardNumber ?? this.cardNumber,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      expiry: expiry ?? this.expiry,
      cvv: cvv ?? this.cvv,
      balance: balance ?? this.balance,
      limit: limit ?? this.limit,
      brand: brand ?? this.brand,
      cardTier: cardTier ?? this.cardTier,
      cardColorValue: cardColorValue ?? this.cardColorValue,
      isLightCard: isLightCard ?? this.isLightCard,
      isFrozen: isFrozen ?? this.isFrozen,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      currentDailySpent: currentDailySpent,
      contactlessEnabled: contactlessEnabled ?? this.contactlessEnabled,
      onlinePaymentsEnabled:
          onlinePaymentsEnabled ?? this.onlinePaymentsEnabled,
      internationalEnabled: internationalEnabled ?? this.internationalEnabled,
      cardImagePath: cardImagePath ?? this.cardImagePath,
      cardImageUrl: cardImageUrl ?? this.cardImageUrl,
      isNeedsCompletion: isNeedsCompletion ?? this.isNeedsCompletion,
    );
  }
}

class UserProfileModel {
  final String name;
  final String? email;
  final String? photoUrl;
  final bool isEmailConnected;
  final bool isSmsGranted;
  final bool isNotificationsGranted;
  final DateTime? lastSyncedAt;

  const UserProfileModel({
    required this.name,
    this.email,
    this.photoUrl,
    this.isEmailConnected = false,
    this.isSmsGranted = false,
    this.isNotificationsGranted = false,
    this.lastSyncedAt,
  });

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    bool? isEmailConnected,
    bool? isSmsGranted,
    bool? isNotificationsGranted,
    DateTime? lastSyncedAt,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailConnected: isEmailConnected ?? this.isEmailConnected,
      isSmsGranted: isSmsGranted ?? this.isSmsGranted,
      isNotificationsGranted:
          isNotificationsGranted ?? this.isNotificationsGranted,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
