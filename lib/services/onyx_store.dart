import 'dart:convert';

import '../core/files/app_files.dart';
import '../data/database/database_factory.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/repositories/settings_repository.dart';
import '../integrations/platform/secure_key_store.dart';
import '../models/financial_models.dart';

/// A durable copy of the Onyx dashboard.
///
/// The values are written to the app's SQLCipher-encrypted database. Card
/// numbers remain masked and no CVV, PIN, or full card number is ever stored.
class OnyxSnapshot {
  static const int schemaVersion = 1;

  final List<CreditCardModel> cards;
  final List<TransactionModel> transactions;
  final UserProfileModel profile;
  final bool isDarkMode;

  const OnyxSnapshot({
    this.cards = const <CreditCardModel>[],
    this.transactions = const <TransactionModel>[],
    this.profile = const UserProfileModel(name: ''),
    this.isDarkMode = true,
  });

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'version': schemaVersion,
      'cards': cards.map(_cardToJson).toList(growable: false),
      'transactions': transactions
          .map(_transactionToJson)
          .toList(growable: false),
      'profile': _profileToJson(profile),
      'isDarkMode': isDarkMode,
    };
  }

  factory OnyxSnapshot.fromJson(Map<String, dynamic> json) {
    final version = _asInt(json['version']) ?? schemaVersion;
    if (version > schemaVersion) {
      throw const FormatException('Unsupported Onyx snapshot version');
    }

    return OnyxSnapshot(
      cards: _cardsFromJson(json['cards']),
      transactions: _transactionsFromJson(json['transactions']),
      profile: _profileFromJson(json['profile']),
      isDarkMode: json['isDarkMode'] as bool? ?? true,
    );
  }
}

/// Reads and writes the dashboard through the encrypted application database.
///
/// The database is opened lazily on first use. Tests can inject a settings
/// loader so the persistence layer can be exercised without platform channels.
class OnyxStore {
  OnyxStore({Future<SettingsRepository> Function()? settingsLoader})
    : _settingsLoader = settingsLoader ?? _openSettings;

  static const String _dashboardKey = 'onyx.dashboard.v1';
  static const String _permissionsKey = 'onyx.permissions_onboarded.v1';

  final Future<SettingsRepository> Function() _settingsLoader;
  Future<SettingsRepository>? _settingsFuture;
  Future<void> _writeQueue = Future<void>.value();

  Future<SettingsRepository> _settings() {
    return _settingsFuture ??= _settingsLoader();
  }

  Future<OnyxSnapshot?> load() async {
    final settings = await _settings();
    final raw = await settings.getPlain(_dashboardKey);
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return OnyxSnapshot.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      // A corrupt snapshot must not prevent the app from opening. The next
      // successful save replaces it with a fresh snapshot.
      return null;
    }
  }

  Future<bool> hasCompletedPermissionOnboarding() async {
    final settings = await _settings();
    return await settings.getPlain(_permissionsKey) == '1';
  }

  Future<void> markPermissionOnboardingComplete() async {
    final settings = await _settings();
    await settings.setPlain(_permissionsKey, '1');
  }

  Future<void> save(OnyxSnapshot snapshot) {
    final encoded = jsonEncode(snapshot.toJson());
    final next = _writeQueue.then((_) async {
      final settings = await _settings();
      await settings.setPlain(_dashboardKey, encoded);
    });
    // Keep later writes alive even if one write fails. The caller still gets
    // the original error so it can decide whether to surface it.
    _writeQueue = next.catchError((Object _) {});
    return next;
  }

  static Future<SettingsRepository> _openSettings() async {
    final file = await appDatabaseFile();
    final database = await openEncryptedDatabase(
      file: file,
      keyProvider: const SecureKeyStore(),
    );
    return SettingsRepositoryImpl(database);
  }
}

Map<String, Object?> _cardToJson(CreditCardModel card) {
  return <String, Object?>{
    'id': card.id,
    'bank': card.bankName.name,
    'holderName': card.holderName,
    'maskedNumber': card.maskedNumber,
    'expiry': card.expiry,
    'balance': card.balance,
    'limit': card.limit,
    'brand': card.brand.name,
    'cardTier': card.cardTier,
    'cardColorValue': card.cardColorValue,
    'isLightCard': card.isLightCard,
    'isFrozen': card.isFrozen,
    'dailyLimit': card.dailyLimit,
    'currentDailySpent': card.currentDailySpent,
    'contactlessEnabled': card.contactlessEnabled,
    'onlinePaymentsEnabled': card.onlinePaymentsEnabled,
    'internationalEnabled': card.internationalEnabled,
    'cardImagePath': card.cardImagePath,
    'cardImageUrl': card.cardImageUrl,
    'isNeedsCompletion': card.isNeedsCompletion,
  };
}

