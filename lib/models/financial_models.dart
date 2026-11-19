enum ScreenId { home, cards, profile }

/// Curated list of banks and card issuers that offer credit cards in India.
///
/// Product names and issuers change regularly, so the list is intentionally
/// maintained as a catalogue rather than claimed to be exhaustive. The
/// [other] entry keeps the add/complete flow usable for a newly launched bank
/// or a co-branded issuer that is not listed yet.
enum IndianBank {
  // Major private and public-sector issuers.
  hdfc('HDFC Bank'),
  icici('ICICI Bank'),
  sbi('SBI Card'),
  axis('Axis Bank'),
  kotak('Kotak Mahindra Bank'),
  indusInd('IndusInd Bank'),
  idfcFirst('IDFC FIRST Bank'),
  rbl('RBL Bank'),
  yesBank('Yes Bank'),
  federal('Federal Bank'),
  auSmallFinance('AU Small Finance Bank'),
  bob('Bank of Baroda'),
  pnb('Punjab National Bank'),
  canara('Canara Bank'),
  unionBank('Union Bank of India'),
  bankOfIndia('Bank of India'),
  centralBank('Central Bank of India'),
  indianBank('Indian Bank'),
  indianOverseasBank('Indian Overseas Bank'),
  ucoBank('UCO Bank'),
  bankOfMaharashtra('Bank of Maharashtra'),
  punjabAndSindBank('Punjab & Sind Bank'),
  idbi('IDBI Bank'),
  cityUnionBank('City Union Bank'),
  southIndianBank('South Indian Bank'),
  karurVysyaBank('Karur Vysya Bank'),
  dcb('DCB Bank'),
  csb('CSB Bank'),
  bandhan('Bandhan Bank'),
  dbs('DBS Bank India'),
  standardChartered('Standard Chartered Bank'),
  hsbc('HSBC India'),
  citibank('Citibank India'),
  americanExpress('American Express'),
  sbm('SBM Bank India'),

  // Small finance banks.
  equitas('Equitas Small Finance Bank'),
  ujjivan('Ujjivan Small Finance Bank'),
  jana('Jana Small Finance Bank'),
  esaf('ESAF Small Finance Bank'),
  suryoday('Suryoday Small Finance Bank'),
  utkarsh('Utkarsh Small Finance Bank'),
  capitalSmallFinance('Capital Small Finance Bank'),
  northEastSmallFinance('North East Small Finance Bank'),
  slice('Slice Small Finance Bank'),
  unitySmallFinance('Unity Small Finance Bank'),
  shivalikSmallFinance('Shivalik Small Finance Bank'),

  /// Fallback for a bank or co-branded issuer that is not in the catalogue.
  other('Other / not listed');

  final String displayName;
  const IndianBank(this.displayName);

  String get shortName => switch (this) {
    IndianBank.hdfc => 'HDFC',
    IndianBank.icici => 'ICICI',
    IndianBank.sbi => 'SBI',
    IndianBank.axis => 'Axis',
    IndianBank.kotak => 'Kotak',
    IndianBank.indusInd => 'IndusInd',
    IndianBank.idfcFirst => 'IDFC FIRST',
    IndianBank.rbl => 'RBL',
    IndianBank.yesBank => 'YES',
    IndianBank.federal => 'Federal',
    IndianBank.auSmallFinance => 'AU',
    IndianBank.bob => 'BoB',
    IndianBank.pnb => 'PNB',
    IndianBank.canara => 'Canara',
    IndianBank.unionBank => 'Union',
    IndianBank.bankOfIndia => 'BOI',
    IndianBank.centralBank => 'Central',
    IndianBank.indianBank => 'Indian Bank',
    IndianBank.indianOverseasBank => 'IOB',
    IndianBank.ucoBank => 'UCO',
    IndianBank.bankOfMaharashtra => 'MahaBank',
    IndianBank.punjabAndSindBank => 'PSB',
    IndianBank.idbi => 'IDBI',
    IndianBank.cityUnionBank => 'CUB',
    IndianBank.southIndianBank => 'SIB',
    IndianBank.karurVysyaBank => 'KVB',
    IndianBank.dcb => 'DCB',
    IndianBank.csb => 'CSB',
    IndianBank.bandhan => 'Bandhan',
    IndianBank.dbs => 'DBS',
    IndianBank.standardChartered => 'StanChart',
    IndianBank.hsbc => 'HSBC',
    IndianBank.citibank => 'Citi',
    IndianBank.americanExpress => 'Amex',
    IndianBank.sbm => 'SBM',
    IndianBank.equitas => 'Equitas',
    IndianBank.ujjivan => 'Ujjivan',
    IndianBank.jana => 'Jana',
    IndianBank.esaf => 'ESAF',
    IndianBank.suryoday => 'Suryoday',
    IndianBank.utkarsh => 'Utkarsh',
    IndianBank.capitalSmallFinance => 'Capital',
    IndianBank.northEastSmallFinance => 'NESFB',
    IndianBank.slice => 'Slice',
    IndianBank.unitySmallFinance => 'Unity',
    IndianBank.shivalikSmallFinance => 'Shivalik',
    IndianBank.other => 'Other',
  };
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

  /// Only the masked form is stored. Full card numbers must never be persisted.
  final String maskedNumber;

  /// Optional expiry exactly as printed on the card. The card security code is
  /// deliberately not part of the model.
  final String expiry;

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
    required this.maskedNumber,
    this.expiry = '',
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

  String get lastFour {
    final digits = maskedNumber.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 4
        ? digits.substring(digits.length - 4)
        : digits.padLeft(4, '•');
  }

  CreditCardModel copyWith({
    IndianBank? bankName,
    String? holderName,
    String? maskedNumber,
    String? expiry,
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
      bankName: bankName ?? this.bankName,
      holderName: holderName ?? this.holderName,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      expiry: expiry ?? this.expiry,
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