CreditCardModel _cardFromJson(Map<String, dynamic> json) {
  return CreditCardModel(
    id: json['id'] as String? ?? '',
    bankName: _enumValue(
      IndianBank.values,
      json['bank'],
      fallback: IndianBank.other,
    ),
    holderName: json['holderName'] as String? ?? '',
    maskedNumber: json['maskedNumber'] as String? ?? '',
    expiry: json['expiry'] as String? ?? '',
    balance: _asDouble(json['balance']),
    limit: _asDouble(json['limit']),
    brand: _enumValue(
      CardSupplier.values,
      json['brand'],
      fallback: CardSupplier.visa,
    ),
    cardTier: json['cardTier'] as String? ?? '',
    cardColorValue: _asInt(json['cardColorValue']),
    isLightCard: json['isLightCard'] as bool?,
    isFrozen: json['isFrozen'] as bool? ?? false,
    dailyLimit: _asDouble(json['dailyLimit']),
    currentDailySpent: _asDouble(json['currentDailySpent']),
    contactlessEnabled: json['contactlessEnabled'] as bool? ?? true,
    onlinePaymentsEnabled: json['onlinePaymentsEnabled'] as bool? ?? true,
    internationalEnabled: json['internationalEnabled'] as bool? ?? true,
    cardImagePath: json['cardImagePath'] as String?,
    cardImageUrl: json['cardImageUrl'] as String?,
    isNeedsCompletion: json['isNeedsCompletion'] as bool? ?? false,
  );
}

Map<String, Object?> _transactionToJson(TransactionModel transaction) {
  return <String, Object?>{
    'id': transaction.id,
    'title': transaction.title,
    'category': transaction.category,
    'amount': transaction.amount,
    'type': transaction.type.name,
    'date': transaction.date,
    'time': transaction.time,
    'cardLast4': transaction.cardLast4,
    'cardBank': transaction.cardBank?.name,
    'cardBrand': transaction.cardBrand?.name,
    'merchant': transaction.merchant,
    'referenceId': transaction.referenceId,
    'status': transaction.status.name,
    'isUpi': transaction.isUpi,
  };
}

TransactionModel _transactionFromJson(Map<String, dynamic> json) {
  return TransactionModel(
    id: json['id'] as String? ?? '',
    title: json['title'] as String? ?? '',
    category: json['category'] as String? ?? 'General',
    amount: _asDouble(json['amount']),
    type: _enumValue(
      TransactionType.values,
      json['type'],
      fallback: TransactionType.expense,
    ),
    date: json['date'] as String? ?? '',
    time: json['time'] as String? ?? '',
    cardLast4: json['cardLast4'] as String? ?? '',
    cardBank: _enumOrNull(IndianBank.values, json['cardBank']),
    cardBrand: _enumOrNull(CardSupplier.values, json['cardBrand']),
    merchant: json['merchant'] as String? ?? '',
    referenceId: json['referenceId'] as String? ?? '',
    status: _enumValue(
      TransactionStatus.values,
      json['status'],
      fallback: TransactionStatus.completed,
    ),
    isUpi: json['isUpi'] as bool? ?? false,
  );
}

Map<String, Object?> _profileToJson(UserProfileModel profile) {
  return <String, Object?>{
    'name': profile.name,
    'email': profile.email,
    'photoUrl': profile.photoUrl,
    'isEmailConnected': profile.isEmailConnected,
    'isSmsGranted': profile.isSmsGranted,
    'isNotificationsGranted': profile.isNotificationsGranted,
    'lastSyncedAt': profile.lastSyncedAt?.toIso8601String(),
  };
}

UserProfileModel _profileFromJson(Object? raw) {
  if (raw is! Map) return const UserProfileModel(name: '');
  final json = Map<String, dynamic>.from(raw);
  final lastSynced = json['lastSyncedAt'];
  return UserProfileModel(
    name: json['name'] as String? ?? '',
    email: json['email'] as String?,
    photoUrl: json['photoUrl'] as String?,
    isEmailConnected: json['isEmailConnected'] as bool? ?? false,
    isSmsGranted: json['isSmsGranted'] as bool? ?? false,
    isNotificationsGranted: json['isNotificationsGranted'] as bool? ?? false,
    lastSyncedAt: lastSynced is String ? DateTime.tryParse(lastSynced) : null,
  );
}

List<CreditCardModel> _cardsFromJson(Object? raw) {
  if (raw is! List) return const <CreditCardModel>[];
  return raw
      .whereType<Map<Object?, Object?>>()
      .map((item) => _cardFromJson(Map<String, dynamic>.from(item)))
      .where((card) => card.id.isNotEmpty)
      .toList(growable: false);
}

List<TransactionModel> _transactionsFromJson(Object? raw) {
  if (raw is! List) return const <TransactionModel>[];
  return raw
      .whereType<Map<Object?, Object?>>()
      .map((item) => _transactionFromJson(Map<String, dynamic>.from(item)))
      .where((transaction) => transaction.id.isNotEmpty)
      .toList(growable: false);
}

T _enumValue<T extends Enum>(
  List<T> values,
  Object? raw, {
  required T fallback,
}) {
  if (raw is String) {
    for (final value in values) {
      if (value.name == raw) return value;
    }
  }
  return fallback;
}

T? _enumOrNull<T extends Enum>(List<T> values, Object? raw) {
  if (raw is String) {
    for (final value in values) {
      if (value.name == raw) return value;
    }
  }
  return null;
}

double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
