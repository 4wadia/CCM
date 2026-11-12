// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BanksTable extends Banks with TableInfo<$BanksTable, BankRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BanksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    countryCode,
    region,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'banks';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countryCodeMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    } else if (isInserting) {
      context.missing(_regionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BanksTable createAlias(String alias) {
    return $BanksTable(attachedDatabase, alias);
  }
}

class BankRow extends DataClass implements Insertable<BankRow> {
  final String id;
  final String displayName;
  final String countryCode;
  final String region;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BankRow({
    required this.id,
    required this.displayName,
    required this.countryCode,
    required this.region,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['country_code'] = Variable<String>(countryCode);
    map['region'] = Variable<String>(region);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BanksCompanion toCompanion(bool nullToAbsent) {
    return BanksCompanion(
      id: Value(id),
      displayName: Value(displayName),
      countryCode: Value(countryCode),
      region: Value(region),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BankRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankRow(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      countryCode: serializer.fromJson<String>(json['countryCode']),
      region: serializer.fromJson<String>(json['region']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'countryCode': serializer.toJson<String>(countryCode),
      'region': serializer.toJson<String>(region),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BankRow copyWith({
    String? id,
    String? displayName,
    String? countryCode,
    String? region,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BankRow(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    countryCode: countryCode ?? this.countryCode,
    region: region ?? this.region,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BankRow copyWithCompanion(BanksCompanion data) {
    return BankRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
      region: data.region.present ? data.region.value : this.region,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('countryCode: $countryCode, ')
          ..write('region: $region, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, displayName, countryCode, region, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.countryCode == this.countryCode &&
          other.region == this.region &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BanksCompanion extends UpdateCompanion<BankRow> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> countryCode;
  final Value<String> region;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BanksCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.region = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BanksCompanion.insert({
    required String id,
    required String displayName,
    required String countryCode,
    required String region,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       countryCode = Value(countryCode),
       region = Value(region),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BankRow> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? countryCode,
    Expression<String>? region,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (countryCode != null) 'country_code': countryCode,
      if (region != null) 'region': region,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BanksCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? countryCode,
    Value<String>? region,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BanksCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      countryCode: countryCode ?? this.countryCode,
      region: region ?? this.region,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BanksCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('countryCode: $countryCode, ')
          ..write('region: $region, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditCardsTable extends CreditCards
    with TableInfo<$CreditCardsTable, CreditCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
    'bank_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES banks (id)',
    ),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardholderNameMeta = const VerificationMeta(
    'cardholderName',
  );
  @override
  late final GeneratedColumn<String> cardholderName = GeneratedColumn<String>(
    'cardholder_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _networkMeta = const VerificationMeta(
    'network',
  );
  @override
  late final GeneratedColumn<String> network = GeneratedColumn<String>(
    'network',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastFourMeta = const VerificationMeta(
    'lastFour',
  );
  @override
  late final GeneratedColumn<String> lastFour = GeneratedColumn<String>(
    'last_four',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 4,
      maxTextLength: 4,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditLimitMinorMeta = const VerificationMeta(
    'creditLimitMinor',
  );
  @override
  late final GeneratedColumn<int> creditLimitMinor = GeneratedColumn<int>(
    'credit_limit_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentOutstandingMinorMeta =
      const VerificationMeta('currentOutstandingMinor');
  @override
  late final GeneratedColumn<int> currentOutstandingMinor =
      GeneratedColumn<int>(
        'current_outstanding_minor',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statementDayMeta = const VerificationMeta(
    'statementDay',
  );
  @override
  late final GeneratedColumn<int> statementDay = GeneratedColumn<int>(
    'statement_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billingCycleStartMeta = const VerificationMeta(
    'billingCycleStart',
  );
  @override
  late final GeneratedColumn<DateTime> billingCycleStart =
      GeneratedColumn<DateTime>(
        'billing_cycle_start',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _billingCycleEndMeta = const VerificationMeta(
    'billingCycleEnd',
  );
  @override
  late final GeneratedColumn<DateTime> billingCycleEnd =
      GeneratedColumn<DateTime>(
        'billing_cycle_end',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _rewardProgrammeMeta = const VerificationMeta(
    'rewardProgramme',
  );
  @override
  late final GeneratedColumn<String> rewardProgramme = GeneratedColumn<String>(
    'reward_programme',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bankId,
    displayName,
    cardholderName,
    network,
    lastFour,
    creditLimitMinor,
    currentOutstandingMinor,
    currencyCode,
    statementDay,
    dueDay,
    billingCycleStart,
    billingCycleEnd,
    status,
    rewardProgramme,
    colorValue,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditCardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bank_id')) {
      context.handle(
        _bankIdMeta,
        bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bankIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('cardholder_name')) {
      context.handle(
        _cardholderNameMeta,
        cardholderName.isAcceptableOrUnknown(
          data['cardholder_name']!,
          _cardholderNameMeta,
        ),
      );
    }
    if (data.containsKey('network')) {
      context.handle(
        _networkMeta,
        network.isAcceptableOrUnknown(data['network']!, _networkMeta),
      );
    } else if (isInserting) {
      context.missing(_networkMeta);
    }
    if (data.containsKey('last_four')) {
      context.handle(
        _lastFourMeta,
        lastFour.isAcceptableOrUnknown(data['last_four']!, _lastFourMeta),
      );
    } else if (isInserting) {
      context.missing(_lastFourMeta);
    }
    if (data.containsKey('credit_limit_minor')) {
      context.handle(
        _creditLimitMinorMeta,
        creditLimitMinor.isAcceptableOrUnknown(
          data['credit_limit_minor']!,
          _creditLimitMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditLimitMinorMeta);
    }
    if (data.containsKey('current_outstanding_minor')) {
      context.handle(
        _currentOutstandingMinorMeta,
        currentOutstandingMinor.isAcceptableOrUnknown(
          data['current_outstanding_minor']!,
          _currentOutstandingMinorMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('statement_day')) {
      context.handle(
        _statementDayMeta,
        statementDay.isAcceptableOrUnknown(
          data['statement_day']!,
          _statementDayMeta,
        ),
      );
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    }
    if (data.containsKey('billing_cycle_start')) {
      context.handle(
        _billingCycleStartMeta,
        billingCycleStart.isAcceptableOrUnknown(
          data['billing_cycle_start']!,
          _billingCycleStartMeta,
        ),
      );
    }
    if (data.containsKey('billing_cycle_end')) {
      context.handle(
        _billingCycleEndMeta,
        billingCycleEnd.isAcceptableOrUnknown(
          data['billing_cycle_end']!,
          _billingCycleEndMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reward_programme')) {
      context.handle(
        _rewardProgrammeMeta,
        rewardProgramme.isAcceptableOrUnknown(
          data['reward_programme']!,
          _rewardProgrammeMeta,
        ),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditCardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bankId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      cardholderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cardholder_name'],
      ),
      network: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network'],
      )!,
      lastFour: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_four'],
      )!,
      creditLimitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit_minor'],
      )!,
      currentOutstandingMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_outstanding_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      statementDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}statement_day'],
      ),
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      ),
      billingCycleStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}billing_cycle_start'],
      ),
      billingCycleEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}billing_cycle_end'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      rewardProgramme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_programme'],
      ),
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CreditCardsTable createAlias(String alias) {
    return $CreditCardsTable(attachedDatabase, alias);
  }
}

class CreditCardRow extends DataClass implements Insertable<CreditCardRow> {
  final String id;
  final String bankId;
  final String displayName;
  final String? cardholderName;
  final String network;
  final String lastFour;
  final int creditLimitMinor;

  /// Reconciled current balance in minor units. Added in schema v2.
  final int currentOutstandingMinor;
  final String currencyCode;
  final int? statementDay;
  final int? dueDay;
  final DateTime? billingCycleStart;
  final DateTime? billingCycleEnd;
  final String status;
  final String? rewardProgramme;
  final int? colorValue;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CreditCardRow({
    required this.id,
    required this.bankId,
    required this.displayName,
    this.cardholderName,
    required this.network,
    required this.lastFour,
    required this.creditLimitMinor,
    required this.currentOutstandingMinor,
    required this.currencyCode,
    this.statementDay,
    this.dueDay,
    this.billingCycleStart,
    this.billingCycleEnd,
    required this.status,
    this.rewardProgramme,
    this.colorValue,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bank_id'] = Variable<String>(bankId);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || cardholderName != null) {
      map['cardholder_name'] = Variable<String>(cardholderName);
    }
    map['network'] = Variable<String>(network);
    map['last_four'] = Variable<String>(lastFour);
    map['credit_limit_minor'] = Variable<int>(creditLimitMinor);
    map['current_outstanding_minor'] = Variable<int>(currentOutstandingMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || statementDay != null) {
      map['statement_day'] = Variable<int>(statementDay);
    }
    if (!nullToAbsent || dueDay != null) {
      map['due_day'] = Variable<int>(dueDay);
    }
    if (!nullToAbsent || billingCycleStart != null) {
      map['billing_cycle_start'] = Variable<DateTime>(billingCycleStart);
    }
    if (!nullToAbsent || billingCycleEnd != null) {
      map['billing_cycle_end'] = Variable<DateTime>(billingCycleEnd);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || rewardProgramme != null) {
      map['reward_programme'] = Variable<String>(rewardProgramme);
    }
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CreditCardsCompanion toCompanion(bool nullToAbsent) {
    return CreditCardsCompanion(
      id: Value(id),
      bankId: Value(bankId),
      displayName: Value(displayName),
      cardholderName: cardholderName == null && nullToAbsent
          ? const Value.absent()
          : Value(cardholderName),
      network: Value(network),
      lastFour: Value(lastFour),
      creditLimitMinor: Value(creditLimitMinor),
      currentOutstandingMinor: Value(currentOutstandingMinor),
      currencyCode: Value(currencyCode),
      statementDay: statementDay == null && nullToAbsent
          ? const Value.absent()
          : Value(statementDay),
      dueDay: dueDay == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDay),
      billingCycleStart: billingCycleStart == null && nullToAbsent
          ? const Value.absent()
          : Value(billingCycleStart),
      billingCycleEnd: billingCycleEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(billingCycleEnd),
      status: Value(status),
      rewardProgramme: rewardProgramme == null && nullToAbsent
          ? const Value.absent()
          : Value(rewardProgramme),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CreditCardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditCardRow(
      id: serializer.fromJson<String>(json['id']),
      bankId: serializer.fromJson<String>(json['bankId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      cardholderName: serializer.fromJson<String?>(json['cardholderName']),
      network: serializer.fromJson<String>(json['network']),
      lastFour: serializer.fromJson<String>(json['lastFour']),
      creditLimitMinor: serializer.fromJson<int>(json['creditLimitMinor']),
      currentOutstandingMinor: serializer.fromJson<int>(
        json['currentOutstandingMinor'],
      ),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      statementDay: serializer.fromJson<int?>(json['statementDay']),
      dueDay: serializer.fromJson<int?>(json['dueDay']),
      billingCycleStart: serializer.fromJson<DateTime?>(
        json['billingCycleStart'],
      ),
      billingCycleEnd: serializer.fromJson<DateTime?>(json['billingCycleEnd']),
      status: serializer.fromJson<String>(json['status']),
      rewardProgramme: serializer.fromJson<String?>(json['rewardProgramme']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bankId': serializer.toJson<String>(bankId),
      'displayName': serializer.toJson<String>(displayName),
      'cardholderName': serializer.toJson<String?>(cardholderName),
      'network': serializer.toJson<String>(network),
      'lastFour': serializer.toJson<String>(lastFour),
      'creditLimitMinor': serializer.toJson<int>(creditLimitMinor),
      'currentOutstandingMinor': serializer.toJson<int>(
        currentOutstandingMinor,
      ),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'statementDay': serializer.toJson<int?>(statementDay),
      'dueDay': serializer.toJson<int?>(dueDay),
      'billingCycleStart': serializer.toJson<DateTime?>(billingCycleStart),
      'billingCycleEnd': serializer.toJson<DateTime?>(billingCycleEnd),
      'status': serializer.toJson<String>(status),
      'rewardProgramme': serializer.toJson<String?>(rewardProgramme),
      'colorValue': serializer.toJson<int?>(colorValue),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CreditCardRow copyWith({
    String? id,
    String? bankId,
    String? displayName,
    Value<String?> cardholderName = const Value.absent(),
    String? network,
    String? lastFour,
    int? creditLimitMinor,
    int? currentOutstandingMinor,
    String? currencyCode,
    Value<int?> statementDay = const Value.absent(),
    Value<int?> dueDay = const Value.absent(),
    Value<DateTime?> billingCycleStart = const Value.absent(),
    Value<DateTime?> billingCycleEnd = const Value.absent(),
    String? status,
    Value<String?> rewardProgramme = const Value.absent(),
    Value<int?> colorValue = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CreditCardRow(
    id: id ?? this.id,
    bankId: bankId ?? this.bankId,
    displayName: displayName ?? this.displayName,
    cardholderName: cardholderName.present
        ? cardholderName.value
        : this.cardholderName,
    network: network ?? this.network,
    lastFour: lastFour ?? this.lastFour,
    creditLimitMinor: creditLimitMinor ?? this.creditLimitMinor,
    currentOutstandingMinor:
        currentOutstandingMinor ?? this.currentOutstandingMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    statementDay: statementDay.present ? statementDay.value : this.statementDay,
    dueDay: dueDay.present ? dueDay.value : this.dueDay,
    billingCycleStart: billingCycleStart.present
        ? billingCycleStart.value
        : this.billingCycleStart,
    billingCycleEnd: billingCycleEnd.present
        ? billingCycleEnd.value
        : this.billingCycleEnd,
    status: status ?? this.status,
    rewardProgramme: rewardProgramme.present
        ? rewardProgramme.value
        : this.rewardProgramme,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CreditCardRow copyWithCompanion(CreditCardsCompanion data) {
    return CreditCardRow(
      id: data.id.present ? data.id.value : this.id,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      cardholderName: data.cardholderName.present
          ? data.cardholderName.value
          : this.cardholderName,
      network: data.network.present ? data.network.value : this.network,
      lastFour: data.lastFour.present ? data.lastFour.value : this.lastFour,
      creditLimitMinor: data.creditLimitMinor.present
          ? data.creditLimitMinor.value
          : this.creditLimitMinor,
      currentOutstandingMinor: data.currentOutstandingMinor.present
          ? data.currentOutstandingMinor.value
          : this.currentOutstandingMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      statementDay: data.statementDay.present
          ? data.statementDay.value
          : this.statementDay,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      billingCycleStart: data.billingCycleStart.present
          ? data.billingCycleStart.value
          : this.billingCycleStart,
      billingCycleEnd: data.billingCycleEnd.present
          ? data.billingCycleEnd.value
          : this.billingCycleEnd,
      status: data.status.present ? data.status.value : this.status,
      rewardProgramme: data.rewardProgramme.present
          ? data.rewardProgramme.value
          : this.rewardProgramme,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardRow(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('displayName: $displayName, ')
          ..write('cardholderName: $cardholderName, ')
          ..write('network: $network, ')
          ..write('lastFour: $lastFour, ')
          ..write('creditLimitMinor: $creditLimitMinor, ')
          ..write('currentOutstandingMinor: $currentOutstandingMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('statementDay: $statementDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('billingCycleStart: $billingCycleStart, ')
          ..write('billingCycleEnd: $billingCycleEnd, ')
          ..write('status: $status, ')
          ..write('rewardProgramme: $rewardProgramme, ')
          ..write('colorValue: $colorValue, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bankId,
    displayName,
    cardholderName,
    network,
    lastFour,
    creditLimitMinor,
    currentOutstandingMinor,
    currencyCode,
    statementDay,
    dueDay,
    billingCycleStart,
    billingCycleEnd,
    status,
    rewardProgramme,
    colorValue,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditCardRow &&
          other.id == this.id &&
          other.bankId == this.bankId &&
          other.displayName == this.displayName &&
          other.cardholderName == this.cardholderName &&
          other.network == this.network &&
          other.lastFour == this.lastFour &&
          other.creditLimitMinor == this.creditLimitMinor &&
          other.currentOutstandingMinor == this.currentOutstandingMinor &&
          other.currencyCode == this.currencyCode &&
          other.statementDay == this.statementDay &&
          other.dueDay == this.dueDay &&
          other.billingCycleStart == this.billingCycleStart &&
          other.billingCycleEnd == this.billingCycleEnd &&
          other.status == this.status &&
          other.rewardProgramme == this.rewardProgramme &&
          other.colorValue == this.colorValue &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CreditCardsCompanion extends UpdateCompanion<CreditCardRow> {
  final Value<String> id;
  final Value<String> bankId;
  final Value<String> displayName;
  final Value<String?> cardholderName;
  final Value<String> network;
  final Value<String> lastFour;
  final Value<int> creditLimitMinor;
  final Value<int> currentOutstandingMinor;
  final Value<String> currencyCode;
  final Value<int?> statementDay;
  final Value<int?> dueDay;
  final Value<DateTime?> billingCycleStart;
  final Value<DateTime?> billingCycleEnd;
  final Value<String> status;
  final Value<String?> rewardProgramme;
  final Value<int?> colorValue;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CreditCardsCompanion({
    this.id = const Value.absent(),
    this.bankId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.cardholderName = const Value.absent(),
    this.network = const Value.absent(),
    this.lastFour = const Value.absent(),
    this.creditLimitMinor = const Value.absent(),
    this.currentOutstandingMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.statementDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.billingCycleStart = const Value.absent(),
    this.billingCycleEnd = const Value.absent(),
    this.status = const Value.absent(),
    this.rewardProgramme = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditCardsCompanion.insert({
    required String id,
    required String bankId,
    required String displayName,
    this.cardholderName = const Value.absent(),
    required String network,
    required String lastFour,
    required int creditLimitMinor,
    this.currentOutstandingMinor = const Value.absent(),
    required String currencyCode,
    this.statementDay = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.billingCycleStart = const Value.absent(),
    this.billingCycleEnd = const Value.absent(),
    this.status = const Value.absent(),
    this.rewardProgramme = const Value.absent(),
    this.colorValue = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bankId = Value(bankId),
       displayName = Value(displayName),
       network = Value(network),
       lastFour = Value(lastFour),
       creditLimitMinor = Value(creditLimitMinor),
       currencyCode = Value(currencyCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CreditCardRow> custom({
    Expression<String>? id,
    Expression<String>? bankId,
    Expression<String>? displayName,
    Expression<String>? cardholderName,
    Expression<String>? network,
    Expression<String>? lastFour,
    Expression<int>? creditLimitMinor,
    Expression<int>? currentOutstandingMinor,
    Expression<String>? currencyCode,
    Expression<int>? statementDay,
    Expression<int>? dueDay,
    Expression<DateTime>? billingCycleStart,
    Expression<DateTime>? billingCycleEnd,
    Expression<String>? status,
    Expression<String>? rewardProgramme,
    Expression<int>? colorValue,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankId != null) 'bank_id': bankId,
      if (displayName != null) 'display_name': displayName,
      if (cardholderName != null) 'cardholder_name': cardholderName,
      if (network != null) 'network': network,
      if (lastFour != null) 'last_four': lastFour,
      if (creditLimitMinor != null) 'credit_limit_minor': creditLimitMinor,
      if (currentOutstandingMinor != null)
        'current_outstanding_minor': currentOutstandingMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (statementDay != null) 'statement_day': statementDay,
      if (dueDay != null) 'due_day': dueDay,
      if (billingCycleStart != null) 'billing_cycle_start': billingCycleStart,
      if (billingCycleEnd != null) 'billing_cycle_end': billingCycleEnd,
      if (status != null) 'status': status,
      if (rewardProgramme != null) 'reward_programme': rewardProgramme,
      if (colorValue != null) 'color_value': colorValue,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditCardsCompanion copyWith({
    Value<String>? id,
    Value<String>? bankId,
    Value<String>? displayName,
    Value<String?>? cardholderName,
    Value<String>? network,
    Value<String>? lastFour,
    Value<int>? creditLimitMinor,
    Value<int>? currentOutstandingMinor,
    Value<String>? currencyCode,
    Value<int?>? statementDay,
    Value<int?>? dueDay,
    Value<DateTime?>? billingCycleStart,
    Value<DateTime?>? billingCycleEnd,
    Value<String>? status,
    Value<String?>? rewardProgramme,
    Value<int?>? colorValue,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CreditCardsCompanion(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      displayName: displayName ?? this.displayName,
      cardholderName: cardholderName ?? this.cardholderName,
      network: network ?? this.network,
      lastFour: lastFour ?? this.lastFour,
      creditLimitMinor: creditLimitMinor ?? this.creditLimitMinor,
      currentOutstandingMinor:
          currentOutstandingMinor ?? this.currentOutstandingMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      statementDay: statementDay ?? this.statementDay,
      dueDay: dueDay ?? this.dueDay,
      billingCycleStart: billingCycleStart ?? this.billingCycleStart,
      billingCycleEnd: billingCycleEnd ?? this.billingCycleEnd,
      status: status ?? this.status,
      rewardProgramme: rewardProgramme ?? this.rewardProgramme,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (cardholderName.present) {
      map['cardholder_name'] = Variable<String>(cardholderName.value);
    }
    if (network.present) {
      map['network'] = Variable<String>(network.value);
    }
    if (lastFour.present) {
      map['last_four'] = Variable<String>(lastFour.value);
    }
    if (creditLimitMinor.present) {
      map['credit_limit_minor'] = Variable<int>(creditLimitMinor.value);
    }
    if (currentOutstandingMinor.present) {
      map['current_outstanding_minor'] = Variable<int>(
        currentOutstandingMinor.value,
      );
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (statementDay.present) {
      map['statement_day'] = Variable<int>(statementDay.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (billingCycleStart.present) {
      map['billing_cycle_start'] = Variable<DateTime>(billingCycleStart.value);
    }
    if (billingCycleEnd.present) {
      map['billing_cycle_end'] = Variable<DateTime>(billingCycleEnd.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rewardProgramme.present) {
      map['reward_programme'] = Variable<String>(rewardProgramme.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditCardsCompanion(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('displayName: $displayName, ')
          ..write('cardholderName: $cardholderName, ')
          ..write('network: $network, ')
          ..write('lastFour: $lastFour, ')
          ..write('creditLimitMinor: $creditLimitMinor, ')
          ..write('currentOutstandingMinor: $currentOutstandingMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('statementDay: $statementDay, ')
          ..write('dueDay: $dueDay, ')
          ..write('billingCycleStart: $billingCycleStart, ')
          ..write('billingCycleEnd: $billingCycleEnd, ')
          ..write('status: $status, ')
          ..write('rewardProgramme: $rewardProgramme, ')
          ..write('colorValue: $colorValue, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _isSystemCategoryMeta = const VerificationMeta(
    'isSystemCategory',
  );
  @override
  late final GeneratedColumn<bool> isSystemCategory = GeneratedColumn<bool>(
    'is_system_category',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system_category" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, parentId, isSystemCategory];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('is_system_category')) {
      context.handle(
        _isSystemCategoryMeta,
        isSystemCategory.isAcceptableOrUnknown(
          data['is_system_category']!,
          _isSystemCategoryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      isSystemCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system_category'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final String? parentId;
  final bool isSystemCategory;
  const CategoryRow({
    required this.id,
    required this.name,
    this.parentId,
    required this.isSystemCategory,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['is_system_category'] = Variable<bool>(isSystemCategory);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isSystemCategory: Value(isSystemCategory),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      isSystemCategory: serializer.fromJson<bool>(json['isSystemCategory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'isSystemCategory': serializer.toJson<bool>(isSystemCategory),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    Value<String?> parentId = const Value.absent(),
    bool? isSystemCategory,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    isSystemCategory: isSystemCategory ?? this.isSystemCategory,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isSystemCategory: data.isSystemCategory.present
          ? data.isSystemCategory.value
          : this.isSystemCategory,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('isSystemCategory: $isSystemCategory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId, isSystemCategory);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.isSystemCategory == this.isSystemCategory);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<bool> isSystemCategory;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isSystemCategory = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    this.isSystemCategory = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<bool>? isSystemCategory,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (isSystemCategory != null) 'is_system_category': isSystemCategory,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentId,
    Value<bool>? isSystemCategory,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      isSystemCategory: isSystemCategory ?? this.isSystemCategory,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (isSystemCategory.present) {
      map['is_system_category'] = Variable<bool>(isSystemCategory.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('isSystemCategory: $isSystemCategory, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credit_cards (id)',
    ),
  );
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
    'bank_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES banks (id)',
    ),
  );
  static const VerificationMeta _merchantOriginalMeta = const VerificationMeta(
    'merchantOriginal',
  );
  @override
  late final GeneratedColumn<String> merchantOriginal = GeneratedColumn<String>(
    'merchant_original',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _merchantNormalizedMeta =
      const VerificationMeta('merchantNormalized');
  @override
  late final GeneratedColumn<String> merchantNormalized =
      GeneratedColumn<String>(
        'merchant_normalized',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _postingDateMeta = const VerificationMeta(
    'postingDate',
  );
  @override
  late final GeneratedColumn<DateTime> postingDate = GeneratedColumn<DateTime>(
    'posting_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionTypeMeta = const VerificationMeta(
    'transactionType',
  );
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceConfidenceMeta = const VerificationMeta(
    'sourceConfidence',
  );
  @override
  late final GeneratedColumn<String> sourceConfidence = GeneratedColumn<String>(
    'source_confidence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fingerprintMeta = const VerificationMeta(
    'fingerprint',
  );
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
    'fingerprint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fingerprintVersionMeta =
      const VerificationMeta('fingerprintVersion');
  @override
  late final GeneratedColumn<int> fingerprintVersion = GeneratedColumn<int>(
    'fingerprint_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    bankId,
    merchantOriginal,
    merchantNormalized,
    amountMinor,
    currencyCode,
    transactionDate,
    postingDate,
    transactionType,
    categoryId,
    status,
    sourceConfidence,
    notes,
    fingerprint,
    fingerprintVersion,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    }
    if (data.containsKey('bank_id')) {
      context.handle(
        _bankIdMeta,
        bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta),
      );
    }
    if (data.containsKey('merchant_original')) {
      context.handle(
        _merchantOriginalMeta,
        merchantOriginal.isAcceptableOrUnknown(
          data['merchant_original']!,
          _merchantOriginalMeta,
        ),
      );
    }
    if (data.containsKey('merchant_normalized')) {
      context.handle(
        _merchantNormalizedMeta,
        merchantNormalized.isAcceptableOrUnknown(
          data['merchant_normalized']!,
          _merchantNormalizedMeta,
        ),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('posting_date')) {
      context.handle(
        _postingDateMeta,
        postingDate.isAcceptableOrUnknown(
          data['posting_date']!,
          _postingDateMeta,
        ),
      );
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
        _transactionTypeMeta,
        transactionType.isAcceptableOrUnknown(
          data['transaction_type']!,
          _transactionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('source_confidence')) {
      context.handle(
        _sourceConfidenceMeta,
        sourceConfidence.isAcceptableOrUnknown(
          data['source_confidence']!,
          _sourceConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
        _fingerprintMeta,
        fingerprint.isAcceptableOrUnknown(
          data['fingerprint']!,
          _fingerprintMeta,
        ),
      );
    }
    if (data.containsKey('fingerprint_version')) {
      context.handle(
        _fingerprintVersionMeta,
        fingerprintVersion.isAcceptableOrUnknown(
          data['fingerprint_version']!,
          _fingerprintVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      ),
      bankId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_id'],
      ),
      merchantOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_original'],
      ),
      merchantNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_normalized'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      postingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}posting_date'],
      ),
      transactionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_type'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      sourceConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_confidence'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      fingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint'],
      ),
      fingerprintVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fingerprint_version'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;

  /// Nullable: ambiguous imports remain unassigned until reviewed.
  final String? cardId;
  final String? bankId;
  final String? merchantOriginal;
  final String? merchantNormalized;
  final int amountMinor;
  final String currencyCode;
  final DateTime transactionDate;
  final DateTime? postingDate;
  final String transactionType;
  final String? categoryId;
  final String status;
  final String? sourceConfidence;
  final String? notes;

  /// SHA-256 fingerprint of normalized import fields. Added in schema v3.
  final String? fingerprint;

  /// Version of the fingerprint recipe. Bump when normalization changes.
  final int? fingerprintVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TransactionRow({
    required this.id,
    this.cardId,
    this.bankId,
    this.merchantOriginal,
    this.merchantNormalized,
    required this.amountMinor,
    required this.currencyCode,
    required this.transactionDate,
    this.postingDate,
    required this.transactionType,
    this.categoryId,
    required this.status,
    this.sourceConfidence,
    this.notes,
    this.fingerprint,
    this.fingerprintVersion,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || cardId != null) {
      map['card_id'] = Variable<String>(cardId);
    }
    if (!nullToAbsent || bankId != null) {
      map['bank_id'] = Variable<String>(bankId);
    }
    if (!nullToAbsent || merchantOriginal != null) {
      map['merchant_original'] = Variable<String>(merchantOriginal);
    }
    if (!nullToAbsent || merchantNormalized != null) {
      map['merchant_normalized'] = Variable<String>(merchantNormalized);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || postingDate != null) {
      map['posting_date'] = Variable<DateTime>(postingDate);
    }
    map['transaction_type'] = Variable<String>(transactionType);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || sourceConfidence != null) {
      map['source_confidence'] = Variable<String>(sourceConfidence);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || fingerprint != null) {
      map['fingerprint'] = Variable<String>(fingerprint);
    }
    if (!nullToAbsent || fingerprintVersion != null) {
      map['fingerprint_version'] = Variable<int>(fingerprintVersion);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      cardId: cardId == null && nullToAbsent
          ? const Value.absent()
          : Value(cardId),
      bankId: bankId == null && nullToAbsent
          ? const Value.absent()
          : Value(bankId),
      merchantOriginal: merchantOriginal == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantOriginal),
      merchantNormalized: merchantNormalized == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantNormalized),
      amountMinor: Value(amountMinor),
      currencyCode: Value(currencyCode),
      transactionDate: Value(transactionDate),
      postingDate: postingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(postingDate),
      transactionType: Value(transactionType),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      status: Value(status),
      sourceConfidence: sourceConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceConfidence),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      fingerprint: fingerprint == null && nullToAbsent
          ? const Value.absent()
          : Value(fingerprint),
      fingerprintVersion: fingerprintVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(fingerprintVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String?>(json['cardId']),
      bankId: serializer.fromJson<String?>(json['bankId']),
      merchantOriginal: serializer.fromJson<String?>(json['merchantOriginal']),
      merchantNormalized: serializer.fromJson<String?>(
        json['merchantNormalized'],
      ),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      postingDate: serializer.fromJson<DateTime?>(json['postingDate']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      status: serializer.fromJson<String>(json['status']),
      sourceConfidence: serializer.fromJson<String?>(json['sourceConfidence']),
      notes: serializer.fromJson<String?>(json['notes']),
      fingerprint: serializer.fromJson<String?>(json['fingerprint']),
      fingerprintVersion: serializer.fromJson<int?>(json['fingerprintVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String?>(cardId),
      'bankId': serializer.toJson<String?>(bankId),
      'merchantOriginal': serializer.toJson<String?>(merchantOriginal),
      'merchantNormalized': serializer.toJson<String?>(merchantNormalized),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'postingDate': serializer.toJson<DateTime?>(postingDate),
      'transactionType': serializer.toJson<String>(transactionType),
      'categoryId': serializer.toJson<String?>(categoryId),
      'status': serializer.toJson<String>(status),
      'sourceConfidence': serializer.toJson<String?>(sourceConfidence),
      'notes': serializer.toJson<String?>(notes),
      'fingerprint': serializer.toJson<String?>(fingerprint),
      'fingerprintVersion': serializer.toJson<int?>(fingerprintVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransactionRow copyWith({
    String? id,
    Value<String?> cardId = const Value.absent(),
    Value<String?> bankId = const Value.absent(),
    Value<String?> merchantOriginal = const Value.absent(),
    Value<String?> merchantNormalized = const Value.absent(),
    int? amountMinor,
    String? currencyCode,
    DateTime? transactionDate,
    Value<DateTime?> postingDate = const Value.absent(),
    String? transactionType,
    Value<String?> categoryId = const Value.absent(),
    String? status,
    Value<String?> sourceConfidence = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> fingerprint = const Value.absent(),
    Value<int?> fingerprintVersion = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TransactionRow(
    id: id ?? this.id,
    cardId: cardId.present ? cardId.value : this.cardId,
    bankId: bankId.present ? bankId.value : this.bankId,
    merchantOriginal: merchantOriginal.present
        ? merchantOriginal.value
        : this.merchantOriginal,
    merchantNormalized: merchantNormalized.present
        ? merchantNormalized.value
        : this.merchantNormalized,
    amountMinor: amountMinor ?? this.amountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    transactionDate: transactionDate ?? this.transactionDate,
    postingDate: postingDate.present ? postingDate.value : this.postingDate,
    transactionType: transactionType ?? this.transactionType,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    status: status ?? this.status,
    sourceConfidence: sourceConfidence.present
        ? sourceConfidence.value
        : this.sourceConfidence,
    notes: notes.present ? notes.value : this.notes,
    fingerprint: fingerprint.present ? fingerprint.value : this.fingerprint,
    fingerprintVersion: fingerprintVersion.present
        ? fingerprintVersion.value
        : this.fingerprintVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      merchantOriginal: data.merchantOriginal.present
          ? data.merchantOriginal.value
          : this.merchantOriginal,
      merchantNormalized: data.merchantNormalized.present
          ? data.merchantNormalized.value
          : this.merchantNormalized,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      postingDate: data.postingDate.present
          ? data.postingDate.value
          : this.postingDate,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      status: data.status.present ? data.status.value : this.status,
      sourceConfidence: data.sourceConfidence.present
          ? data.sourceConfidence.value
          : this.sourceConfidence,
      notes: data.notes.present ? data.notes.value : this.notes,
      fingerprint: data.fingerprint.present
          ? data.fingerprint.value
          : this.fingerprint,
      fingerprintVersion: data.fingerprintVersion.present
          ? data.fingerprintVersion.value
          : this.fingerprintVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('bankId: $bankId, ')
          ..write('merchantOriginal: $merchantOriginal, ')
          ..write('merchantNormalized: $merchantNormalized, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('postingDate: $postingDate, ')
          ..write('transactionType: $transactionType, ')
          ..write('categoryId: $categoryId, ')
          ..write('status: $status, ')
          ..write('sourceConfidence: $sourceConfidence, ')
          ..write('notes: $notes, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('fingerprintVersion: $fingerprintVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    bankId,
    merchantOriginal,
    merchantNormalized,
    amountMinor,
    currencyCode,
    transactionDate,
    postingDate,
    transactionType,
    categoryId,
    status,
    sourceConfidence,
    notes,
    fingerprint,
    fingerprintVersion,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.bankId == this.bankId &&
          other.merchantOriginal == this.merchantOriginal &&
          other.merchantNormalized == this.merchantNormalized &&
          other.amountMinor == this.amountMinor &&
          other.currencyCode == this.currencyCode &&
          other.transactionDate == this.transactionDate &&
          other.postingDate == this.postingDate &&
          other.transactionType == this.transactionType &&
          other.categoryId == this.categoryId &&
          other.status == this.status &&
          other.sourceConfidence == this.sourceConfidence &&
          other.notes == this.notes &&
          other.fingerprint == this.fingerprint &&
          other.fingerprintVersion == this.fingerprintVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<String?> cardId;
  final Value<String?> bankId;
  final Value<String?> merchantOriginal;
  final Value<String?> merchantNormalized;
  final Value<int> amountMinor;
  final Value<String> currencyCode;
  final Value<DateTime> transactionDate;
  final Value<DateTime?> postingDate;
  final Value<String> transactionType;
  final Value<String?> categoryId;
  final Value<String> status;
  final Value<String?> sourceConfidence;
  final Value<String?> notes;
  final Value<String?> fingerprint;
  final Value<int?> fingerprintVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.bankId = const Value.absent(),
    this.merchantOriginal = const Value.absent(),
    this.merchantNormalized = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.postingDate = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.status = const Value.absent(),
    this.sourceConfidence = const Value.absent(),
    this.notes = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.fingerprintVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    this.cardId = const Value.absent(),
    this.bankId = const Value.absent(),
    this.merchantOriginal = const Value.absent(),
    this.merchantNormalized = const Value.absent(),
    required int amountMinor,
    required String currencyCode,
    required DateTime transactionDate,
    this.postingDate = const Value.absent(),
    required String transactionType,
    this.categoryId = const Value.absent(),
    required String status,
    this.sourceConfidence = const Value.absent(),
    this.notes = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.fingerprintVersion = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amountMinor = Value(amountMinor),
       currencyCode = Value(currencyCode),
       transactionDate = Value(transactionDate),
       transactionType = Value(transactionType),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? bankId,
    Expression<String>? merchantOriginal,
    Expression<String>? merchantNormalized,
    Expression<int>? amountMinor,
    Expression<String>? currencyCode,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? postingDate,
    Expression<String>? transactionType,
    Expression<String>? categoryId,
    Expression<String>? status,
    Expression<String>? sourceConfidence,
    Expression<String>? notes,
    Expression<String>? fingerprint,
    Expression<int>? fingerprintVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (bankId != null) 'bank_id': bankId,
      if (merchantOriginal != null) 'merchant_original': merchantOriginal,
      if (merchantNormalized != null) 'merchant_normalized': merchantNormalized,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (postingDate != null) 'posting_date': postingDate,
      if (transactionType != null) 'transaction_type': transactionType,
      if (categoryId != null) 'category_id': categoryId,
      if (status != null) 'status': status,
      if (sourceConfidence != null) 'source_confidence': sourceConfidence,
      if (notes != null) 'notes': notes,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (fingerprintVersion != null) 'fingerprint_version': fingerprintVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? cardId,
    Value<String?>? bankId,
    Value<String?>? merchantOriginal,
    Value<String?>? merchantNormalized,
    Value<int>? amountMinor,
    Value<String>? currencyCode,
    Value<DateTime>? transactionDate,
    Value<DateTime?>? postingDate,
    Value<String>? transactionType,
    Value<String?>? categoryId,
    Value<String>? status,
    Value<String?>? sourceConfidence,
    Value<String?>? notes,
    Value<String?>? fingerprint,
    Value<int?>? fingerprintVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      bankId: bankId ?? this.bankId,
      merchantOriginal: merchantOriginal ?? this.merchantOriginal,
      merchantNormalized: merchantNormalized ?? this.merchantNormalized,
      amountMinor: amountMinor ?? this.amountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      transactionDate: transactionDate ?? this.transactionDate,
      postingDate: postingDate ?? this.postingDate,
      transactionType: transactionType ?? this.transactionType,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      sourceConfidence: sourceConfidence ?? this.sourceConfidence,
      notes: notes ?? this.notes,
      fingerprint: fingerprint ?? this.fingerprint,
      fingerprintVersion: fingerprintVersion ?? this.fingerprintVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (merchantOriginal.present) {
      map['merchant_original'] = Variable<String>(merchantOriginal.value);
    }
    if (merchantNormalized.present) {
      map['merchant_normalized'] = Variable<String>(merchantNormalized.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (postingDate.present) {
      map['posting_date'] = Variable<DateTime>(postingDate.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sourceConfidence.present) {
      map['source_confidence'] = Variable<String>(sourceConfidence.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (fingerprintVersion.present) {
      map['fingerprint_version'] = Variable<int>(fingerprintVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('bankId: $bankId, ')
          ..write('merchantOriginal: $merchantOriginal, ')
          ..write('merchantNormalized: $merchantNormalized, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('postingDate: $postingDate, ')
          ..write('transactionType: $transactionType, ')
          ..write('categoryId: $categoryId, ')
          ..write('status: $status, ')
          ..write('sourceConfidence: $sourceConfidence, ')
          ..write('notes: $notes, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('fingerprintVersion: $fingerprintVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImportJobsTable extends ImportJobs
    with TableInfo<$ImportJobsTable, ImportJobRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImportJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordsFoundMeta = const VerificationMeta(
    'recordsFound',
  );
  @override
  late final GeneratedColumn<int> recordsFound = GeneratedColumn<int>(
    'records_found',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _recordsImportedMeta = const VerificationMeta(
    'recordsImported',
  );
  @override
  late final GeneratedColumn<int> recordsImported = GeneratedColumn<int>(
    'records_imported',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _recordsSkippedMeta = const VerificationMeta(
    'recordsSkipped',
  );
  @override
  late final GeneratedColumn<int> recordsSkipped = GeneratedColumn<int>(
    'records_skipped',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _recordsRequiringReviewMeta =
      const VerificationMeta('recordsRequiringReview');
  @override
  late final GeneratedColumn<int> recordsRequiringReview = GeneratedColumn<int>(
    'records_requiring_review',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceType,
    status,
    startedAt,
    completedAt,
    progress,
    recordsFound,
    recordsImported,
    recordsSkipped,
    recordsRequiringReview,
    errorCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'import_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImportJobRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('records_found')) {
      context.handle(
        _recordsFoundMeta,
        recordsFound.isAcceptableOrUnknown(
          data['records_found']!,
          _recordsFoundMeta,
        ),
      );
    }
    if (data.containsKey('records_imported')) {
      context.handle(
        _recordsImportedMeta,
        recordsImported.isAcceptableOrUnknown(
          data['records_imported']!,
          _recordsImportedMeta,
        ),
      );
    }
    if (data.containsKey('records_skipped')) {
      context.handle(
        _recordsSkippedMeta,
        recordsSkipped.isAcceptableOrUnknown(
          data['records_skipped']!,
          _recordsSkippedMeta,
        ),
      );
    }
    if (data.containsKey('records_requiring_review')) {
      context.handle(
        _recordsRequiringReviewMeta,
        recordsRequiringReview.isAcceptableOrUnknown(
          data['records_requiring_review']!,
          _recordsRequiringReviewMeta,
        ),
      );
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImportJobRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImportJobRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      ),
      recordsFound: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}records_found'],
      )!,
      recordsImported: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}records_imported'],
      )!,
      recordsSkipped: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}records_skipped'],
      )!,
      recordsRequiringReview: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}records_requiring_review'],
      )!,
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
    );
  }

  @override
  $ImportJobsTable createAlias(String alias) {
    return $ImportJobsTable(attachedDatabase, alias);
  }
}

class ImportJobRow extends DataClass implements Insertable<ImportJobRow> {
  final String id;
  final String sourceType;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? progress;
  final int recordsFound;
  final int recordsImported;
  final int recordsSkipped;
  final int recordsRequiringReview;
  final String? errorCode;
  const ImportJobRow({
    required this.id,
    required this.sourceType,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.progress,
    required this.recordsFound,
    required this.recordsImported,
    required this.recordsSkipped,
    required this.recordsRequiringReview,
    this.errorCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_type'] = Variable<String>(sourceType);
    map['status'] = Variable<String>(status);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<int>(progress);
    }
    map['records_found'] = Variable<int>(recordsFound);
    map['records_imported'] = Variable<int>(recordsImported);
    map['records_skipped'] = Variable<int>(recordsSkipped);
    map['records_requiring_review'] = Variable<int>(recordsRequiringReview);
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    return map;
  }

  ImportJobsCompanion toCompanion(bool nullToAbsent) {
    return ImportJobsCompanion(
      id: Value(id),
      sourceType: Value(sourceType),
      status: Value(status),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      recordsFound: Value(recordsFound),
      recordsImported: Value(recordsImported),
      recordsSkipped: Value(recordsSkipped),
      recordsRequiringReview: Value(recordsRequiringReview),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
    );
  }

  factory ImportJobRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImportJobRow(
      id: serializer.fromJson<String>(json['id']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      progress: serializer.fromJson<int?>(json['progress']),
      recordsFound: serializer.fromJson<int>(json['recordsFound']),
      recordsImported: serializer.fromJson<int>(json['recordsImported']),
      recordsSkipped: serializer.fromJson<int>(json['recordsSkipped']),
      recordsRequiringReview: serializer.fromJson<int>(
        json['recordsRequiringReview'],
      ),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceType': serializer.toJson<String>(sourceType),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'progress': serializer.toJson<int?>(progress),
      'recordsFound': serializer.toJson<int>(recordsFound),
      'recordsImported': serializer.toJson<int>(recordsImported),
      'recordsSkipped': serializer.toJson<int>(recordsSkipped),
      'recordsRequiringReview': serializer.toJson<int>(recordsRequiringReview),
      'errorCode': serializer.toJson<String?>(errorCode),
    };
  }

  ImportJobRow copyWith({
    String? id,
    String? sourceType,
    String? status,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> progress = const Value.absent(),
    int? recordsFound,
    int? recordsImported,
    int? recordsSkipped,
    int? recordsRequiringReview,
    Value<String?> errorCode = const Value.absent(),
  }) => ImportJobRow(
    id: id ?? this.id,
    sourceType: sourceType ?? this.sourceType,
    status: status ?? this.status,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    progress: progress.present ? progress.value : this.progress,
    recordsFound: recordsFound ?? this.recordsFound,
    recordsImported: recordsImported ?? this.recordsImported,
    recordsSkipped: recordsSkipped ?? this.recordsSkipped,
    recordsRequiringReview:
        recordsRequiringReview ?? this.recordsRequiringReview,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
  );
  ImportJobRow copyWithCompanion(ImportJobsCompanion data) {
    return ImportJobRow(
      id: data.id.present ? data.id.value : this.id,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      progress: data.progress.present ? data.progress.value : this.progress,
      recordsFound: data.recordsFound.present
          ? data.recordsFound.value
          : this.recordsFound,
      recordsImported: data.recordsImported.present
          ? data.recordsImported.value
          : this.recordsImported,
      recordsSkipped: data.recordsSkipped.present
          ? data.recordsSkipped.value
          : this.recordsSkipped,
      recordsRequiringReview: data.recordsRequiringReview.present
          ? data.recordsRequiringReview.value
          : this.recordsRequiringReview,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImportJobRow(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('progress: $progress, ')
          ..write('recordsFound: $recordsFound, ')
          ..write('recordsImported: $recordsImported, ')
          ..write('recordsSkipped: $recordsSkipped, ')
          ..write('recordsRequiringReview: $recordsRequiringReview, ')
          ..write('errorCode: $errorCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceType,
    status,
    startedAt,
    completedAt,
    progress,
    recordsFound,
    recordsImported,
    recordsSkipped,
    recordsRequiringReview,
    errorCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImportJobRow &&
          other.id == this.id &&
          other.sourceType == this.sourceType &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.progress == this.progress &&
          other.recordsFound == this.recordsFound &&
          other.recordsImported == this.recordsImported &&
          other.recordsSkipped == this.recordsSkipped &&
          other.recordsRequiringReview == this.recordsRequiringReview &&
          other.errorCode == this.errorCode);
}

class ImportJobsCompanion extends UpdateCompanion<ImportJobRow> {
  final Value<String> id;
  final Value<String> sourceType;
  final Value<String> status;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int?> progress;
  final Value<int> recordsFound;
  final Value<int> recordsImported;
  final Value<int> recordsSkipped;
  final Value<int> recordsRequiringReview;
  final Value<String?> errorCode;
  final Value<int> rowid;
  const ImportJobsCompanion({
    this.id = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.progress = const Value.absent(),
    this.recordsFound = const Value.absent(),
    this.recordsImported = const Value.absent(),
    this.recordsSkipped = const Value.absent(),
    this.recordsRequiringReview = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImportJobsCompanion.insert({
    required String id,
    required String sourceType,
    required String status,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.progress = const Value.absent(),
    this.recordsFound = const Value.absent(),
    this.recordsImported = const Value.absent(),
    this.recordsSkipped = const Value.absent(),
    this.recordsRequiringReview = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceType = Value(sourceType),
       status = Value(status),
       startedAt = Value(startedAt);
  static Insertable<ImportJobRow> custom({
    Expression<String>? id,
    Expression<String>? sourceType,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? progress,
    Expression<int>? recordsFound,
    Expression<int>? recordsImported,
    Expression<int>? recordsSkipped,
    Expression<int>? recordsRequiringReview,
    Expression<String>? errorCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceType != null) 'source_type': sourceType,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (progress != null) 'progress': progress,
      if (recordsFound != null) 'records_found': recordsFound,
      if (recordsImported != null) 'records_imported': recordsImported,
      if (recordsSkipped != null) 'records_skipped': recordsSkipped,
      if (recordsRequiringReview != null)
        'records_requiring_review': recordsRequiringReview,
      if (errorCode != null) 'error_code': errorCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImportJobsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceType,
    Value<String>? status,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int?>? progress,
    Value<int>? recordsFound,
    Value<int>? recordsImported,
    Value<int>? recordsSkipped,
    Value<int>? recordsRequiringReview,
    Value<String?>? errorCode,
    Value<int>? rowid,
  }) {
    return ImportJobsCompanion(
      id: id ?? this.id,
      sourceType: sourceType ?? this.sourceType,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      progress: progress ?? this.progress,
      recordsFound: recordsFound ?? this.recordsFound,
      recordsImported: recordsImported ?? this.recordsImported,
      recordsSkipped: recordsSkipped ?? this.recordsSkipped,
      recordsRequiringReview:
          recordsRequiringReview ?? this.recordsRequiringReview,
      errorCode: errorCode ?? this.errorCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (recordsFound.present) {
      map['records_found'] = Variable<int>(recordsFound.value);
    }
    if (recordsImported.present) {
      map['records_imported'] = Variable<int>(recordsImported.value);
    }
    if (recordsSkipped.present) {
      map['records_skipped'] = Variable<int>(recordsSkipped.value);
    }
    if (recordsRequiringReview.present) {
      map['records_requiring_review'] = Variable<int>(
        recordsRequiringReview.value,
      );
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImportJobsCompanion(')
          ..write('id: $id, ')
          ..write('sourceType: $sourceType, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('progress: $progress, ')
          ..write('recordsFound: $recordsFound, ')
          ..write('recordsImported: $recordsImported, ')
          ..write('recordsSkipped: $recordsSkipped, ')
          ..write('recordsRequiringReview: $recordsRequiringReview, ')
          ..write('errorCode: $errorCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionSourcesTable extends TransactionSources
    with TableInfo<$TransactionSourcesTable, TransactionSourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceReferenceMeta = const VerificationMeta(
    'sourceReference',
  );
  @override
  late final GeneratedColumn<String> sourceReference = GeneratedColumn<String>(
    'source_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceDateMeta = const VerificationMeta(
    'sourceDate',
  );
  @override
  late final GeneratedColumn<DateTime> sourceDate = GeneratedColumn<DateTime>(
    'source_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalDescriptionMeta =
      const VerificationMeta('originalDescription');
  @override
  late final GeneratedColumn<String> originalDescription =
      GeneratedColumn<String>(
        'original_description',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _importJobIdMeta = const VerificationMeta(
    'importJobId',
  );
  @override
  late final GeneratedColumn<String> importJobId = GeneratedColumn<String>(
    'import_job_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES import_jobs (id)',
    ),
  );
  static const VerificationMeta _parserIdMeta = const VerificationMeta(
    'parserId',
  );
  @override
  late final GeneratedColumn<String> parserId = GeneratedColumn<String>(
    'parser_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parserVersionMeta = const VerificationMeta(
    'parserVersion',
  );
  @override
  late final GeneratedColumn<String> parserVersion = GeneratedColumn<String>(
    'parser_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _matchStatusMeta = const VerificationMeta(
    'matchStatus',
  );
  @override
  late final GeneratedColumn<String> matchStatus = GeneratedColumn<String>(
    'match_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    sourceType,
    sourceReference,
    sourceDate,
    originalDescription,
    importJobId,
    parserId,
    parserVersion,
    matchStatus,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionSourceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_reference')) {
      context.handle(
        _sourceReferenceMeta,
        sourceReference.isAcceptableOrUnknown(
          data['source_reference']!,
          _sourceReferenceMeta,
        ),
      );
    }
    if (data.containsKey('source_date')) {
      context.handle(
        _sourceDateMeta,
        sourceDate.isAcceptableOrUnknown(data['source_date']!, _sourceDateMeta),
      );
    }
    if (data.containsKey('original_description')) {
      context.handle(
        _originalDescriptionMeta,
        originalDescription.isAcceptableOrUnknown(
          data['original_description']!,
          _originalDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalDescriptionMeta);
    }
    if (data.containsKey('import_job_id')) {
      context.handle(
        _importJobIdMeta,
        importJobId.isAcceptableOrUnknown(
          data['import_job_id']!,
          _importJobIdMeta,
        ),
      );
    }
    if (data.containsKey('parser_id')) {
      context.handle(
        _parserIdMeta,
        parserId.isAcceptableOrUnknown(data['parser_id']!, _parserIdMeta),
      );
    }
    if (data.containsKey('parser_version')) {
      context.handle(
        _parserVersionMeta,
        parserVersion.isAcceptableOrUnknown(
          data['parser_version']!,
          _parserVersionMeta,
        ),
      );
    }
    if (data.containsKey('match_status')) {
      context.handle(
        _matchStatusMeta,
        matchStatus.isAcceptableOrUnknown(
          data['match_status']!,
          _matchStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_matchStatusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionSourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionSourceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference'],
      ),
      sourceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}source_date'],
      ),
      originalDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_description'],
      )!,
      importJobId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_job_id'],
      ),
      parserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parser_id'],
      ),
      parserVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parser_version'],
      ),
      matchStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionSourcesTable createAlias(String alias) {
    return $TransactionSourcesTable(attachedDatabase, alias);
  }
}

class TransactionSourceRow extends DataClass
    implements Insertable<TransactionSourceRow> {
  final String id;
  final String? transactionId;
  final String sourceType;
  final String? sourceReference;
  final DateTime? sourceDate;
  final String originalDescription;
  final String? importJobId;
  final String? parserId;
  final String? parserVersion;
  final String matchStatus;
  final DateTime createdAt;
  const TransactionSourceRow({
    required this.id,
    this.transactionId,
    required this.sourceType,
    this.sourceReference,
    this.sourceDate,
    required this.originalDescription,
    this.importJobId,
    this.parserId,
    this.parserVersion,
    required this.matchStatus,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceReference != null) {
      map['source_reference'] = Variable<String>(sourceReference);
    }
    if (!nullToAbsent || sourceDate != null) {
      map['source_date'] = Variable<DateTime>(sourceDate);
    }
    map['original_description'] = Variable<String>(originalDescription);
    if (!nullToAbsent || importJobId != null) {
      map['import_job_id'] = Variable<String>(importJobId);
    }
    if (!nullToAbsent || parserId != null) {
      map['parser_id'] = Variable<String>(parserId);
    }
    if (!nullToAbsent || parserVersion != null) {
      map['parser_version'] = Variable<String>(parserVersion);
    }
    map['match_status'] = Variable<String>(matchStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionSourcesCompanion toCompanion(bool nullToAbsent) {
    return TransactionSourcesCompanion(
      id: Value(id),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      sourceType: Value(sourceType),
      sourceReference: sourceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReference),
      sourceDate: sourceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceDate),
      originalDescription: Value(originalDescription),
      importJobId: importJobId == null && nullToAbsent
          ? const Value.absent()
          : Value(importJobId),
      parserId: parserId == null && nullToAbsent
          ? const Value.absent()
          : Value(parserId),
      parserVersion: parserVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(parserVersion),
      matchStatus: Value(matchStatus),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionSourceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionSourceRow(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceReference: serializer.fromJson<String?>(json['sourceReference']),
      sourceDate: serializer.fromJson<DateTime?>(json['sourceDate']),
      originalDescription: serializer.fromJson<String>(
        json['originalDescription'],
      ),
      importJobId: serializer.fromJson<String?>(json['importJobId']),
      parserId: serializer.fromJson<String?>(json['parserId']),
      parserVersion: serializer.fromJson<String?>(json['parserVersion']),
      matchStatus: serializer.fromJson<String>(json['matchStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String?>(transactionId),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceReference': serializer.toJson<String?>(sourceReference),
      'sourceDate': serializer.toJson<DateTime?>(sourceDate),
      'originalDescription': serializer.toJson<String>(originalDescription),
      'importJobId': serializer.toJson<String?>(importJobId),
      'parserId': serializer.toJson<String?>(parserId),
      'parserVersion': serializer.toJson<String?>(parserVersion),
      'matchStatus': serializer.toJson<String>(matchStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionSourceRow copyWith({
    String? id,
    Value<String?> transactionId = const Value.absent(),
    String? sourceType,
    Value<String?> sourceReference = const Value.absent(),
    Value<DateTime?> sourceDate = const Value.absent(),
    String? originalDescription,
    Value<String?> importJobId = const Value.absent(),
    Value<String?> parserId = const Value.absent(),
    Value<String?> parserVersion = const Value.absent(),
    String? matchStatus,
    DateTime? createdAt,
  }) => TransactionSourceRow(
    id: id ?? this.id,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    sourceType: sourceType ?? this.sourceType,
    sourceReference: sourceReference.present
        ? sourceReference.value
        : this.sourceReference,
    sourceDate: sourceDate.present ? sourceDate.value : this.sourceDate,
    originalDescription: originalDescription ?? this.originalDescription,
    importJobId: importJobId.present ? importJobId.value : this.importJobId,
    parserId: parserId.present ? parserId.value : this.parserId,
    parserVersion: parserVersion.present
        ? parserVersion.value
        : this.parserVersion,
    matchStatus: matchStatus ?? this.matchStatus,
    createdAt: createdAt ?? this.createdAt,
  );
  TransactionSourceRow copyWithCompanion(TransactionSourcesCompanion data) {
    return TransactionSourceRow(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceReference: data.sourceReference.present
          ? data.sourceReference.value
          : this.sourceReference,
      sourceDate: data.sourceDate.present
          ? data.sourceDate.value
          : this.sourceDate,
      originalDescription: data.originalDescription.present
          ? data.originalDescription.value
          : this.originalDescription,
      importJobId: data.importJobId.present
          ? data.importJobId.value
          : this.importJobId,
      parserId: data.parserId.present ? data.parserId.value : this.parserId,
      parserVersion: data.parserVersion.present
          ? data.parserVersion.value
          : this.parserVersion,
      matchStatus: data.matchStatus.present
          ? data.matchStatus.value
          : this.matchStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSourceRow(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('sourceDate: $sourceDate, ')
          ..write('originalDescription: $originalDescription, ')
          ..write('importJobId: $importJobId, ')
          ..write('parserId: $parserId, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('matchStatus: $matchStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    sourceType,
    sourceReference,
    sourceDate,
    originalDescription,
    importJobId,
    parserId,
    parserVersion,
    matchStatus,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionSourceRow &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.sourceType == this.sourceType &&
          other.sourceReference == this.sourceReference &&
          other.sourceDate == this.sourceDate &&
          other.originalDescription == this.originalDescription &&
          other.importJobId == this.importJobId &&
          other.parserId == this.parserId &&
          other.parserVersion == this.parserVersion &&
          other.matchStatus == this.matchStatus &&
          other.createdAt == this.createdAt);
}

class TransactionSourcesCompanion
    extends UpdateCompanion<TransactionSourceRow> {
  final Value<String> id;
  final Value<String?> transactionId;
  final Value<String> sourceType;
  final Value<String?> sourceReference;
  final Value<DateTime?> sourceDate;
  final Value<String> originalDescription;
  final Value<String?> importJobId;
  final Value<String?> parserId;
  final Value<String?> parserVersion;
  final Value<String> matchStatus;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TransactionSourcesCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.sourceDate = const Value.absent(),
    this.originalDescription = const Value.absent(),
    this.importJobId = const Value.absent(),
    this.parserId = const Value.absent(),
    this.parserVersion = const Value.absent(),
    this.matchStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionSourcesCompanion.insert({
    required String id,
    this.transactionId = const Value.absent(),
    required String sourceType,
    this.sourceReference = const Value.absent(),
    this.sourceDate = const Value.absent(),
    required String originalDescription,
    this.importJobId = const Value.absent(),
    this.parserId = const Value.absent(),
    this.parserVersion = const Value.absent(),
    required String matchStatus,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceType = Value(sourceType),
       originalDescription = Value(originalDescription),
       matchStatus = Value(matchStatus),
       createdAt = Value(createdAt);
  static Insertable<TransactionSourceRow> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<String>? sourceType,
    Expression<String>? sourceReference,
    Expression<DateTime>? sourceDate,
    Expression<String>? originalDescription,
    Expression<String>? importJobId,
    Expression<String>? parserId,
    Expression<String>? parserVersion,
    Expression<String>? matchStatus,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceReference != null) 'source_reference': sourceReference,
      if (sourceDate != null) 'source_date': sourceDate,
      if (originalDescription != null)
        'original_description': originalDescription,
      if (importJobId != null) 'import_job_id': importJobId,
      if (parserId != null) 'parser_id': parserId,
      if (parserVersion != null) 'parser_version': parserVersion,
      if (matchStatus != null) 'match_status': matchStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionSourcesCompanion copyWith({
    Value<String>? id,
    Value<String?>? transactionId,
    Value<String>? sourceType,
    Value<String?>? sourceReference,
    Value<DateTime?>? sourceDate,
    Value<String>? originalDescription,
    Value<String?>? importJobId,
    Value<String?>? parserId,
    Value<String?>? parserVersion,
    Value<String>? matchStatus,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TransactionSourcesCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      sourceType: sourceType ?? this.sourceType,
      sourceReference: sourceReference ?? this.sourceReference,
      sourceDate: sourceDate ?? this.sourceDate,
      originalDescription: originalDescription ?? this.originalDescription,
      importJobId: importJobId ?? this.importJobId,
      parserId: parserId ?? this.parserId,
      parserVersion: parserVersion ?? this.parserVersion,
      matchStatus: matchStatus ?? this.matchStatus,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceReference.present) {
      map['source_reference'] = Variable<String>(sourceReference.value);
    }
    if (sourceDate.present) {
      map['source_date'] = Variable<DateTime>(sourceDate.value);
    }
    if (originalDescription.present) {
      map['original_description'] = Variable<String>(originalDescription.value);
    }
    if (importJobId.present) {
      map['import_job_id'] = Variable<String>(importJobId.value);
    }
    if (parserId.present) {
      map['parser_id'] = Variable<String>(parserId.value);
    }
    if (parserVersion.present) {
      map['parser_version'] = Variable<String>(parserVersion.value);
    }
    if (matchStatus.present) {
      map['match_status'] = Variable<String>(matchStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSourcesCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('sourceDate: $sourceDate, ')
          ..write('originalDescription: $originalDescription, ')
          ..write('importJobId: $importJobId, ')
          ..write('parserId: $parserId, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('matchStatus: $matchStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedValueMeta = const VerificationMeta(
    'encryptedValue',
  );
  @override
  late final GeneratedColumn<String> encryptedValue = GeneratedColumn<String>(
    'encrypted_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plainValueMeta = const VerificationMeta(
    'plainValue',
  );
  @override
  late final GeneratedColumn<String> plainValue = GeneratedColumn<String>(
    'plain_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    settingKey,
    encryptedValue,
    plainValue,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('encrypted_value')) {
      context.handle(
        _encryptedValueMeta,
        encryptedValue.isAcceptableOrUnknown(
          data['encrypted_value']!,
          _encryptedValueMeta,
        ),
      );
    }
    if (data.containsKey('plain_value')) {
      context.handle(
        _plainValueMeta,
        plainValue.isAcceptableOrUnknown(data['plain_value']!, _plainValueMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      encryptedValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_value'],
      ),
      plainValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plain_value'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final String id;
  final String settingKey;
  final String? encryptedValue;
  final String? plainValue;
  final DateTime updatedAt;
  const AppSettingRow({
    required this.id,
    required this.settingKey,
    this.encryptedValue,
    this.plainValue,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['setting_key'] = Variable<String>(settingKey);
    if (!nullToAbsent || encryptedValue != null) {
      map['encrypted_value'] = Variable<String>(encryptedValue);
    }
    if (!nullToAbsent || plainValue != null) {
      map['plain_value'] = Variable<String>(plainValue);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      settingKey: Value(settingKey),
      encryptedValue: encryptedValue == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedValue),
      plainValue: plainValue == null && nullToAbsent
          ? const Value.absent()
          : Value(plainValue),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      id: serializer.fromJson<String>(json['id']),
      settingKey: serializer.fromJson<String>(json['settingKey']),
      encryptedValue: serializer.fromJson<String?>(json['encryptedValue']),
      plainValue: serializer.fromJson<String?>(json['plainValue']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'settingKey': serializer.toJson<String>(settingKey),
      'encryptedValue': serializer.toJson<String?>(encryptedValue),
      'plainValue': serializer.toJson<String?>(plainValue),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingRow copyWith({
    String? id,
    String? settingKey,
    Value<String?> encryptedValue = const Value.absent(),
    Value<String?> plainValue = const Value.absent(),
    DateTime? updatedAt,
  }) => AppSettingRow(
    id: id ?? this.id,
    settingKey: settingKey ?? this.settingKey,
    encryptedValue: encryptedValue.present
        ? encryptedValue.value
        : this.encryptedValue,
    plainValue: plainValue.present ? plainValue.value : this.plainValue,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      id: data.id.present ? data.id.value : this.id,
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      encryptedValue: data.encryptedValue.present
          ? data.encryptedValue.value
          : this.encryptedValue,
      plainValue: data.plainValue.present
          ? data.plainValue.value
          : this.plainValue,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('id: $id, ')
          ..write('settingKey: $settingKey, ')
          ..write('encryptedValue: $encryptedValue, ')
          ..write('plainValue: $plainValue, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, settingKey, encryptedValue, plainValue, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.id == this.id &&
          other.settingKey == this.settingKey &&
          other.encryptedValue == this.encryptedValue &&
          other.plainValue == this.plainValue &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<String> id;
  final Value<String> settingKey;
  final Value<String?> encryptedValue;
  final Value<String?> plainValue;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.settingKey = const Value.absent(),
    this.encryptedValue = const Value.absent(),
    this.plainValue = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String id,
    required String settingKey,
    this.encryptedValue = const Value.absent(),
    this.plainValue = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       settingKey = Value(settingKey),
       updatedAt = Value(updatedAt);
  static Insertable<AppSettingRow> custom({
    Expression<String>? id,
    Expression<String>? settingKey,
    Expression<String>? encryptedValue,
    Expression<String>? plainValue,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (settingKey != null) 'setting_key': settingKey,
      if (encryptedValue != null) 'encrypted_value': encryptedValue,
      if (plainValue != null) 'plain_value': plainValue,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? id,
    Value<String>? settingKey,
    Value<String?>? encryptedValue,
    Value<String?>? plainValue,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      settingKey: settingKey ?? this.settingKey,
      encryptedValue: encryptedValue ?? this.encryptedValue,
      plainValue: plainValue ?? this.plainValue,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (encryptedValue.present) {
      map['encrypted_value'] = Variable<String>(encryptedValue.value);
    }
    if (plainValue.present) {
      map['plain_value'] = Variable<String>(plainValue.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('settingKey: $settingKey, ')
          ..write('encryptedValue: $encryptedValue, ')
          ..write('plainValue: $plainValue, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewItemsTable extends ReviewItems
    with TableInfo<$ReviewItemsTable, ReviewItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceReferenceMeta = const VerificationMeta(
    'sourceReference',
  );
  @override
  late final GeneratedColumn<String> sourceReference = GeneratedColumn<String>(
    'source_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonCodeMeta = const VerificationMeta(
    'reasonCode',
  );
  @override
  late final GeneratedColumn<String> reasonCode = GeneratedColumn<String>(
    'reason_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userMessageMeta = const VerificationMeta(
    'userMessage',
  );
  @override
  late final GeneratedColumn<String> userMessage = GeneratedColumn<String>(
    'user_message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    sourceType,
    sourceReference,
    reasonCode,
    userMessage,
    details,
    status,
    createdAt,
    resolvedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('source_reference')) {
      context.handle(
        _sourceReferenceMeta,
        sourceReference.isAcceptableOrUnknown(
          data['source_reference']!,
          _sourceReferenceMeta,
        ),
      );
    }
    if (data.containsKey('reason_code')) {
      context.handle(
        _reasonCodeMeta,
        reasonCode.isAcceptableOrUnknown(data['reason_code']!, _reasonCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonCodeMeta);
    }
    if (data.containsKey('user_message')) {
      context.handle(
        _userMessageMeta,
        userMessage.isAcceptableOrUnknown(
          data['user_message']!,
          _userMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userMessageMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      ),
      sourceReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_reference'],
      ),
      reasonCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_code'],
      )!,
      userMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_message'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
    );
  }

  @override
  $ReviewItemsTable createAlias(String alias) {
    return $ReviewItemsTable(attachedDatabase, alias);
  }
}

class ReviewItemRow extends DataClass implements Insertable<ReviewItemRow> {
  final String id;
  final String entityType;
  final String? entityId;
  final String? sourceType;
  final String? sourceReference;
  final String reasonCode;
  final String userMessage;
  final String? details;
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  const ReviewItemRow({
    required this.id,
    required this.entityType,
    this.entityId,
    this.sourceType,
    this.sourceReference,
    required this.reasonCode,
    required this.userMessage,
    this.details,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    if (!nullToAbsent || sourceType != null) {
      map['source_type'] = Variable<String>(sourceType);
    }
    if (!nullToAbsent || sourceReference != null) {
      map['source_reference'] = Variable<String>(sourceReference);
    }
    map['reason_code'] = Variable<String>(reasonCode);
    map['user_message'] = Variable<String>(userMessage);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    return map;
  }

  ReviewItemsCompanion toCompanion(bool nullToAbsent) {
    return ReviewItemsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      sourceType: sourceType == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceType),
      sourceReference: sourceReference == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceReference),
      reasonCode: Value(reasonCode),
      userMessage: Value(userMessage),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      status: Value(status),
      createdAt: Value(createdAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
    );
  }

  factory ReviewItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewItemRow(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      sourceType: serializer.fromJson<String?>(json['sourceType']),
      sourceReference: serializer.fromJson<String?>(json['sourceReference']),
      reasonCode: serializer.fromJson<String>(json['reasonCode']),
      userMessage: serializer.fromJson<String>(json['userMessage']),
      details: serializer.fromJson<String?>(json['details']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String?>(entityId),
      'sourceType': serializer.toJson<String?>(sourceType),
      'sourceReference': serializer.toJson<String?>(sourceReference),
      'reasonCode': serializer.toJson<String>(reasonCode),
      'userMessage': serializer.toJson<String>(userMessage),
      'details': serializer.toJson<String?>(details),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
    };
  }

  ReviewItemRow copyWith({
    String? id,
    String? entityType,
    Value<String?> entityId = const Value.absent(),
    Value<String?> sourceType = const Value.absent(),
    Value<String?> sourceReference = const Value.absent(),
    String? reasonCode,
    String? userMessage,
    Value<String?> details = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
  }) => ReviewItemRow(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    sourceType: sourceType.present ? sourceType.value : this.sourceType,
    sourceReference: sourceReference.present
        ? sourceReference.value
        : this.sourceReference,
    reasonCode: reasonCode ?? this.reasonCode,
    userMessage: userMessage ?? this.userMessage,
    details: details.present ? details.value : this.details,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
  );
  ReviewItemRow copyWithCompanion(ReviewItemsCompanion data) {
    return ReviewItemRow(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceReference: data.sourceReference.present
          ? data.sourceReference.value
          : this.sourceReference,
      reasonCode: data.reasonCode.present
          ? data.reasonCode.value
          : this.reasonCode,
      userMessage: data.userMessage.present
          ? data.userMessage.value
          : this.userMessage,
      details: data.details.present ? data.details.value : this.details,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewItemRow(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('userMessage: $userMessage, ')
          ..write('details: $details, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    sourceType,
    sourceReference,
    reasonCode,
    userMessage,
    details,
    status,
    createdAt,
    resolvedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewItemRow &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.sourceType == this.sourceType &&
          other.sourceReference == this.sourceReference &&
          other.reasonCode == this.reasonCode &&
          other.userMessage == this.userMessage &&
          other.details == this.details &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.resolvedAt == this.resolvedAt);
}

class ReviewItemsCompanion extends UpdateCompanion<ReviewItemRow> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String?> entityId;
  final Value<String?> sourceType;
  final Value<String?> sourceReference;
  final Value<String> reasonCode;
  final Value<String> userMessage;
  final Value<String?> details;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> resolvedAt;
  final Value<int> rowid;
  const ReviewItemsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceReference = const Value.absent(),
    this.reasonCode = const Value.absent(),
    this.userMessage = const Value.absent(),
    this.details = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewItemsCompanion.insert({
    required String id,
    required String entityType,
    this.entityId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceReference = const Value.absent(),
    required String reasonCode,
    required String userMessage,
    this.details = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.resolvedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       reasonCode = Value(reasonCode),
       userMessage = Value(userMessage),
       createdAt = Value(createdAt);
  static Insertable<ReviewItemRow> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? sourceType,
    Expression<String>? sourceReference,
    Expression<String>? reasonCode,
    Expression<String>? userMessage,
    Expression<String>? details,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? resolvedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceReference != null) 'source_reference': sourceReference,
      if (reasonCode != null) 'reason_code': reasonCode,
      if (userMessage != null) 'user_message': userMessage,
      if (details != null) 'details': details,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String?>? entityId,
    Value<String?>? sourceType,
    Value<String?>? sourceReference,
    Value<String>? reasonCode,
    Value<String>? userMessage,
    Value<String?>? details,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? resolvedAt,
    Value<int>? rowid,
  }) {
    return ReviewItemsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      sourceType: sourceType ?? this.sourceType,
      sourceReference: sourceReference ?? this.sourceReference,
      reasonCode: reasonCode ?? this.reasonCode,
      userMessage: userMessage ?? this.userMessage,
      details: details ?? this.details,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceReference.present) {
      map['source_reference'] = Variable<String>(sourceReference.value);
    }
    if (reasonCode.present) {
      map['reason_code'] = Variable<String>(reasonCode.value);
    }
    if (userMessage.present) {
      map['user_message'] = Variable<String>(userMessage.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewItemsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceReference: $sourceReference, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('userMessage: $userMessage, ')
          ..write('details: $details, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StatementsTable extends Statements
    with TableInfo<$StatementsTable, StatementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credit_cards (id)',
    ),
  );
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
    'bank_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES banks (id)',
    ),
  );
  static const VerificationMeta _statementPeriodStartMeta =
      const VerificationMeta('statementPeriodStart');
  @override
  late final GeneratedColumn<DateTime> statementPeriodStart =
      GeneratedColumn<DateTime>(
        'statement_period_start',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statementPeriodEndMeta =
      const VerificationMeta('statementPeriodEnd');
  @override
  late final GeneratedColumn<DateTime> statementPeriodEnd =
      GeneratedColumn<DateTime>(
        'statement_period_end',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statementDateMeta = const VerificationMeta(
    'statementDate',
  );
  @override
  late final GeneratedColumn<DateTime> statementDate =
      GeneratedColumn<DateTime>(
        'statement_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _paymentDueDateMeta = const VerificationMeta(
    'paymentDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDueDate =
      GeneratedColumn<DateTime>(
        'payment_due_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _previousBalanceMinorMeta =
      const VerificationMeta('previousBalanceMinor');
  @override
  late final GeneratedColumn<int> previousBalanceMinor = GeneratedColumn<int>(
    'previous_balance_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalDueMinorMeta = const VerificationMeta(
    'totalDueMinor',
  );
  @override
  late final GeneratedColumn<int> totalDueMinor = GeneratedColumn<int>(
    'total_due_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _minimumDueMinorMeta = const VerificationMeta(
    'minimumDueMinor',
  );
  @override
  late final GeneratedColumn<int> minimumDueMinor = GeneratedColumn<int>(
    'minimum_due_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _encryptedFilePathMeta = const VerificationMeta(
    'encryptedFilePath',
  );
  @override
  late final GeneratedColumn<String> encryptedFilePath =
      GeneratedColumn<String>(
        'encrypted_file_path',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _processingStatusMeta = const VerificationMeta(
    'processingStatus',
  );
  @override
  late final GeneratedColumn<String> processingStatus = GeneratedColumn<String>(
    'processing_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parserIdMeta = const VerificationMeta(
    'parserId',
  );
  @override
  late final GeneratedColumn<String> parserId = GeneratedColumn<String>(
    'parser_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parserVersionMeta = const VerificationMeta(
    'parserVersion',
  );
  @override
  late final GeneratedColumn<String> parserVersion = GeneratedColumn<String>(
    'parser_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    bankId,
    statementPeriodStart,
    statementPeriodEnd,
    statementDate,
    paymentDueDate,
    previousBalanceMinor,
    totalDueMinor,
    minimumDueMinor,
    currencyCode,
    encryptedFilePath,
    fileHash,
    fileSizeBytes,
    processingStatus,
    parserId,
    parserVersion,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'statements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StatementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    }
    if (data.containsKey('bank_id')) {
      context.handle(
        _bankIdMeta,
        bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta),
      );
    }
    if (data.containsKey('statement_period_start')) {
      context.handle(
        _statementPeriodStartMeta,
        statementPeriodStart.isAcceptableOrUnknown(
          data['statement_period_start']!,
          _statementPeriodStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statementPeriodStartMeta);
    }
    if (data.containsKey('statement_period_end')) {
      context.handle(
        _statementPeriodEndMeta,
        statementPeriodEnd.isAcceptableOrUnknown(
          data['statement_period_end']!,
          _statementPeriodEndMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statementPeriodEndMeta);
    }
    if (data.containsKey('statement_date')) {
      context.handle(
        _statementDateMeta,
        statementDate.isAcceptableOrUnknown(
          data['statement_date']!,
          _statementDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statementDateMeta);
    }
    if (data.containsKey('payment_due_date')) {
      context.handle(
        _paymentDueDateMeta,
        paymentDueDate.isAcceptableOrUnknown(
          data['payment_due_date']!,
          _paymentDueDateMeta,
        ),
      );
    }
    if (data.containsKey('previous_balance_minor')) {
      context.handle(
        _previousBalanceMinorMeta,
        previousBalanceMinor.isAcceptableOrUnknown(
          data['previous_balance_minor']!,
          _previousBalanceMinorMeta,
        ),
      );
    }
    if (data.containsKey('total_due_minor')) {
      context.handle(
        _totalDueMinorMeta,
        totalDueMinor.isAcceptableOrUnknown(
          data['total_due_minor']!,
          _totalDueMinorMeta,
        ),
      );
    }
    if (data.containsKey('minimum_due_minor')) {
      context.handle(
        _minimumDueMinorMeta,
        minimumDueMinor.isAcceptableOrUnknown(
          data['minimum_due_minor']!,
          _minimumDueMinorMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('encrypted_file_path')) {
      context.handle(
        _encryptedFilePathMeta,
        encryptedFilePath.isAcceptableOrUnknown(
          data['encrypted_file_path']!,
          _encryptedFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_encryptedFilePathMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('processing_status')) {
      context.handle(
        _processingStatusMeta,
        processingStatus.isAcceptableOrUnknown(
          data['processing_status']!,
          _processingStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processingStatusMeta);
    }
    if (data.containsKey('parser_id')) {
      context.handle(
        _parserIdMeta,
        parserId.isAcceptableOrUnknown(data['parser_id']!, _parserIdMeta),
      );
    }
    if (data.containsKey('parser_version')) {
      context.handle(
        _parserVersionMeta,
        parserVersion.isAcceptableOrUnknown(
          data['parser_version']!,
          _parserVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      ),
      bankId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_id'],
      ),
      statementPeriodStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}statement_period_start'],
      )!,
      statementPeriodEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}statement_period_end'],
      )!,
      statementDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}statement_date'],
      )!,
      paymentDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_due_date'],
      ),
      previousBalanceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}previous_balance_minor'],
      )!,
      totalDueMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_due_minor'],
      )!,
      minimumDueMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_due_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      encryptedFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}encrypted_file_path'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      )!,
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      )!,
      processingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processing_status'],
      )!,
      parserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parser_id'],
      ),
      parserVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parser_version'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StatementsTable createAlias(String alias) {
    return $StatementsTable(attachedDatabase, alias);
  }
}

class StatementRow extends DataClass implements Insertable<StatementRow> {
  final String id;
  final String? cardId;
  final String? bankId;
  final DateTime statementPeriodStart;
  final DateTime statementPeriodEnd;
  final DateTime statementDate;
  final DateTime? paymentDueDate;
  final int previousBalanceMinor;
  final int totalDueMinor;
  final int minimumDueMinor;
  final String currencyCode;
  final String encryptedFilePath;
  final String fileHash;
  final int fileSizeBytes;
  final String processingStatus;
  final String? parserId;
  final String? parserVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StatementRow({
    required this.id,
    this.cardId,
    this.bankId,
    required this.statementPeriodStart,
    required this.statementPeriodEnd,
    required this.statementDate,
    this.paymentDueDate,
    required this.previousBalanceMinor,
    required this.totalDueMinor,
    required this.minimumDueMinor,
    required this.currencyCode,
    required this.encryptedFilePath,
    required this.fileHash,
    required this.fileSizeBytes,
    required this.processingStatus,
    this.parserId,
    this.parserVersion,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || cardId != null) {
      map['card_id'] = Variable<String>(cardId);
    }
    if (!nullToAbsent || bankId != null) {
      map['bank_id'] = Variable<String>(bankId);
    }
    map['statement_period_start'] = Variable<DateTime>(statementPeriodStart);
    map['statement_period_end'] = Variable<DateTime>(statementPeriodEnd);
    map['statement_date'] = Variable<DateTime>(statementDate);
    if (!nullToAbsent || paymentDueDate != null) {
      map['payment_due_date'] = Variable<DateTime>(paymentDueDate);
    }
    map['previous_balance_minor'] = Variable<int>(previousBalanceMinor);
    map['total_due_minor'] = Variable<int>(totalDueMinor);
    map['minimum_due_minor'] = Variable<int>(minimumDueMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['encrypted_file_path'] = Variable<String>(encryptedFilePath);
    map['file_hash'] = Variable<String>(fileHash);
    map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    map['processing_status'] = Variable<String>(processingStatus);
    if (!nullToAbsent || parserId != null) {
      map['parser_id'] = Variable<String>(parserId);
    }
    if (!nullToAbsent || parserVersion != null) {
      map['parser_version'] = Variable<String>(parserVersion);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StatementsCompanion toCompanion(bool nullToAbsent) {
    return StatementsCompanion(
      id: Value(id),
      cardId: cardId == null && nullToAbsent
          ? const Value.absent()
          : Value(cardId),
      bankId: bankId == null && nullToAbsent
          ? const Value.absent()
          : Value(bankId),
      statementPeriodStart: Value(statementPeriodStart),
      statementPeriodEnd: Value(statementPeriodEnd),
      statementDate: Value(statementDate),
      paymentDueDate: paymentDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDueDate),
      previousBalanceMinor: Value(previousBalanceMinor),
      totalDueMinor: Value(totalDueMinor),
      minimumDueMinor: Value(minimumDueMinor),
      currencyCode: Value(currencyCode),
      encryptedFilePath: Value(encryptedFilePath),
      fileHash: Value(fileHash),
      fileSizeBytes: Value(fileSizeBytes),
      processingStatus: Value(processingStatus),
      parserId: parserId == null && nullToAbsent
          ? const Value.absent()
          : Value(parserId),
      parserVersion: parserVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(parserVersion),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StatementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatementRow(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String?>(json['cardId']),
      bankId: serializer.fromJson<String?>(json['bankId']),
      statementPeriodStart: serializer.fromJson<DateTime>(
        json['statementPeriodStart'],
      ),
      statementPeriodEnd: serializer.fromJson<DateTime>(
        json['statementPeriodEnd'],
      ),
      statementDate: serializer.fromJson<DateTime>(json['statementDate']),
      paymentDueDate: serializer.fromJson<DateTime?>(json['paymentDueDate']),
      previousBalanceMinor: serializer.fromJson<int>(
        json['previousBalanceMinor'],
      ),
      totalDueMinor: serializer.fromJson<int>(json['totalDueMinor']),
      minimumDueMinor: serializer.fromJson<int>(json['minimumDueMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      encryptedFilePath: serializer.fromJson<String>(json['encryptedFilePath']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      fileSizeBytes: serializer.fromJson<int>(json['fileSizeBytes']),
      processingStatus: serializer.fromJson<String>(json['processingStatus']),
      parserId: serializer.fromJson<String?>(json['parserId']),
      parserVersion: serializer.fromJson<String?>(json['parserVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String?>(cardId),
      'bankId': serializer.toJson<String?>(bankId),
      'statementPeriodStart': serializer.toJson<DateTime>(statementPeriodStart),
      'statementPeriodEnd': serializer.toJson<DateTime>(statementPeriodEnd),
      'statementDate': serializer.toJson<DateTime>(statementDate),
      'paymentDueDate': serializer.toJson<DateTime?>(paymentDueDate),
      'previousBalanceMinor': serializer.toJson<int>(previousBalanceMinor),
      'totalDueMinor': serializer.toJson<int>(totalDueMinor),
      'minimumDueMinor': serializer.toJson<int>(minimumDueMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'encryptedFilePath': serializer.toJson<String>(encryptedFilePath),
      'fileHash': serializer.toJson<String>(fileHash),
      'fileSizeBytes': serializer.toJson<int>(fileSizeBytes),
      'processingStatus': serializer.toJson<String>(processingStatus),
      'parserId': serializer.toJson<String?>(parserId),
      'parserVersion': serializer.toJson<String?>(parserVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StatementRow copyWith({
    String? id,
    Value<String?> cardId = const Value.absent(),
    Value<String?> bankId = const Value.absent(),
    DateTime? statementPeriodStart,
    DateTime? statementPeriodEnd,
    DateTime? statementDate,
    Value<DateTime?> paymentDueDate = const Value.absent(),
    int? previousBalanceMinor,
    int? totalDueMinor,
    int? minimumDueMinor,
    String? currencyCode,
    String? encryptedFilePath,
    String? fileHash,
    int? fileSizeBytes,
    String? processingStatus,
    Value<String?> parserId = const Value.absent(),
    Value<String?> parserVersion = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => StatementRow(
    id: id ?? this.id,
    cardId: cardId.present ? cardId.value : this.cardId,
    bankId: bankId.present ? bankId.value : this.bankId,
    statementPeriodStart: statementPeriodStart ?? this.statementPeriodStart,
    statementPeriodEnd: statementPeriodEnd ?? this.statementPeriodEnd,
    statementDate: statementDate ?? this.statementDate,
    paymentDueDate: paymentDueDate.present
        ? paymentDueDate.value
        : this.paymentDueDate,
    previousBalanceMinor: previousBalanceMinor ?? this.previousBalanceMinor,
    totalDueMinor: totalDueMinor ?? this.totalDueMinor,
    minimumDueMinor: minimumDueMinor ?? this.minimumDueMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    encryptedFilePath: encryptedFilePath ?? this.encryptedFilePath,
    fileHash: fileHash ?? this.fileHash,
    fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    processingStatus: processingStatus ?? this.processingStatus,
    parserId: parserId.present ? parserId.value : this.parserId,
    parserVersion: parserVersion.present
        ? parserVersion.value
        : this.parserVersion,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StatementRow copyWithCompanion(StatementsCompanion data) {
    return StatementRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      statementPeriodStart: data.statementPeriodStart.present
          ? data.statementPeriodStart.value
          : this.statementPeriodStart,
      statementPeriodEnd: data.statementPeriodEnd.present
          ? data.statementPeriodEnd.value
          : this.statementPeriodEnd,
      statementDate: data.statementDate.present
          ? data.statementDate.value
          : this.statementDate,
      paymentDueDate: data.paymentDueDate.present
          ? data.paymentDueDate.value
          : this.paymentDueDate,
      previousBalanceMinor: data.previousBalanceMinor.present
          ? data.previousBalanceMinor.value
          : this.previousBalanceMinor,
      totalDueMinor: data.totalDueMinor.present
          ? data.totalDueMinor.value
          : this.totalDueMinor,
      minimumDueMinor: data.minimumDueMinor.present
          ? data.minimumDueMinor.value
          : this.minimumDueMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      encryptedFilePath: data.encryptedFilePath.present
          ? data.encryptedFilePath.value
          : this.encryptedFilePath,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      processingStatus: data.processingStatus.present
          ? data.processingStatus.value
          : this.processingStatus,
      parserId: data.parserId.present ? data.parserId.value : this.parserId,
      parserVersion: data.parserVersion.present
          ? data.parserVersion.value
          : this.parserVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatementRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('bankId: $bankId, ')
          ..write('statementPeriodStart: $statementPeriodStart, ')
          ..write('statementPeriodEnd: $statementPeriodEnd, ')
          ..write('statementDate: $statementDate, ')
          ..write('paymentDueDate: $paymentDueDate, ')
          ..write('previousBalanceMinor: $previousBalanceMinor, ')
          ..write('totalDueMinor: $totalDueMinor, ')
          ..write('minimumDueMinor: $minimumDueMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('encryptedFilePath: $encryptedFilePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('processingStatus: $processingStatus, ')
          ..write('parserId: $parserId, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    bankId,
    statementPeriodStart,
    statementPeriodEnd,
    statementDate,
    paymentDueDate,
    previousBalanceMinor,
    totalDueMinor,
    minimumDueMinor,
    currencyCode,
    encryptedFilePath,
    fileHash,
    fileSizeBytes,
    processingStatus,
    parserId,
    parserVersion,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatementRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.bankId == this.bankId &&
          other.statementPeriodStart == this.statementPeriodStart &&
          other.statementPeriodEnd == this.statementPeriodEnd &&
          other.statementDate == this.statementDate &&
          other.paymentDueDate == this.paymentDueDate &&
          other.previousBalanceMinor == this.previousBalanceMinor &&
          other.totalDueMinor == this.totalDueMinor &&
          other.minimumDueMinor == this.minimumDueMinor &&
          other.currencyCode == this.currencyCode &&
          other.encryptedFilePath == this.encryptedFilePath &&
          other.fileHash == this.fileHash &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.processingStatus == this.processingStatus &&
          other.parserId == this.parserId &&
          other.parserVersion == this.parserVersion &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StatementsCompanion extends UpdateCompanion<StatementRow> {
  final Value<String> id;
  final Value<String?> cardId;
  final Value<String?> bankId;
  final Value<DateTime> statementPeriodStart;
  final Value<DateTime> statementPeriodEnd;
  final Value<DateTime> statementDate;
  final Value<DateTime?> paymentDueDate;
  final Value<int> previousBalanceMinor;
  final Value<int> totalDueMinor;
  final Value<int> minimumDueMinor;
  final Value<String> currencyCode;
  final Value<String> encryptedFilePath;
  final Value<String> fileHash;
  final Value<int> fileSizeBytes;
  final Value<String> processingStatus;
  final Value<String?> parserId;
  final Value<String?> parserVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StatementsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.bankId = const Value.absent(),
    this.statementPeriodStart = const Value.absent(),
    this.statementPeriodEnd = const Value.absent(),
    this.statementDate = const Value.absent(),
    this.paymentDueDate = const Value.absent(),
    this.previousBalanceMinor = const Value.absent(),
    this.totalDueMinor = const Value.absent(),
    this.minimumDueMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.encryptedFilePath = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.processingStatus = const Value.absent(),
    this.parserId = const Value.absent(),
    this.parserVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StatementsCompanion.insert({
    required String id,
    this.cardId = const Value.absent(),
    this.bankId = const Value.absent(),
    required DateTime statementPeriodStart,
    required DateTime statementPeriodEnd,
    required DateTime statementDate,
    this.paymentDueDate = const Value.absent(),
    this.previousBalanceMinor = const Value.absent(),
    this.totalDueMinor = const Value.absent(),
    this.minimumDueMinor = const Value.absent(),
    required String currencyCode,
    required String encryptedFilePath,
    required String fileHash,
    this.fileSizeBytes = const Value.absent(),
    required String processingStatus,
    this.parserId = const Value.absent(),
    this.parserVersion = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       statementPeriodStart = Value(statementPeriodStart),
       statementPeriodEnd = Value(statementPeriodEnd),
       statementDate = Value(statementDate),
       currencyCode = Value(currencyCode),
       encryptedFilePath = Value(encryptedFilePath),
       fileHash = Value(fileHash),
       processingStatus = Value(processingStatus),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StatementRow> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? bankId,
    Expression<DateTime>? statementPeriodStart,
    Expression<DateTime>? statementPeriodEnd,
    Expression<DateTime>? statementDate,
    Expression<DateTime>? paymentDueDate,
    Expression<int>? previousBalanceMinor,
    Expression<int>? totalDueMinor,
    Expression<int>? minimumDueMinor,
    Expression<String>? currencyCode,
    Expression<String>? encryptedFilePath,
    Expression<String>? fileHash,
    Expression<int>? fileSizeBytes,
    Expression<String>? processingStatus,
    Expression<String>? parserId,
    Expression<String>? parserVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (bankId != null) 'bank_id': bankId,
      if (statementPeriodStart != null)
        'statement_period_start': statementPeriodStart,
      if (statementPeriodEnd != null)
        'statement_period_end': statementPeriodEnd,
      if (statementDate != null) 'statement_date': statementDate,
      if (paymentDueDate != null) 'payment_due_date': paymentDueDate,
      if (previousBalanceMinor != null)
        'previous_balance_minor': previousBalanceMinor,
      if (totalDueMinor != null) 'total_due_minor': totalDueMinor,
      if (minimumDueMinor != null) 'minimum_due_minor': minimumDueMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (encryptedFilePath != null) 'encrypted_file_path': encryptedFilePath,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (processingStatus != null) 'processing_status': processingStatus,
      if (parserId != null) 'parser_id': parserId,
      if (parserVersion != null) 'parser_version': parserVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StatementsCompanion copyWith({
    Value<String>? id,
    Value<String?>? cardId,
    Value<String?>? bankId,
    Value<DateTime>? statementPeriodStart,
    Value<DateTime>? statementPeriodEnd,
    Value<DateTime>? statementDate,
    Value<DateTime?>? paymentDueDate,
    Value<int>? previousBalanceMinor,
    Value<int>? totalDueMinor,
    Value<int>? minimumDueMinor,
    Value<String>? currencyCode,
    Value<String>? encryptedFilePath,
    Value<String>? fileHash,
    Value<int>? fileSizeBytes,
    Value<String>? processingStatus,
    Value<String?>? parserId,
    Value<String?>? parserVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StatementsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      bankId: bankId ?? this.bankId,
      statementPeriodStart: statementPeriodStart ?? this.statementPeriodStart,
      statementPeriodEnd: statementPeriodEnd ?? this.statementPeriodEnd,
      statementDate: statementDate ?? this.statementDate,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      previousBalanceMinor: previousBalanceMinor ?? this.previousBalanceMinor,
      totalDueMinor: totalDueMinor ?? this.totalDueMinor,
      minimumDueMinor: minimumDueMinor ?? this.minimumDueMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      encryptedFilePath: encryptedFilePath ?? this.encryptedFilePath,
      fileHash: fileHash ?? this.fileHash,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      processingStatus: processingStatus ?? this.processingStatus,
      parserId: parserId ?? this.parserId,
      parserVersion: parserVersion ?? this.parserVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (statementPeriodStart.present) {
      map['statement_period_start'] = Variable<DateTime>(
        statementPeriodStart.value,
      );
    }
    if (statementPeriodEnd.present) {
      map['statement_period_end'] = Variable<DateTime>(
        statementPeriodEnd.value,
      );
    }
    if (statementDate.present) {
      map['statement_date'] = Variable<DateTime>(statementDate.value);
    }
    if (paymentDueDate.present) {
      map['payment_due_date'] = Variable<DateTime>(paymentDueDate.value);
    }
    if (previousBalanceMinor.present) {
      map['previous_balance_minor'] = Variable<int>(previousBalanceMinor.value);
    }
    if (totalDueMinor.present) {
      map['total_due_minor'] = Variable<int>(totalDueMinor.value);
    }
    if (minimumDueMinor.present) {
      map['minimum_due_minor'] = Variable<int>(minimumDueMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (encryptedFilePath.present) {
      map['encrypted_file_path'] = Variable<String>(encryptedFilePath.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (processingStatus.present) {
      map['processing_status'] = Variable<String>(processingStatus.value);
    }
    if (parserId.present) {
      map['parser_id'] = Variable<String>(parserId.value);
    }
    if (parserVersion.present) {
      map['parser_version'] = Variable<String>(parserVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatementsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('bankId: $bankId, ')
          ..write('statementPeriodStart: $statementPeriodStart, ')
          ..write('statementPeriodEnd: $statementPeriodEnd, ')
          ..write('statementDate: $statementDate, ')
          ..write('paymentDueDate: $paymentDueDate, ')
          ..write('previousBalanceMinor: $previousBalanceMinor, ')
          ..write('totalDueMinor: $totalDueMinor, ')
          ..write('minimumDueMinor: $minimumDueMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('encryptedFilePath: $encryptedFilePath, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('processingStatus: $processingStatus, ')
          ..write('parserId: $parserId, ')
          ..write('parserVersion: $parserVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StatementTransactionsTable extends StatementTransactions
    with TableInfo<$StatementTransactionsTable, StatementTransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatementTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statementIdMeta = const VerificationMeta(
    'statementId',
  );
  @override
  late final GeneratedColumn<String> statementId = GeneratedColumn<String>(
    'statement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES statements (id)',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantNormalizedMeta =
      const VerificationMeta('merchantNormalized');
  @override
  late final GeneratedColumn<String> merchantNormalized =
      GeneratedColumn<String>(
        'merchant_normalized',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _postingDateMeta = const VerificationMeta(
    'postingDate',
  );
  @override
  late final GeneratedColumn<DateTime> postingDate = GeneratedColumn<DateTime>(
    'posting_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionTypeMeta = const VerificationMeta(
    'transactionType',
  );
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _matchStatusMeta = const VerificationMeta(
    'matchStatus',
  );
  @override
  late final GeneratedColumn<String> matchStatus = GeneratedColumn<String>(
    'match_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    statementId,
    transactionId,
    description,
    merchantNormalized,
    amountMinor,
    currencyCode,
    transactionDate,
    postingDate,
    transactionType,
    matchStatus,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'statement_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StatementTransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('statement_id')) {
      context.handle(
        _statementIdMeta,
        statementId.isAcceptableOrUnknown(
          data['statement_id']!,
          _statementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statementIdMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('merchant_normalized')) {
      context.handle(
        _merchantNormalizedMeta,
        merchantNormalized.isAcceptableOrUnknown(
          data['merchant_normalized']!,
          _merchantNormalizedMeta,
        ),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('posting_date')) {
      context.handle(
        _postingDateMeta,
        postingDate.isAcceptableOrUnknown(
          data['posting_date']!,
          _postingDateMeta,
        ),
      );
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
        _transactionTypeMeta,
        transactionType.isAcceptableOrUnknown(
          data['transaction_type']!,
          _transactionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('match_status')) {
      context.handle(
        _matchStatusMeta,
        matchStatus.isAcceptableOrUnknown(
          data['match_status']!,
          _matchStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_matchStatusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatementTransactionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatementTransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      statementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statement_id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      merchantNormalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_normalized'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      postingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}posting_date'],
      ),
      transactionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_type'],
      )!,
      matchStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}match_status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StatementTransactionsTable createAlias(String alias) {
    return $StatementTransactionsTable(attachedDatabase, alias);
  }
}

class StatementTransactionRow extends DataClass
    implements Insertable<StatementTransactionRow> {
  final String id;
  final String statementId;
  final String? transactionId;
  final String description;
  final String? merchantNormalized;
  final int amountMinor;
  final String currencyCode;
  final DateTime transactionDate;
  final DateTime? postingDate;
  final String transactionType;
  final String matchStatus;
  final DateTime createdAt;
  const StatementTransactionRow({
    required this.id,
    required this.statementId,
    this.transactionId,
    required this.description,
    this.merchantNormalized,
    required this.amountMinor,
    required this.currencyCode,
    required this.transactionDate,
    this.postingDate,
    required this.transactionType,
    required this.matchStatus,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['statement_id'] = Variable<String>(statementId);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || merchantNormalized != null) {
      map['merchant_normalized'] = Variable<String>(merchantNormalized);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || postingDate != null) {
      map['posting_date'] = Variable<DateTime>(postingDate);
    }
    map['transaction_type'] = Variable<String>(transactionType);
    map['match_status'] = Variable<String>(matchStatus);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StatementTransactionsCompanion toCompanion(bool nullToAbsent) {
    return StatementTransactionsCompanion(
      id: Value(id),
      statementId: Value(statementId),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      description: Value(description),
      merchantNormalized: merchantNormalized == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantNormalized),
      amountMinor: Value(amountMinor),
      currencyCode: Value(currencyCode),
      transactionDate: Value(transactionDate),
      postingDate: postingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(postingDate),
      transactionType: Value(transactionType),
      matchStatus: Value(matchStatus),
      createdAt: Value(createdAt),
    );
  }

  factory StatementTransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatementTransactionRow(
      id: serializer.fromJson<String>(json['id']),
      statementId: serializer.fromJson<String>(json['statementId']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      description: serializer.fromJson<String>(json['description']),
      merchantNormalized: serializer.fromJson<String?>(
        json['merchantNormalized'],
      ),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      postingDate: serializer.fromJson<DateTime?>(json['postingDate']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      matchStatus: serializer.fromJson<String>(json['matchStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'statementId': serializer.toJson<String>(statementId),
      'transactionId': serializer.toJson<String?>(transactionId),
      'description': serializer.toJson<String>(description),
      'merchantNormalized': serializer.toJson<String?>(merchantNormalized),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'postingDate': serializer.toJson<DateTime?>(postingDate),
      'transactionType': serializer.toJson<String>(transactionType),
      'matchStatus': serializer.toJson<String>(matchStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StatementTransactionRow copyWith({
    String? id,
    String? statementId,
    Value<String?> transactionId = const Value.absent(),
    String? description,
    Value<String?> merchantNormalized = const Value.absent(),
    int? amountMinor,
    String? currencyCode,
    DateTime? transactionDate,
    Value<DateTime?> postingDate = const Value.absent(),
    String? transactionType,
    String? matchStatus,
    DateTime? createdAt,
  }) => StatementTransactionRow(
    id: id ?? this.id,
    statementId: statementId ?? this.statementId,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    description: description ?? this.description,
    merchantNormalized: merchantNormalized.present
        ? merchantNormalized.value
        : this.merchantNormalized,
    amountMinor: amountMinor ?? this.amountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    transactionDate: transactionDate ?? this.transactionDate,
    postingDate: postingDate.present ? postingDate.value : this.postingDate,
    transactionType: transactionType ?? this.transactionType,
    matchStatus: matchStatus ?? this.matchStatus,
    createdAt: createdAt ?? this.createdAt,
  );
  StatementTransactionRow copyWithCompanion(
    StatementTransactionsCompanion data,
  ) {
    return StatementTransactionRow(
      id: data.id.present ? data.id.value : this.id,
      statementId: data.statementId.present
          ? data.statementId.value
          : this.statementId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      description: data.description.present
          ? data.description.value
          : this.description,
      merchantNormalized: data.merchantNormalized.present
          ? data.merchantNormalized.value
          : this.merchantNormalized,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      postingDate: data.postingDate.present
          ? data.postingDate.value
          : this.postingDate,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      matchStatus: data.matchStatus.present
          ? data.matchStatus.value
          : this.matchStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatementTransactionRow(')
          ..write('id: $id, ')
          ..write('statementId: $statementId, ')
          ..write('transactionId: $transactionId, ')
          ..write('description: $description, ')
          ..write('merchantNormalized: $merchantNormalized, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('postingDate: $postingDate, ')
          ..write('transactionType: $transactionType, ')
          ..write('matchStatus: $matchStatus, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    statementId,
    transactionId,
    description,
    merchantNormalized,
    amountMinor,
    currencyCode,
    transactionDate,
    postingDate,
    transactionType,
    matchStatus,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatementTransactionRow &&
          other.id == this.id &&
          other.statementId == this.statementId &&
          other.transactionId == this.transactionId &&
          other.description == this.description &&
          other.merchantNormalized == this.merchantNormalized &&
          other.amountMinor == this.amountMinor &&
          other.currencyCode == this.currencyCode &&
          other.transactionDate == this.transactionDate &&
          other.postingDate == this.postingDate &&
          other.transactionType == this.transactionType &&
          other.matchStatus == this.matchStatus &&
          other.createdAt == this.createdAt);
}

class StatementTransactionsCompanion
    extends UpdateCompanion<StatementTransactionRow> {
  final Value<String> id;
  final Value<String> statementId;
  final Value<String?> transactionId;
  final Value<String> description;
  final Value<String?> merchantNormalized;
  final Value<int> amountMinor;
  final Value<String> currencyCode;
  final Value<DateTime> transactionDate;
  final Value<DateTime?> postingDate;
  final Value<String> transactionType;
  final Value<String> matchStatus;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StatementTransactionsCompanion({
    this.id = const Value.absent(),
    this.statementId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.description = const Value.absent(),
    this.merchantNormalized = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.postingDate = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.matchStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StatementTransactionsCompanion.insert({
    required String id,
    required String statementId,
    this.transactionId = const Value.absent(),
    required String description,
    this.merchantNormalized = const Value.absent(),
    required int amountMinor,
    required String currencyCode,
    required DateTime transactionDate,
    this.postingDate = const Value.absent(),
    required String transactionType,
    required String matchStatus,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       statementId = Value(statementId),
       description = Value(description),
       amountMinor = Value(amountMinor),
       currencyCode = Value(currencyCode),
       transactionDate = Value(transactionDate),
       transactionType = Value(transactionType),
       matchStatus = Value(matchStatus),
       createdAt = Value(createdAt);
  static Insertable<StatementTransactionRow> custom({
    Expression<String>? id,
    Expression<String>? statementId,
    Expression<String>? transactionId,
    Expression<String>? description,
    Expression<String>? merchantNormalized,
    Expression<int>? amountMinor,
    Expression<String>? currencyCode,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? postingDate,
    Expression<String>? transactionType,
    Expression<String>? matchStatus,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (statementId != null) 'statement_id': statementId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (description != null) 'description': description,
      if (merchantNormalized != null) 'merchant_normalized': merchantNormalized,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (postingDate != null) 'posting_date': postingDate,
      if (transactionType != null) 'transaction_type': transactionType,
      if (matchStatus != null) 'match_status': matchStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StatementTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? statementId,
    Value<String?>? transactionId,
    Value<String>? description,
    Value<String?>? merchantNormalized,
    Value<int>? amountMinor,
    Value<String>? currencyCode,
    Value<DateTime>? transactionDate,
    Value<DateTime?>? postingDate,
    Value<String>? transactionType,
    Value<String>? matchStatus,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StatementTransactionsCompanion(
      id: id ?? this.id,
      statementId: statementId ?? this.statementId,
      transactionId: transactionId ?? this.transactionId,
      description: description ?? this.description,
      merchantNormalized: merchantNormalized ?? this.merchantNormalized,
      amountMinor: amountMinor ?? this.amountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      transactionDate: transactionDate ?? this.transactionDate,
      postingDate: postingDate ?? this.postingDate,
      transactionType: transactionType ?? this.transactionType,
      matchStatus: matchStatus ?? this.matchStatus,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (statementId.present) {
      map['statement_id'] = Variable<String>(statementId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (merchantNormalized.present) {
      map['merchant_normalized'] = Variable<String>(merchantNormalized.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (postingDate.present) {
      map['posting_date'] = Variable<DateTime>(postingDate.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (matchStatus.present) {
      map['match_status'] = Variable<String>(matchStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatementTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('statementId: $statementId, ')
          ..write('transactionId: $transactionId, ')
          ..write('description: $description, ')
          ..write('merchantNormalized: $merchantNormalized, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('postingDate: $postingDate, ')
          ..write('transactionType: $transactionType, ')
          ..write('matchStatus: $matchStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashbackEntriesTable extends CashbackEntries
    with TableInfo<$CashbackEntriesTable, CashbackEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashbackEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credit_cards (id)',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedAtMeta = const VerificationMeta(
    'earnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> earnedAt = GeneratedColumn<DateTime>(
    'earned_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditedAtMeta = const VerificationMeta(
    'creditedAt',
  );
  @override
  late final GeneratedColumn<DateTime> creditedAt = GeneratedColumn<DateTime>(
    'credited_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reversedAtMeta = const VerificationMeta(
    'reversedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reversedAt = GeneratedColumn<DateTime>(
    'reversed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    transactionId,
    amountMinor,
    currencyCode,
    status,
    earnedAt,
    creditedAt,
    reversedAt,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cashback_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashbackEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('earned_at')) {
      context.handle(
        _earnedAtMeta,
        earnedAt.isAcceptableOrUnknown(data['earned_at']!, _earnedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedAtMeta);
    }
    if (data.containsKey('credited_at')) {
      context.handle(
        _creditedAtMeta,
        creditedAt.isAcceptableOrUnknown(data['credited_at']!, _creditedAtMeta),
      );
    }
    if (data.containsKey('reversed_at')) {
      context.handle(
        _reversedAtMeta,
        reversedAt.isAcceptableOrUnknown(data['reversed_at']!, _reversedAtMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashbackEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashbackEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      earnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}earned_at'],
      )!,
      creditedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}credited_at'],
      ),
      reversedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reversed_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CashbackEntriesTable createAlias(String alias) {
    return $CashbackEntriesTable(attachedDatabase, alias);
  }
}

class CashbackEntryRow extends DataClass
    implements Insertable<CashbackEntryRow> {
  final String id;
  final String cardId;
  final String? transactionId;
  final int amountMinor;
  final String currencyCode;
  final String status;
  final DateTime earnedAt;
  final DateTime? creditedAt;
  final DateTime? reversedAt;
  final String? notes;
  final DateTime createdAt;
  const CashbackEntryRow({
    required this.id,
    required this.cardId,
    this.transactionId,
    required this.amountMinor,
    required this.currencyCode,
    required this.status,
    required this.earnedAt,
    this.creditedAt,
    this.reversedAt,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['status'] = Variable<String>(status);
    map['earned_at'] = Variable<DateTime>(earnedAt);
    if (!nullToAbsent || creditedAt != null) {
      map['credited_at'] = Variable<DateTime>(creditedAt);
    }
    if (!nullToAbsent || reversedAt != null) {
      map['reversed_at'] = Variable<DateTime>(reversedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CashbackEntriesCompanion toCompanion(bool nullToAbsent) {
    return CashbackEntriesCompanion(
      id: Value(id),
      cardId: Value(cardId),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      amountMinor: Value(amountMinor),
      currencyCode: Value(currencyCode),
      status: Value(status),
      earnedAt: Value(earnedAt),
      creditedAt: creditedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(creditedAt),
      reversedAt: reversedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reversedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory CashbackEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashbackEntryRow(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      status: serializer.fromJson<String>(json['status']),
      earnedAt: serializer.fromJson<DateTime>(json['earnedAt']),
      creditedAt: serializer.fromJson<DateTime?>(json['creditedAt']),
      reversedAt: serializer.fromJson<DateTime?>(json['reversedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'transactionId': serializer.toJson<String?>(transactionId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'status': serializer.toJson<String>(status),
      'earnedAt': serializer.toJson<DateTime>(earnedAt),
      'creditedAt': serializer.toJson<DateTime?>(creditedAt),
      'reversedAt': serializer.toJson<DateTime?>(reversedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CashbackEntryRow copyWith({
    String? id,
    String? cardId,
    Value<String?> transactionId = const Value.absent(),
    int? amountMinor,
    String? currencyCode,
    String? status,
    DateTime? earnedAt,
    Value<DateTime?> creditedAt = const Value.absent(),
    Value<DateTime?> reversedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => CashbackEntryRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    amountMinor: amountMinor ?? this.amountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    status: status ?? this.status,
    earnedAt: earnedAt ?? this.earnedAt,
    creditedAt: creditedAt.present ? creditedAt.value : this.creditedAt,
    reversedAt: reversedAt.present ? reversedAt.value : this.reversedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  CashbackEntryRow copyWithCompanion(CashbackEntriesCompanion data) {
    return CashbackEntryRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      status: data.status.present ? data.status.value : this.status,
      earnedAt: data.earnedAt.present ? data.earnedAt.value : this.earnedAt,
      creditedAt: data.creditedAt.present
          ? data.creditedAt.value
          : this.creditedAt,
      reversedAt: data.reversedAt.present
          ? data.reversedAt.value
          : this.reversedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashbackEntryRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('transactionId: $transactionId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('status: $status, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('creditedAt: $creditedAt, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    transactionId,
    amountMinor,
    currencyCode,
    status,
    earnedAt,
    creditedAt,
    reversedAt,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashbackEntryRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.transactionId == this.transactionId &&
          other.amountMinor == this.amountMinor &&
          other.currencyCode == this.currencyCode &&
          other.status == this.status &&
          other.earnedAt == this.earnedAt &&
          other.creditedAt == this.creditedAt &&
          other.reversedAt == this.reversedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class CashbackEntriesCompanion extends UpdateCompanion<CashbackEntryRow> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String?> transactionId;
  final Value<int> amountMinor;
  final Value<String> currencyCode;
  final Value<String> status;
  final Value<DateTime> earnedAt;
  final Value<DateTime?> creditedAt;
  final Value<DateTime?> reversedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CashbackEntriesCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.status = const Value.absent(),
    this.earnedAt = const Value.absent(),
    this.creditedAt = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashbackEntriesCompanion.insert({
    required String id,
    required String cardId,
    this.transactionId = const Value.absent(),
    required int amountMinor,
    required String currencyCode,
    required String status,
    required DateTime earnedAt,
    this.creditedAt = const Value.absent(),
    this.reversedAt = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       amountMinor = Value(amountMinor),
       currencyCode = Value(currencyCode),
       status = Value(status),
       earnedAt = Value(earnedAt),
       createdAt = Value(createdAt);
  static Insertable<CashbackEntryRow> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? transactionId,
    Expression<int>? amountMinor,
    Expression<String>? currencyCode,
    Expression<String>? status,
    Expression<DateTime>? earnedAt,
    Expression<DateTime>? creditedAt,
    Expression<DateTime>? reversedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (status != null) 'status': status,
      if (earnedAt != null) 'earned_at': earnedAt,
      if (creditedAt != null) 'credited_at': creditedAt,
      if (reversedAt != null) 'reversed_at': reversedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashbackEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? cardId,
    Value<String?>? transactionId,
    Value<int>? amountMinor,
    Value<String>? currencyCode,
    Value<String>? status,
    Value<DateTime>? earnedAt,
    Value<DateTime?>? creditedAt,
    Value<DateTime?>? reversedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CashbackEntriesCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      transactionId: transactionId ?? this.transactionId,
      amountMinor: amountMinor ?? this.amountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      status: status ?? this.status,
      earnedAt: earnedAt ?? this.earnedAt,
      creditedAt: creditedAt ?? this.creditedAt,
      reversedAt: reversedAt ?? this.reversedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (earnedAt.present) {
      map['earned_at'] = Variable<DateTime>(earnedAt.value);
    }
    if (creditedAt.present) {
      map['credited_at'] = Variable<DateTime>(creditedAt.value);
    }
    if (reversedAt.present) {
      map['reversed_at'] = Variable<DateTime>(reversedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashbackEntriesCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('transactionId: $transactionId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('status: $status, ')
          ..write('earnedAt: $earnedAt, ')
          ..write('creditedAt: $creditedAt, ')
          ..write('reversedAt: $reversedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashbackRulesTable extends CashbackRules
    with TableInfo<$CashbackRulesTable, CashbackRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashbackRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credit_cards (id)',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateBasisPointsMeta = const VerificationMeta(
    'rateBasisPoints',
  );
  @override
  late final GeneratedColumn<int> rateBasisPoints = GeneratedColumn<int>(
    'rate_basis_points',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flatAmountMinorMeta = const VerificationMeta(
    'flatAmountMinor',
  );
  @override
  late final GeneratedColumn<int> flatAmountMinor = GeneratedColumn<int>(
    'flat_amount_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _merchantContainsMeta = const VerificationMeta(
    'merchantContains',
  );
  @override
  late final GeneratedColumn<String> merchantContains = GeneratedColumn<String>(
    'merchant_contains',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyCapMinorMeta = const VerificationMeta(
    'monthlyCapMinor',
  );
  @override
  late final GeneratedColumn<int> monthlyCapMinor = GeneratedColumn<int>(
    'monthly_cap_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    kind,
    rateBasisPoints,
    flatAmountMinor,
    categoryId,
    merchantContains,
    monthlyCapMinor,
    currencyCode,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cashback_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashbackRuleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('rate_basis_points')) {
      context.handle(
        _rateBasisPointsMeta,
        rateBasisPoints.isAcceptableOrUnknown(
          data['rate_basis_points']!,
          _rateBasisPointsMeta,
        ),
      );
    }
    if (data.containsKey('flat_amount_minor')) {
      context.handle(
        _flatAmountMinorMeta,
        flatAmountMinor.isAcceptableOrUnknown(
          data['flat_amount_minor']!,
          _flatAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('merchant_contains')) {
      context.handle(
        _merchantContainsMeta,
        merchantContains.isAcceptableOrUnknown(
          data['merchant_contains']!,
          _merchantContainsMeta,
        ),
      );
    }
    if (data.containsKey('monthly_cap_minor')) {
      context.handle(
        _monthlyCapMinorMeta,
        monthlyCapMinor.isAcceptableOrUnknown(
          data['monthly_cap_minor']!,
          _monthlyCapMinorMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashbackRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashbackRuleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      rateBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rate_basis_points'],
      ),
      flatAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flat_amount_minor'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      merchantContains: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant_contains'],
      ),
      monthlyCapMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_cap_minor'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CashbackRulesTable createAlias(String alias) {
    return $CashbackRulesTable(attachedDatabase, alias);
  }
}

class CashbackRuleRow extends DataClass implements Insertable<CashbackRuleRow> {
  final String id;
  final String cardId;
  final String kind;
  final int? rateBasisPoints;
  final int? flatAmountMinor;
  final String? categoryId;
  final String? merchantContains;
  final int? monthlyCapMinor;
  final String currencyCode;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CashbackRuleRow({
    required this.id,
    required this.cardId,
    required this.kind,
    this.rateBasisPoints,
    this.flatAmountMinor,
    this.categoryId,
    this.merchantContains,
    this.monthlyCapMinor,
    required this.currencyCode,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || rateBasisPoints != null) {
      map['rate_basis_points'] = Variable<int>(rateBasisPoints);
    }
    if (!nullToAbsent || flatAmountMinor != null) {
      map['flat_amount_minor'] = Variable<int>(flatAmountMinor);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || merchantContains != null) {
      map['merchant_contains'] = Variable<String>(merchantContains);
    }
    if (!nullToAbsent || monthlyCapMinor != null) {
      map['monthly_cap_minor'] = Variable<int>(monthlyCapMinor);
    }
    map['currency_code'] = Variable<String>(currencyCode);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CashbackRulesCompanion toCompanion(bool nullToAbsent) {
    return CashbackRulesCompanion(
      id: Value(id),
      cardId: Value(cardId),
      kind: Value(kind),
      rateBasisPoints: rateBasisPoints == null && nullToAbsent
          ? const Value.absent()
          : Value(rateBasisPoints),
      flatAmountMinor: flatAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(flatAmountMinor),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      merchantContains: merchantContains == null && nullToAbsent
          ? const Value.absent()
          : Value(merchantContains),
      monthlyCapMinor: monthlyCapMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyCapMinor),
      currencyCode: Value(currencyCode),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CashbackRuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashbackRuleRow(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      kind: serializer.fromJson<String>(json['kind']),
      rateBasisPoints: serializer.fromJson<int?>(json['rateBasisPoints']),
      flatAmountMinor: serializer.fromJson<int?>(json['flatAmountMinor']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      merchantContains: serializer.fromJson<String?>(json['merchantContains']),
      monthlyCapMinor: serializer.fromJson<int?>(json['monthlyCapMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'kind': serializer.toJson<String>(kind),
      'rateBasisPoints': serializer.toJson<int?>(rateBasisPoints),
      'flatAmountMinor': serializer.toJson<int?>(flatAmountMinor),
      'categoryId': serializer.toJson<String?>(categoryId),
      'merchantContains': serializer.toJson<String?>(merchantContains),
      'monthlyCapMinor': serializer.toJson<int?>(monthlyCapMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CashbackRuleRow copyWith({
    String? id,
    String? cardId,
    String? kind,
    Value<int?> rateBasisPoints = const Value.absent(),
    Value<int?> flatAmountMinor = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> merchantContains = const Value.absent(),
    Value<int?> monthlyCapMinor = const Value.absent(),
    String? currencyCode,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CashbackRuleRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    kind: kind ?? this.kind,
    rateBasisPoints: rateBasisPoints.present
        ? rateBasisPoints.value
        : this.rateBasisPoints,
    flatAmountMinor: flatAmountMinor.present
        ? flatAmountMinor.value
        : this.flatAmountMinor,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    merchantContains: merchantContains.present
        ? merchantContains.value
        : this.merchantContains,
    monthlyCapMinor: monthlyCapMinor.present
        ? monthlyCapMinor.value
        : this.monthlyCapMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CashbackRuleRow copyWithCompanion(CashbackRulesCompanion data) {
    return CashbackRuleRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      kind: data.kind.present ? data.kind.value : this.kind,
      rateBasisPoints: data.rateBasisPoints.present
          ? data.rateBasisPoints.value
          : this.rateBasisPoints,
      flatAmountMinor: data.flatAmountMinor.present
          ? data.flatAmountMinor.value
          : this.flatAmountMinor,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      merchantContains: data.merchantContains.present
          ? data.merchantContains.value
          : this.merchantContains,
      monthlyCapMinor: data.monthlyCapMinor.present
          ? data.monthlyCapMinor.value
          : this.monthlyCapMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashbackRuleRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('kind: $kind, ')
          ..write('rateBasisPoints: $rateBasisPoints, ')
          ..write('flatAmountMinor: $flatAmountMinor, ')
          ..write('categoryId: $categoryId, ')
          ..write('merchantContains: $merchantContains, ')
          ..write('monthlyCapMinor: $monthlyCapMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    kind,
    rateBasisPoints,
    flatAmountMinor,
    categoryId,
    merchantContains,
    monthlyCapMinor,
    currencyCode,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashbackRuleRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.kind == this.kind &&
          other.rateBasisPoints == this.rateBasisPoints &&
          other.flatAmountMinor == this.flatAmountMinor &&
          other.categoryId == this.categoryId &&
          other.merchantContains == this.merchantContains &&
          other.monthlyCapMinor == this.monthlyCapMinor &&
          other.currencyCode == this.currencyCode &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CashbackRulesCompanion extends UpdateCompanion<CashbackRuleRow> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> kind;
  final Value<int?> rateBasisPoints;
  final Value<int?> flatAmountMinor;
  final Value<String?> categoryId;
  final Value<String?> merchantContains;
  final Value<int?> monthlyCapMinor;
  final Value<String> currencyCode;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CashbackRulesCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.kind = const Value.absent(),
    this.rateBasisPoints = const Value.absent(),
    this.flatAmountMinor = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.merchantContains = const Value.absent(),
    this.monthlyCapMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashbackRulesCompanion.insert({
    required String id,
    required String cardId,
    required String kind,
    this.rateBasisPoints = const Value.absent(),
    this.flatAmountMinor = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.merchantContains = const Value.absent(),
    this.monthlyCapMinor = const Value.absent(),
    required String currencyCode,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       kind = Value(kind),
       currencyCode = Value(currencyCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CashbackRuleRow> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? kind,
    Expression<int>? rateBasisPoints,
    Expression<int>? flatAmountMinor,
    Expression<String>? categoryId,
    Expression<String>? merchantContains,
    Expression<int>? monthlyCapMinor,
    Expression<String>? currencyCode,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (kind != null) 'kind': kind,
      if (rateBasisPoints != null) 'rate_basis_points': rateBasisPoints,
      if (flatAmountMinor != null) 'flat_amount_minor': flatAmountMinor,
      if (categoryId != null) 'category_id': categoryId,
      if (merchantContains != null) 'merchant_contains': merchantContains,
      if (monthlyCapMinor != null) 'monthly_cap_minor': monthlyCapMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashbackRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? cardId,
    Value<String>? kind,
    Value<int?>? rateBasisPoints,
    Value<int?>? flatAmountMinor,
    Value<String?>? categoryId,
    Value<String?>? merchantContains,
    Value<int?>? monthlyCapMinor,
    Value<String>? currencyCode,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CashbackRulesCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      kind: kind ?? this.kind,
      rateBasisPoints: rateBasisPoints ?? this.rateBasisPoints,
      flatAmountMinor: flatAmountMinor ?? this.flatAmountMinor,
      categoryId: categoryId ?? this.categoryId,
      merchantContains: merchantContains ?? this.merchantContains,
      monthlyCapMinor: monthlyCapMinor ?? this.monthlyCapMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (rateBasisPoints.present) {
      map['rate_basis_points'] = Variable<int>(rateBasisPoints.value);
    }
    if (flatAmountMinor.present) {
      map['flat_amount_minor'] = Variable<int>(flatAmountMinor.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (merchantContains.present) {
      map['merchant_contains'] = Variable<String>(merchantContains.value);
    }
    if (monthlyCapMinor.present) {
      map['monthly_cap_minor'] = Variable<int>(monthlyCapMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashbackRulesCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('kind: $kind, ')
          ..write('rateBasisPoints: $rateBasisPoints, ')
          ..write('flatAmountMinor: $flatAmountMinor, ')
          ..write('categoryId: $categoryId, ')
          ..write('merchantContains: $merchantContains, ')
          ..write('monthlyCapMinor: $monthlyCapMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardAccountsTable extends RewardAccounts
    with TableInfo<$RewardAccountsTable, RewardAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES credit_cards (id)',
    ),
  );
  static const VerificationMeta _programmeNameMeta = const VerificationMeta(
    'programmeName',
  );
  @override
  late final GeneratedColumn<String> programmeName = GeneratedColumn<String>(
    'programme_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentPointsMeta = const VerificationMeta(
    'currentPoints',
  );
  @override
  late final GeneratedColumn<int> currentPoints = GeneratedColumn<int>(
    'current_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _estimatedValueMinorMeta =
      const VerificationMeta('estimatedValueMinor');
  @override
  late final GeneratedColumn<int> estimatedValueMinor = GeneratedColumn<int>(
    'estimated_value_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    programmeName,
    currentPoints,
    estimatedValueMinor,
    currencyCode,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardAccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('programme_name')) {
      context.handle(
        _programmeNameMeta,
        programmeName.isAcceptableOrUnknown(
          data['programme_name']!,
          _programmeNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_programmeNameMeta);
    }
    if (data.containsKey('current_points')) {
      context.handle(
        _currentPointsMeta,
        currentPoints.isAcceptableOrUnknown(
          data['current_points']!,
          _currentPointsMeta,
        ),
      );
    }
    if (data.containsKey('estimated_value_minor')) {
      context.handle(
        _estimatedValueMinorMeta,
        estimatedValueMinor.isAcceptableOrUnknown(
          data['estimated_value_minor']!,
          _estimatedValueMinorMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RewardAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardAccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      programmeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}programme_name'],
      )!,
      currentPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_points'],
      )!,
      estimatedValueMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_value_minor'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RewardAccountsTable createAlias(String alias) {
    return $RewardAccountsTable(attachedDatabase, alias);
  }
}

class RewardAccountRow extends DataClass
    implements Insertable<RewardAccountRow> {
  final String id;
  final String cardId;
  final String programmeName;
  final int currentPoints;
  final int? estimatedValueMinor;
  final String? currencyCode;
  final DateTime updatedAt;
  const RewardAccountRow({
    required this.id,
    required this.cardId,
    required this.programmeName,
    required this.currentPoints,
    this.estimatedValueMinor,
    this.currencyCode,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['card_id'] = Variable<String>(cardId);
    map['programme_name'] = Variable<String>(programmeName);
    map['current_points'] = Variable<int>(currentPoints);
    if (!nullToAbsent || estimatedValueMinor != null) {
      map['estimated_value_minor'] = Variable<int>(estimatedValueMinor);
    }
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RewardAccountsCompanion toCompanion(bool nullToAbsent) {
    return RewardAccountsCompanion(
      id: Value(id),
      cardId: Value(cardId),
      programmeName: Value(programmeName),
      currentPoints: Value(currentPoints),
      estimatedValueMinor: estimatedValueMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedValueMinor),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      updatedAt: Value(updatedAt),
    );
  }

  factory RewardAccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardAccountRow(
      id: serializer.fromJson<String>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      programmeName: serializer.fromJson<String>(json['programmeName']),
      currentPoints: serializer.fromJson<int>(json['currentPoints']),
      estimatedValueMinor: serializer.fromJson<int?>(
        json['estimatedValueMinor'],
      ),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'cardId': serializer.toJson<String>(cardId),
      'programmeName': serializer.toJson<String>(programmeName),
      'currentPoints': serializer.toJson<int>(currentPoints),
      'estimatedValueMinor': serializer.toJson<int?>(estimatedValueMinor),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RewardAccountRow copyWith({
    String? id,
    String? cardId,
    String? programmeName,
    int? currentPoints,
    Value<int?> estimatedValueMinor = const Value.absent(),
    Value<String?> currencyCode = const Value.absent(),
    DateTime? updatedAt,
  }) => RewardAccountRow(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    programmeName: programmeName ?? this.programmeName,
    currentPoints: currentPoints ?? this.currentPoints,
    estimatedValueMinor: estimatedValueMinor.present
        ? estimatedValueMinor.value
        : this.estimatedValueMinor,
    currencyCode: currencyCode.present ? currencyCode.value : this.currencyCode,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RewardAccountRow copyWithCompanion(RewardAccountsCompanion data) {
    return RewardAccountRow(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      programmeName: data.programmeName.present
          ? data.programmeName.value
          : this.programmeName,
      currentPoints: data.currentPoints.present
          ? data.currentPoints.value
          : this.currentPoints,
      estimatedValueMinor: data.estimatedValueMinor.present
          ? data.estimatedValueMinor.value
          : this.estimatedValueMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardAccountRow(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('programmeName: $programmeName, ')
          ..write('currentPoints: $currentPoints, ')
          ..write('estimatedValueMinor: $estimatedValueMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cardId,
    programmeName,
    currentPoints,
    estimatedValueMinor,
    currencyCode,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardAccountRow &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.programmeName == this.programmeName &&
          other.currentPoints == this.currentPoints &&
          other.estimatedValueMinor == this.estimatedValueMinor &&
          other.currencyCode == this.currencyCode &&
          other.updatedAt == this.updatedAt);
}

class RewardAccountsCompanion extends UpdateCompanion<RewardAccountRow> {
  final Value<String> id;
  final Value<String> cardId;
  final Value<String> programmeName;
  final Value<int> currentPoints;
  final Value<int?> estimatedValueMinor;
  final Value<String?> currencyCode;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RewardAccountsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.programmeName = const Value.absent(),
    this.currentPoints = const Value.absent(),
    this.estimatedValueMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardAccountsCompanion.insert({
    required String id,
    required String cardId,
    required String programmeName,
    this.currentPoints = const Value.absent(),
    this.estimatedValueMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       cardId = Value(cardId),
       programmeName = Value(programmeName),
       updatedAt = Value(updatedAt);
  static Insertable<RewardAccountRow> custom({
    Expression<String>? id,
    Expression<String>? cardId,
    Expression<String>? programmeName,
    Expression<int>? currentPoints,
    Expression<int>? estimatedValueMinor,
    Expression<String>? currencyCode,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (programmeName != null) 'programme_name': programmeName,
      if (currentPoints != null) 'current_points': currentPoints,
      if (estimatedValueMinor != null)
        'estimated_value_minor': estimatedValueMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? cardId,
    Value<String>? programmeName,
    Value<int>? currentPoints,
    Value<int?>? estimatedValueMinor,
    Value<String?>? currencyCode,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RewardAccountsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      programmeName: programmeName ?? this.programmeName,
      currentPoints: currentPoints ?? this.currentPoints,
      estimatedValueMinor: estimatedValueMinor ?? this.estimatedValueMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (programmeName.present) {
      map['programme_name'] = Variable<String>(programmeName.value);
    }
    if (currentPoints.present) {
      map['current_points'] = Variable<int>(currentPoints.value);
    }
    if (estimatedValueMinor.present) {
      map['estimated_value_minor'] = Variable<int>(estimatedValueMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardAccountsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('programmeName: $programmeName, ')
          ..write('currentPoints: $currentPoints, ')
          ..write('estimatedValueMinor: $estimatedValueMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardEntriesTable extends RewardEntries
    with TableInfo<$RewardEntriesTable, RewardEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardAccountIdMeta = const VerificationMeta(
    'rewardAccountId',
  );
  @override
  late final GeneratedColumn<String> rewardAccountId = GeneratedColumn<String>(
    'reward_account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reward_accounts (id)',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryTypeMeta = const VerificationMeta(
    'entryType',
  );
  @override
  late final GeneratedColumn<String> entryType = GeneratedColumn<String>(
    'entry_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rewardAccountId,
    transactionId,
    points,
    entryType,
    description,
    expiresAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reward_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reward_account_id')) {
      context.handle(
        _rewardAccountIdMeta,
        rewardAccountId.isAcceptableOrUnknown(
          data['reward_account_id']!,
          _rewardAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardAccountIdMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    } else if (isInserting) {
      context.missing(_pointsMeta);
    }
    if (data.containsKey('entry_type')) {
      context.handle(
        _entryTypeMeta,
        entryType.isAcceptableOrUnknown(data['entry_type']!, _entryTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entryTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RewardEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rewardAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_account_id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      entryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RewardEntriesTable createAlias(String alias) {
    return $RewardEntriesTable(attachedDatabase, alias);
  }
}

class RewardEntryRow extends DataClass implements Insertable<RewardEntryRow> {
  final String id;
  final String rewardAccountId;
  final String? transactionId;
  final int points;
  final String entryType;
  final String? description;
  final DateTime? expiresAt;
  final DateTime createdAt;
  const RewardEntryRow({
    required this.id,
    required this.rewardAccountId,
    this.transactionId,
    required this.points,
    required this.entryType,
    this.description,
    this.expiresAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['reward_account_id'] = Variable<String>(rewardAccountId);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['points'] = Variable<int>(points);
    map['entry_type'] = Variable<String>(entryType);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RewardEntriesCompanion toCompanion(bool nullToAbsent) {
    return RewardEntriesCompanion(
      id: Value(id),
      rewardAccountId: Value(rewardAccountId),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      points: Value(points),
      entryType: Value(entryType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      createdAt: Value(createdAt),
    );
  }

  factory RewardEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardEntryRow(
      id: serializer.fromJson<String>(json['id']),
      rewardAccountId: serializer.fromJson<String>(json['rewardAccountId']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      points: serializer.fromJson<int>(json['points']),
      entryType: serializer.fromJson<String>(json['entryType']),
      description: serializer.fromJson<String?>(json['description']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rewardAccountId': serializer.toJson<String>(rewardAccountId),
      'transactionId': serializer.toJson<String?>(transactionId),
      'points': serializer.toJson<int>(points),
      'entryType': serializer.toJson<String>(entryType),
      'description': serializer.toJson<String?>(description),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RewardEntryRow copyWith({
    String? id,
    String? rewardAccountId,
    Value<String?> transactionId = const Value.absent(),
    int? points,
    String? entryType,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
    DateTime? createdAt,
  }) => RewardEntryRow(
    id: id ?? this.id,
    rewardAccountId: rewardAccountId ?? this.rewardAccountId,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    points: points ?? this.points,
    entryType: entryType ?? this.entryType,
    description: description.present ? description.value : this.description,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    createdAt: createdAt ?? this.createdAt,
  );
  RewardEntryRow copyWithCompanion(RewardEntriesCompanion data) {
    return RewardEntryRow(
      id: data.id.present ? data.id.value : this.id,
      rewardAccountId: data.rewardAccountId.present
          ? data.rewardAccountId.value
          : this.rewardAccountId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      points: data.points.present ? data.points.value : this.points,
      entryType: data.entryType.present ? data.entryType.value : this.entryType,
      description: data.description.present
          ? data.description.value
          : this.description,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardEntryRow(')
          ..write('id: $id, ')
          ..write('rewardAccountId: $rewardAccountId, ')
          ..write('transactionId: $transactionId, ')
          ..write('points: $points, ')
          ..write('entryType: $entryType, ')
          ..write('description: $description, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rewardAccountId,
    transactionId,
    points,
    entryType,
    description,
    expiresAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardEntryRow &&
          other.id == this.id &&
          other.rewardAccountId == this.rewardAccountId &&
          other.transactionId == this.transactionId &&
          other.points == this.points &&
          other.entryType == this.entryType &&
          other.description == this.description &&
          other.expiresAt == this.expiresAt &&
          other.createdAt == this.createdAt);
}

class RewardEntriesCompanion extends UpdateCompanion<RewardEntryRow> {
  final Value<String> id;
  final Value<String> rewardAccountId;
  final Value<String?> transactionId;
  final Value<int> points;
  final Value<String> entryType;
  final Value<String?> description;
  final Value<DateTime?> expiresAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RewardEntriesCompanion({
    this.id = const Value.absent(),
    this.rewardAccountId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.points = const Value.absent(),
    this.entryType = const Value.absent(),
    this.description = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardEntriesCompanion.insert({
    required String id,
    required String rewardAccountId,
    this.transactionId = const Value.absent(),
    required int points,
    required String entryType,
    this.description = const Value.absent(),
    this.expiresAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rewardAccountId = Value(rewardAccountId),
       points = Value(points),
       entryType = Value(entryType),
       createdAt = Value(createdAt);
  static Insertable<RewardEntryRow> custom({
    Expression<String>? id,
    Expression<String>? rewardAccountId,
    Expression<String>? transactionId,
    Expression<int>? points,
    Expression<String>? entryType,
    Expression<String>? description,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rewardAccountId != null) 'reward_account_id': rewardAccountId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (points != null) 'points': points,
      if (entryType != null) 'entry_type': entryType,
      if (description != null) 'description': description,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? rewardAccountId,
    Value<String?>? transactionId,
    Value<int>? points,
    Value<String>? entryType,
    Value<String?>? description,
    Value<DateTime?>? expiresAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RewardEntriesCompanion(
      id: id ?? this.id,
      rewardAccountId: rewardAccountId ?? this.rewardAccountId,
      transactionId: transactionId ?? this.transactionId,
      points: points ?? this.points,
      entryType: entryType ?? this.entryType,
      description: description ?? this.description,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rewardAccountId.present) {
      map['reward_account_id'] = Variable<String>(rewardAccountId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (entryType.present) {
      map['entry_type'] = Variable<String>(entryType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardEntriesCompanion(')
          ..write('id: $id, ')
          ..write('rewardAccountId: $rewardAccountId, ')
          ..write('transactionId: $transactionId, ')
          ..write('points: $points, ')
          ..write('entryType: $entryType, ')
          ..write('description: $description, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BankRulesTable extends BankRules
    with TableInfo<$BankRulesTable, BankRuleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BankRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
    'bank_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES banks (id)',
    ),
  );
  static const VerificationMeta _ruleTypeMeta = const VerificationMeta(
    'ruleType',
  );
  @override
  late final GeneratedColumn<String> ruleType = GeneratedColumn<String>(
    'rule_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configurationVersionMeta =
      const VerificationMeta('configurationVersion');
  @override
  late final GeneratedColumn<String> configurationVersion =
      GeneratedColumn<String>(
        'configuration_version',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _configurationMeta = const VerificationMeta(
    'configuration',
  );
  @override
  late final GeneratedColumn<String> configuration = GeneratedColumn<String>(
    'configuration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bankId,
    ruleType,
    configurationVersion,
    configuration,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankRuleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bank_id')) {
      context.handle(
        _bankIdMeta,
        bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bankIdMeta);
    }
    if (data.containsKey('rule_type')) {
      context.handle(
        _ruleTypeMeta,
        ruleType.isAcceptableOrUnknown(data['rule_type']!, _ruleTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleTypeMeta);
    }
    if (data.containsKey('configuration_version')) {
      context.handle(
        _configurationVersionMeta,
        configurationVersion.isAcceptableOrUnknown(
          data['configuration_version']!,
          _configurationVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_configurationVersionMeta);
    }
    if (data.containsKey('configuration')) {
      context.handle(
        _configurationMeta,
        configuration.isAcceptableOrUnknown(
          data['configuration']!,
          _configurationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_configurationMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankRuleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankRuleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bankId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_id'],
      )!,
      ruleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_type'],
      )!,
      configurationVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}configuration_version'],
      )!,
      configuration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}configuration'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BankRulesTable createAlias(String alias) {
    return $BankRulesTable(attachedDatabase, alias);
  }
}

class BankRuleRow extends DataClass implements Insertable<BankRuleRow> {
  final String id;
  final String bankId;
  final String ruleType;
  final String configurationVersion;
  final String configuration;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BankRuleRow({
    required this.id,
    required this.bankId,
    required this.ruleType,
    required this.configurationVersion,
    required this.configuration,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['bank_id'] = Variable<String>(bankId);
    map['rule_type'] = Variable<String>(ruleType);
    map['configuration_version'] = Variable<String>(configurationVersion);
    map['configuration'] = Variable<String>(configuration);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BankRulesCompanion toCompanion(bool nullToAbsent) {
    return BankRulesCompanion(
      id: Value(id),
      bankId: Value(bankId),
      ruleType: Value(ruleType),
      configurationVersion: Value(configurationVersion),
      configuration: Value(configuration),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BankRuleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankRuleRow(
      id: serializer.fromJson<String>(json['id']),
      bankId: serializer.fromJson<String>(json['bankId']),
      ruleType: serializer.fromJson<String>(json['ruleType']),
      configurationVersion: serializer.fromJson<String>(
        json['configurationVersion'],
      ),
      configuration: serializer.fromJson<String>(json['configuration']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bankId': serializer.toJson<String>(bankId),
      'ruleType': serializer.toJson<String>(ruleType),
      'configurationVersion': serializer.toJson<String>(configurationVersion),
      'configuration': serializer.toJson<String>(configuration),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BankRuleRow copyWith({
    String? id,
    String? bankId,
    String? ruleType,
    String? configurationVersion,
    String? configuration,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BankRuleRow(
    id: id ?? this.id,
    bankId: bankId ?? this.bankId,
    ruleType: ruleType ?? this.ruleType,
    configurationVersion: configurationVersion ?? this.configurationVersion,
    configuration: configuration ?? this.configuration,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BankRuleRow copyWithCompanion(BankRulesCompanion data) {
    return BankRuleRow(
      id: data.id.present ? data.id.value : this.id,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      ruleType: data.ruleType.present ? data.ruleType.value : this.ruleType,
      configurationVersion: data.configurationVersion.present
          ? data.configurationVersion.value
          : this.configurationVersion,
      configuration: data.configuration.present
          ? data.configuration.value
          : this.configuration,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankRuleRow(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('ruleType: $ruleType, ')
          ..write('configurationVersion: $configurationVersion, ')
          ..write('configuration: $configuration, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bankId,
    ruleType,
    configurationVersion,
    configuration,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankRuleRow &&
          other.id == this.id &&
          other.bankId == this.bankId &&
          other.ruleType == this.ruleType &&
          other.configurationVersion == this.configurationVersion &&
          other.configuration == this.configuration &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BankRulesCompanion extends UpdateCompanion<BankRuleRow> {
  final Value<String> id;
  final Value<String> bankId;
  final Value<String> ruleType;
  final Value<String> configurationVersion;
  final Value<String> configuration;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BankRulesCompanion({
    this.id = const Value.absent(),
    this.bankId = const Value.absent(),
    this.ruleType = const Value.absent(),
    this.configurationVersion = const Value.absent(),
    this.configuration = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BankRulesCompanion.insert({
    required String id,
    required String bankId,
    required String ruleType,
    required String configurationVersion,
    required String configuration,
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bankId = Value(bankId),
       ruleType = Value(ruleType),
       configurationVersion = Value(configurationVersion),
       configuration = Value(configuration),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BankRuleRow> custom({
    Expression<String>? id,
    Expression<String>? bankId,
    Expression<String>? ruleType,
    Expression<String>? configurationVersion,
    Expression<String>? configuration,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankId != null) 'bank_id': bankId,
      if (ruleType != null) 'rule_type': ruleType,
      if (configurationVersion != null)
        'configuration_version': configurationVersion,
      if (configuration != null) 'configuration': configuration,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BankRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? bankId,
    Value<String>? ruleType,
    Value<String>? configurationVersion,
    Value<String>? configuration,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BankRulesCompanion(
      id: id ?? this.id,
      bankId: bankId ?? this.bankId,
      ruleType: ruleType ?? this.ruleType,
      configurationVersion: configurationVersion ?? this.configurationVersion,
      configuration: configuration ?? this.configuration,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (ruleType.present) {
      map['rule_type'] = Variable<String>(ruleType.value);
    }
    if (configurationVersion.present) {
      map['configuration_version'] = Variable<String>(
        configurationVersion.value,
      );
    }
    if (configuration.present) {
      map['configuration'] = Variable<String>(configuration.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BankRulesCompanion(')
          ..write('id: $id, ')
          ..write('bankId: $bankId, ')
          ..write('ruleType: $ruleType, ')
          ..write('configurationVersion: $configurationVersion, ')
          ..write('configuration: $configuration, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmailAccountsTable extends EmailAccounts
    with TableInfo<$EmailAccountsTable, EmailAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailAddressMeta = const VerificationMeta(
    'emailAddress',
  );
  @override
  late final GeneratedColumn<String> emailAddress = GeneratedColumn<String>(
    'email_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _secureTokenReferenceMeta =
      const VerificationMeta('secureTokenReference');
  @override
  late final GeneratedColumn<String> secureTokenReference =
      GeneratedColumn<String>(
        'secure_token_reference',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('connected'),
  );
  static const VerificationMeta _syncEnabledMeta = const VerificationMeta(
    'syncEnabled',
  );
  @override
  late final GeneratedColumn<bool> syncEnabled = GeneratedColumn<bool>(
    'sync_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sync_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _connectedAtMeta = const VerificationMeta(
    'connectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> connectedAt = GeneratedColumn<DateTime>(
    'connected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSuccessfulSyncMeta =
      const VerificationMeta('lastSuccessfulSync');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulSync =
      GeneratedColumn<DateTime>(
        'last_successful_sync',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    provider,
    emailAddress,
    secureTokenReference,
    status,
    syncEnabled,
    connectedAt,
    lastSuccessfulSync,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmailAccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('email_address')) {
      context.handle(
        _emailAddressMeta,
        emailAddress.isAcceptableOrUnknown(
          data['email_address']!,
          _emailAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_emailAddressMeta);
    }
    if (data.containsKey('secure_token_reference')) {
      context.handle(
        _secureTokenReferenceMeta,
        secureTokenReference.isAcceptableOrUnknown(
          data['secure_token_reference']!,
          _secureTokenReferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_secureTokenReferenceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('sync_enabled')) {
      context.handle(
        _syncEnabledMeta,
        syncEnabled.isAcceptableOrUnknown(
          data['sync_enabled']!,
          _syncEnabledMeta,
        ),
      );
    }
    if (data.containsKey('connected_at')) {
      context.handle(
        _connectedAtMeta,
        connectedAt.isAcceptableOrUnknown(
          data['connected_at']!,
          _connectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectedAtMeta);
    }
    if (data.containsKey('last_successful_sync')) {
      context.handle(
        _lastSuccessfulSyncMeta,
        lastSuccessfulSync.isAcceptableOrUnknown(
          data['last_successful_sync']!,
          _lastSuccessfulSyncMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailAccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      emailAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_address'],
      )!,
      secureTokenReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secure_token_reference'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      syncEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sync_enabled'],
      )!,
      connectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}connected_at'],
      )!,
      lastSuccessfulSync: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_sync'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmailAccountsTable createAlias(String alias) {
    return $EmailAccountsTable(attachedDatabase, alias);
  }
}

class EmailAccountRow extends DataClass implements Insertable<EmailAccountRow> {
  final String id;
  final String provider;
  final String emailAddress;
  final String secureTokenReference;
  final String status;
  final bool syncEnabled;
  final DateTime connectedAt;
  final DateTime? lastSuccessfulSync;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EmailAccountRow({
    required this.id,
    required this.provider,
    required this.emailAddress,
    required this.secureTokenReference,
    required this.status,
    required this.syncEnabled,
    required this.connectedAt,
    this.lastSuccessfulSync,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['provider'] = Variable<String>(provider);
    map['email_address'] = Variable<String>(emailAddress);
    map['secure_token_reference'] = Variable<String>(secureTokenReference);
    map['status'] = Variable<String>(status);
    map['sync_enabled'] = Variable<bool>(syncEnabled);
    map['connected_at'] = Variable<DateTime>(connectedAt);
    if (!nullToAbsent || lastSuccessfulSync != null) {
      map['last_successful_sync'] = Variable<DateTime>(lastSuccessfulSync);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmailAccountsCompanion toCompanion(bool nullToAbsent) {
    return EmailAccountsCompanion(
      id: Value(id),
      provider: Value(provider),
      emailAddress: Value(emailAddress),
      secureTokenReference: Value(secureTokenReference),
      status: Value(status),
      syncEnabled: Value(syncEnabled),
      connectedAt: Value(connectedAt),
      lastSuccessfulSync: lastSuccessfulSync == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulSync),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmailAccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailAccountRow(
      id: serializer.fromJson<String>(json['id']),
      provider: serializer.fromJson<String>(json['provider']),
      emailAddress: serializer.fromJson<String>(json['emailAddress']),
      secureTokenReference: serializer.fromJson<String>(
        json['secureTokenReference'],
      ),
      status: serializer.fromJson<String>(json['status']),
      syncEnabled: serializer.fromJson<bool>(json['syncEnabled']),
      connectedAt: serializer.fromJson<DateTime>(json['connectedAt']),
      lastSuccessfulSync: serializer.fromJson<DateTime?>(
        json['lastSuccessfulSync'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'provider': serializer.toJson<String>(provider),
      'emailAddress': serializer.toJson<String>(emailAddress),
      'secureTokenReference': serializer.toJson<String>(secureTokenReference),
      'status': serializer.toJson<String>(status),
      'syncEnabled': serializer.toJson<bool>(syncEnabled),
      'connectedAt': serializer.toJson<DateTime>(connectedAt),
      'lastSuccessfulSync': serializer.toJson<DateTime?>(lastSuccessfulSync),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EmailAccountRow copyWith({
    String? id,
    String? provider,
    String? emailAddress,
    String? secureTokenReference,
    String? status,
    bool? syncEnabled,
    DateTime? connectedAt,
    Value<DateTime?> lastSuccessfulSync = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EmailAccountRow(
    id: id ?? this.id,
    provider: provider ?? this.provider,
    emailAddress: emailAddress ?? this.emailAddress,
    secureTokenReference: secureTokenReference ?? this.secureTokenReference,
    status: status ?? this.status,
    syncEnabled: syncEnabled ?? this.syncEnabled,
    connectedAt: connectedAt ?? this.connectedAt,
    lastSuccessfulSync: lastSuccessfulSync.present
        ? lastSuccessfulSync.value
        : this.lastSuccessfulSync,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EmailAccountRow copyWithCompanion(EmailAccountsCompanion data) {
    return EmailAccountRow(
      id: data.id.present ? data.id.value : this.id,
      provider: data.provider.present ? data.provider.value : this.provider,
      emailAddress: data.emailAddress.present
          ? data.emailAddress.value
          : this.emailAddress,
      secureTokenReference: data.secureTokenReference.present
          ? data.secureTokenReference.value
          : this.secureTokenReference,
      status: data.status.present ? data.status.value : this.status,
      syncEnabled: data.syncEnabled.present
          ? data.syncEnabled.value
          : this.syncEnabled,
      connectedAt: data.connectedAt.present
          ? data.connectedAt.value
          : this.connectedAt,
      lastSuccessfulSync: data.lastSuccessfulSync.present
          ? data.lastSuccessfulSync.value
          : this.lastSuccessfulSync,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailAccountRow(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('emailAddress: $emailAddress, ')
          ..write('secureTokenReference: $secureTokenReference, ')
          ..write('status: $status, ')
          ..write('syncEnabled: $syncEnabled, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSuccessfulSync: $lastSuccessfulSync, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    provider,
    emailAddress,
    secureTokenReference,
    status,
    syncEnabled,
    connectedAt,
    lastSuccessfulSync,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailAccountRow &&
          other.id == this.id &&
          other.provider == this.provider &&
          other.emailAddress == this.emailAddress &&
          other.secureTokenReference == this.secureTokenReference &&
          other.status == this.status &&
          other.syncEnabled == this.syncEnabled &&
          other.connectedAt == this.connectedAt &&
          other.lastSuccessfulSync == this.lastSuccessfulSync &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmailAccountsCompanion extends UpdateCompanion<EmailAccountRow> {
  final Value<String> id;
  final Value<String> provider;
  final Value<String> emailAddress;
  final Value<String> secureTokenReference;
  final Value<String> status;
  final Value<bool> syncEnabled;
  final Value<DateTime> connectedAt;
  final Value<DateTime?> lastSuccessfulSync;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EmailAccountsCompanion({
    this.id = const Value.absent(),
    this.provider = const Value.absent(),
    this.emailAddress = const Value.absent(),
    this.secureTokenReference = const Value.absent(),
    this.status = const Value.absent(),
    this.syncEnabled = const Value.absent(),
    this.connectedAt = const Value.absent(),
    this.lastSuccessfulSync = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmailAccountsCompanion.insert({
    required String id,
    required String provider,
    required String emailAddress,
    required String secureTokenReference,
    this.status = const Value.absent(),
    this.syncEnabled = const Value.absent(),
    required DateTime connectedAt,
    this.lastSuccessfulSync = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       provider = Value(provider),
       emailAddress = Value(emailAddress),
       secureTokenReference = Value(secureTokenReference),
       connectedAt = Value(connectedAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<EmailAccountRow> custom({
    Expression<String>? id,
    Expression<String>? provider,
    Expression<String>? emailAddress,
    Expression<String>? secureTokenReference,
    Expression<String>? status,
    Expression<bool>? syncEnabled,
    Expression<DateTime>? connectedAt,
    Expression<DateTime>? lastSuccessfulSync,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provider != null) 'provider': provider,
      if (emailAddress != null) 'email_address': emailAddress,
      if (secureTokenReference != null)
        'secure_token_reference': secureTokenReference,
      if (status != null) 'status': status,
      if (syncEnabled != null) 'sync_enabled': syncEnabled,
      if (connectedAt != null) 'connected_at': connectedAt,
      if (lastSuccessfulSync != null)
        'last_successful_sync': lastSuccessfulSync,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmailAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? provider,
    Value<String>? emailAddress,
    Value<String>? secureTokenReference,
    Value<String>? status,
    Value<bool>? syncEnabled,
    Value<DateTime>? connectedAt,
    Value<DateTime?>? lastSuccessfulSync,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EmailAccountsCompanion(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      emailAddress: emailAddress ?? this.emailAddress,
      secureTokenReference: secureTokenReference ?? this.secureTokenReference,
      status: status ?? this.status,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSuccessfulSync: lastSuccessfulSync ?? this.lastSuccessfulSync,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (emailAddress.present) {
      map['email_address'] = Variable<String>(emailAddress.value);
    }
    if (secureTokenReference.present) {
      map['secure_token_reference'] = Variable<String>(
        secureTokenReference.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (syncEnabled.present) {
      map['sync_enabled'] = Variable<bool>(syncEnabled.value);
    }
    if (connectedAt.present) {
      map['connected_at'] = Variable<DateTime>(connectedAt.value);
    }
    if (lastSuccessfulSync.present) {
      map['last_successful_sync'] = Variable<DateTime>(
        lastSuccessfulSync.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailAccountsCompanion(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('emailAddress: $emailAddress, ')
          ..write('secureTokenReference: $secureTokenReference, ')
          ..write('status: $status, ')
          ..write('syncEnabled: $syncEnabled, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSuccessfulSync: $lastSuccessfulSync, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncCheckpointsTable extends SyncCheckpoints
    with TableInfo<$SyncCheckpointsTable, SyncCheckpointRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncCheckpointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailAccountIdMeta = const VerificationMeta(
    'emailAccountId',
  );
  @override
  late final GeneratedColumn<String> emailAccountId = GeneratedColumn<String>(
    'email_account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES email_accounts (id)',
    ),
  );
  static const VerificationMeta _providerCheckpointMeta =
      const VerificationMeta('providerCheckpoint');
  @override
  late final GeneratedColumn<String> providerCheckpoint =
      GeneratedColumn<String>(
        'provider_checkpoint',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSyncStartedMeta = const VerificationMeta(
    'lastSyncStarted',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncStarted =
      GeneratedColumn<DateTime>(
        'last_sync_started',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastSyncCompletedMeta = const VerificationMeta(
    'lastSyncCompleted',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncCompleted =
      GeneratedColumn<DateTime>(
        'last_sync_completed',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    emailAccountId,
    providerCheckpoint,
    lastSyncStarted,
    lastSyncCompleted,
    status,
    errorCode,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_checkpoints';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncCheckpointRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email_account_id')) {
      context.handle(
        _emailAccountIdMeta,
        emailAccountId.isAcceptableOrUnknown(
          data['email_account_id']!,
          _emailAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_emailAccountIdMeta);
    }
    if (data.containsKey('provider_checkpoint')) {
      context.handle(
        _providerCheckpointMeta,
        providerCheckpoint.isAcceptableOrUnknown(
          data['provider_checkpoint']!,
          _providerCheckpointMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_started')) {
      context.handle(
        _lastSyncStartedMeta,
        lastSyncStarted.isAcceptableOrUnknown(
          data['last_sync_started']!,
          _lastSyncStartedMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_completed')) {
      context.handle(
        _lastSyncCompletedMeta,
        lastSyncCompleted.isAcceptableOrUnknown(
          data['last_sync_completed']!,
          _lastSyncCompletedMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncCheckpointRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncCheckpointRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      emailAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email_account_id'],
      )!,
      providerCheckpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_checkpoint'],
      ),
      lastSyncStarted: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_started'],
      ),
      lastSyncCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_completed'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncCheckpointsTable createAlias(String alias) {
    return $SyncCheckpointsTable(attachedDatabase, alias);
  }
}

class SyncCheckpointRow extends DataClass
    implements Insertable<SyncCheckpointRow> {
  final String id;
  final String emailAccountId;
  final String? providerCheckpoint;
  final DateTime? lastSyncStarted;
  final DateTime? lastSyncCompleted;
  final String status;
  final String? errorCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncCheckpointRow({
    required this.id,
    required this.emailAccountId,
    this.providerCheckpoint,
    this.lastSyncStarted,
    this.lastSyncCompleted,
    required this.status,
    this.errorCode,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email_account_id'] = Variable<String>(emailAccountId);
    if (!nullToAbsent || providerCheckpoint != null) {
      map['provider_checkpoint'] = Variable<String>(providerCheckpoint);
    }
    if (!nullToAbsent || lastSyncStarted != null) {
      map['last_sync_started'] = Variable<DateTime>(lastSyncStarted);
    }
    if (!nullToAbsent || lastSyncCompleted != null) {
      map['last_sync_completed'] = Variable<DateTime>(lastSyncCompleted);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncCheckpointsCompanion toCompanion(bool nullToAbsent) {
    return SyncCheckpointsCompanion(
      id: Value(id),
      emailAccountId: Value(emailAccountId),
      providerCheckpoint: providerCheckpoint == null && nullToAbsent
          ? const Value.absent()
          : Value(providerCheckpoint),
      lastSyncStarted: lastSyncStarted == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncStarted),
      lastSyncCompleted: lastSyncCompleted == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncCompleted),
      status: Value(status),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncCheckpointRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncCheckpointRow(
      id: serializer.fromJson<String>(json['id']),
      emailAccountId: serializer.fromJson<String>(json['emailAccountId']),
      providerCheckpoint: serializer.fromJson<String?>(
        json['providerCheckpoint'],
      ),
      lastSyncStarted: serializer.fromJson<DateTime?>(json['lastSyncStarted']),
      lastSyncCompleted: serializer.fromJson<DateTime?>(
        json['lastSyncCompleted'],
      ),
      status: serializer.fromJson<String>(json['status']),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'emailAccountId': serializer.toJson<String>(emailAccountId),
      'providerCheckpoint': serializer.toJson<String?>(providerCheckpoint),
      'lastSyncStarted': serializer.toJson<DateTime?>(lastSyncStarted),
      'lastSyncCompleted': serializer.toJson<DateTime?>(lastSyncCompleted),
      'status': serializer.toJson<String>(status),
      'errorCode': serializer.toJson<String?>(errorCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncCheckpointRow copyWith({
    String? id,
    String? emailAccountId,
    Value<String?> providerCheckpoint = const Value.absent(),
    Value<DateTime?> lastSyncStarted = const Value.absent(),
    Value<DateTime?> lastSyncCompleted = const Value.absent(),
    String? status,
    Value<String?> errorCode = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncCheckpointRow(
    id: id ?? this.id,
    emailAccountId: emailAccountId ?? this.emailAccountId,
    providerCheckpoint: providerCheckpoint.present
        ? providerCheckpoint.value
        : this.providerCheckpoint,
    lastSyncStarted: lastSyncStarted.present
        ? lastSyncStarted.value
        : this.lastSyncStarted,
    lastSyncCompleted: lastSyncCompleted.present
        ? lastSyncCompleted.value
        : this.lastSyncCompleted,
    status: status ?? this.status,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncCheckpointRow copyWithCompanion(SyncCheckpointsCompanion data) {
    return SyncCheckpointRow(
      id: data.id.present ? data.id.value : this.id,
      emailAccountId: data.emailAccountId.present
          ? data.emailAccountId.value
          : this.emailAccountId,
      providerCheckpoint: data.providerCheckpoint.present
          ? data.providerCheckpoint.value
          : this.providerCheckpoint,
      lastSyncStarted: data.lastSyncStarted.present
          ? data.lastSyncStarted.value
          : this.lastSyncStarted,
      lastSyncCompleted: data.lastSyncCompleted.present
          ? data.lastSyncCompleted.value
          : this.lastSyncCompleted,
      status: data.status.present ? data.status.value : this.status,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncCheckpointRow(')
          ..write('id: $id, ')
          ..write('emailAccountId: $emailAccountId, ')
          ..write('providerCheckpoint: $providerCheckpoint, ')
          ..write('lastSyncStarted: $lastSyncStarted, ')
          ..write('lastSyncCompleted: $lastSyncCompleted, ')
          ..write('status: $status, ')
          ..write('errorCode: $errorCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    emailAccountId,
    providerCheckpoint,
    lastSyncStarted,
    lastSyncCompleted,
    status,
    errorCode,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncCheckpointRow &&
          other.id == this.id &&
          other.emailAccountId == this.emailAccountId &&
          other.providerCheckpoint == this.providerCheckpoint &&
          other.lastSyncStarted == this.lastSyncStarted &&
          other.lastSyncCompleted == this.lastSyncCompleted &&
          other.status == this.status &&
          other.errorCode == this.errorCode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncCheckpointsCompanion extends UpdateCompanion<SyncCheckpointRow> {
  final Value<String> id;
  final Value<String> emailAccountId;
  final Value<String?> providerCheckpoint;
  final Value<DateTime?> lastSyncStarted;
  final Value<DateTime?> lastSyncCompleted;
  final Value<String> status;
  final Value<String?> errorCode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncCheckpointsCompanion({
    this.id = const Value.absent(),
    this.emailAccountId = const Value.absent(),
    this.providerCheckpoint = const Value.absent(),
    this.lastSyncStarted = const Value.absent(),
    this.lastSyncCompleted = const Value.absent(),
    this.status = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncCheckpointsCompanion.insert({
    required String id,
    required String emailAccountId,
    this.providerCheckpoint = const Value.absent(),
    this.lastSyncStarted = const Value.absent(),
    this.lastSyncCompleted = const Value.absent(),
    required String status,
    this.errorCode = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       emailAccountId = Value(emailAccountId),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SyncCheckpointRow> custom({
    Expression<String>? id,
    Expression<String>? emailAccountId,
    Expression<String>? providerCheckpoint,
    Expression<DateTime>? lastSyncStarted,
    Expression<DateTime>? lastSyncCompleted,
    Expression<String>? status,
    Expression<String>? errorCode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (emailAccountId != null) 'email_account_id': emailAccountId,
      if (providerCheckpoint != null) 'provider_checkpoint': providerCheckpoint,
      if (lastSyncStarted != null) 'last_sync_started': lastSyncStarted,
      if (lastSyncCompleted != null) 'last_sync_completed': lastSyncCompleted,
      if (status != null) 'status': status,
      if (errorCode != null) 'error_code': errorCode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncCheckpointsCompanion copyWith({
    Value<String>? id,
    Value<String>? emailAccountId,
    Value<String?>? providerCheckpoint,
    Value<DateTime?>? lastSyncStarted,
    Value<DateTime?>? lastSyncCompleted,
    Value<String>? status,
    Value<String?>? errorCode,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncCheckpointsCompanion(
      id: id ?? this.id,
      emailAccountId: emailAccountId ?? this.emailAccountId,
      providerCheckpoint: providerCheckpoint ?? this.providerCheckpoint,
      lastSyncStarted: lastSyncStarted ?? this.lastSyncStarted,
      lastSyncCompleted: lastSyncCompleted ?? this.lastSyncCompleted,
      status: status ?? this.status,
      errorCode: errorCode ?? this.errorCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (emailAccountId.present) {
      map['email_account_id'] = Variable<String>(emailAccountId.value);
    }
    if (providerCheckpoint.present) {
      map['provider_checkpoint'] = Variable<String>(providerCheckpoint.value);
    }
    if (lastSyncStarted.present) {
      map['last_sync_started'] = Variable<DateTime>(lastSyncStarted.value);
    }
    if (lastSyncCompleted.present) {
      map['last_sync_completed'] = Variable<DateTime>(lastSyncCompleted.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncCheckpointsCompanion(')
          ..write('id: $id, ')
          ..write('emailAccountId: $emailAccountId, ')
          ..write('providerCheckpoint: $providerCheckpoint, ')
          ..write('lastSyncStarted: $lastSyncStarted, ')
          ..write('lastSyncCompleted: $lastSyncCompleted, ')
          ..write('status: $status, ')
          ..write('errorCode: $errorCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BanksTable banks = $BanksTable(this);
  late final $CreditCardsTable creditCards = $CreditCardsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $ImportJobsTable importJobs = $ImportJobsTable(this);
  late final $TransactionSourcesTable transactionSources =
      $TransactionSourcesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ReviewItemsTable reviewItems = $ReviewItemsTable(this);
  late final $StatementsTable statements = $StatementsTable(this);
  late final $StatementTransactionsTable statementTransactions =
      $StatementTransactionsTable(this);
  late final $CashbackEntriesTable cashbackEntries = $CashbackEntriesTable(
    this,
  );
  late final $CashbackRulesTable cashbackRules = $CashbackRulesTable(this);
  late final $RewardAccountsTable rewardAccounts = $RewardAccountsTable(this);
  late final $RewardEntriesTable rewardEntries = $RewardEntriesTable(this);
  late final $BankRulesTable bankRules = $BankRulesTable(this);
  late final $EmailAccountsTable emailAccounts = $EmailAccountsTable(this);
  late final $SyncCheckpointsTable syncCheckpoints = $SyncCheckpointsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    banks,
    creditCards,
    categories,
    transactions,
    importJobs,
    transactionSources,
    appSettings,
    reviewItems,
    statements,
    statementTransactions,
    cashbackEntries,
    cashbackRules,
    rewardAccounts,
    rewardEntries,
    bankRules,
    emailAccounts,
    syncCheckpoints,
  ];
}

typedef $$BanksTableCreateCompanionBuilder = BanksCompanion Function({
  required String id,
  required String displayName,
  required String countryCode,
  required String region,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BanksTableUpdateCompanionBuilder = BanksCompanion Function({
  Value<String> id,
  Value<String> displayName,
  Value<String> countryCode,
  Value<String> region,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$BanksTableReferences
    extends BaseReferences<_$AppDatabase, $BanksTable, BankRow> {
  $$BanksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CreditCardsTable, List<CreditCardRow>>
  _creditCardsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.creditCards,
    aliasName: 'banks__id__credit_cards__bank_id',
  );

  $$CreditCardsTableProcessedTableManager get creditCardsRefs {
    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.bankId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_creditCardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<TransactionRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'banks__id__transactions__bank_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.bankId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StatementsTable, List<StatementRow>>
  _statementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.statements,
    aliasName: 'banks__id__statements__bank_id',
  );

  $$StatementsTableProcessedTableManager get statementsRefs {
    final manager = $$StatementsTableTableManager(
      $_db,
      $_db.statements,
    ).filter((f) => f.bankId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_statementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BankRulesTable, List<BankRuleRow>>
  _bankRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bankRules,
    aliasName: 'banks__id__bank_rules__bank_id',
  );

  $$BankRulesTableProcessedTableManager get bankRulesRefs {
    final manager = $$BankRulesTableTableManager(
      $_db,
      $_db.bankRules,
    ).filter((f) => f.bankId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bankRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BanksTableFilterComposer extends Composer<_$AppDatabase, $BanksTable> {
  $$BanksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> creditCardsRefs(
    Expression<bool> Function($$CreditCardsTableFilterComposer f) f,
  ) {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> statementsRefs(
    Expression<bool> Function($$StatementsTableFilterComposer f) f,
  ) {
    final $$StatementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.statements,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatementsTableFilterComposer(
            $db: $db,
            $table: $db.statements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bankRulesRefs(
    Expression<bool> Function($$BankRulesTableFilterComposer f) f,
  ) {
    final $$BankRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankRules,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankRulesTableFilterComposer(
            $db: $db,
            $table: $db.bankRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BanksTableOrderingComposer
    extends Composer<_$AppDatabase, $BanksTable> {
  $$BanksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BanksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BanksTable> {
  $$BanksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> creditCardsRefs<T extends Object>(
    Expression<T> Function($$CreditCardsTableAnnotationComposer a) f,
  ) {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> statementsRefs<T extends Object>(
    Expression<T> Function($$StatementsTableAnnotationComposer a) f,
  ) {
    final $$StatementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.statements,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatementsTableAnnotationComposer(
            $db: $db,
            $table: $db.statements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bankRulesRefs<T extends Object>(
    Expression<T> Function($$BankRulesTableAnnotationComposer a) f,
  ) {
    final $$BankRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bankRules,
      getReferencedColumn: (t) => t.bankId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BankRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.bankRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BanksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BanksTable,
          BankRow,
          $$BanksTableFilterComposer,
          $$BanksTableOrderingComposer,
          $$BanksTableAnnotationComposer,
          $$BanksTableCreateCompanionBuilder,
          $$BanksTableUpdateCompanionBuilder,
          (BankRow, $$BanksTableReferences),
          BankRow,
          PrefetchHooks Function({
            bool creditCardsRefs,
            bool transactionsRefs,
            bool statementsRefs,
            bool bankRulesRefs,
          })
        > {
  $$BanksTableTableManager(_$AppDatabase db, $BanksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BanksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BanksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BanksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> countryCode = const Value.absent(),
                Value<String> region = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BanksCompanion(
                id: id,
                displayName: displayName,
                countryCode: countryCode,
                region: region,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                required String countryCode,
                required String region,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BanksCompanion.insert(
                id: id,
                displayName: displayName,
                countryCode: countryCode,
                region: region,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BanksTable, BankRow>(table),
                  $$BanksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                creditCardsRefs = false,
                transactionsRefs = false,
                statementsRefs = false,
                bankRulesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (creditCardsRefs) db.creditCards,
                    if (transactionsRefs) db.transactions,
                    if (statementsRefs) db.statements,
                    if (bankRulesRefs) db.bankRules,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (creditCardsRefs)
                        await $_getPrefetchedDataByColumns<
                          BankRow,
                          $BanksTable,
                          CreditCardRow,
                          $CreditCardsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BanksTableReferences
                              ._creditCardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BanksTableReferences(
                                db,
                                table,
                                p0,
                              ).creditCardsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bank_id',
                          typedResults: items,
                        ),
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          BankRow,
                          $BanksTable,
                          TransactionRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BanksTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BanksTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bank_id',
                          typedResults: items,
                        ),
                      if (statementsRefs)
                        await $_getPrefetchedDataByColumns<
                          BankRow,
                          $BanksTable,
                          StatementRow,
                          $StatementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BanksTableReferences
                              ._statementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BanksTableReferences(
                                db,
                                table,
                                p0,
                              ).statementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bank_id',
                          typedResults: items,
                        ),
                      if (bankRulesRefs)
                        await $_getPrefetchedDataByColumns<
                          BankRow,
                          $BanksTable,
                          BankRuleRow,
                          $BankRulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$BanksTableReferences
                              ._bankRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BanksTableReferences(
                                db,
                                table,
                                p0,
                              ).bankRulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'bank_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BanksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BanksTable,
      BankRow,
      $$BanksTableFilterComposer,
      $$BanksTableOrderingComposer,
      $$BanksTableAnnotationComposer,
      $$BanksTableCreateCompanionBuilder,
      $$BanksTableUpdateCompanionBuilder,
      (BankRow, $$BanksTableReferences),
      BankRow,
      PrefetchHooks Function({
        bool creditCardsRefs,
        bool transactionsRefs,
        bool statementsRefs,
        bool bankRulesRefs,
      })
    >;
typedef $$CreditCardsTableCreateCompanionBuilder =
    CreditCardsCompanion Function({
      required String id,
      required String bankId,
      required String displayName,
      Value<String?> cardholderName,
      required String network,
      required String lastFour,
      required int creditLimitMinor,
      Value<int> currentOutstandingMinor,
      required String currencyCode,
      Value<int?> statementDay,
      Value<int?> dueDay,
      Value<DateTime?> billingCycleStart,
      Value<DateTime?> billingCycleEnd,
      Value<String> status,
      Value<String?> rewardProgramme,
      Value<int?> colorValue,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CreditCardsTableUpdateCompanionBuilder =
    CreditCardsCompanion Function({
      Value<String> id,
      Value<String> bankId,
      Value<String> displayName,
      Value<String?> cardholderName,
      Value<String> network,
      Value<String> lastFour,
      Value<int> creditLimitMinor,
      Value<int> currentOutstandingMinor,
      Value<String> currencyCode,
      Value<int?> statementDay,
      Value<int?> dueDay,
      Value<DateTime?> billingCycleStart,
      Value<DateTime?> billingCycleEnd,
      Value<String> status,
      Value<String?> rewardProgramme,
      Value<int?> colorValue,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CreditCardsTableReferences
    extends BaseReferences<_$AppDatabase, $CreditCardsTable, CreditCardRow> {
  $$CreditCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BanksTable _bankIdTable(_$AppDatabase db) =>
      db.banks.createAlias('credit_cards__bank_id__banks__id');

  $$BanksTableProcessedTableManager get bankId {
    final $_column = $_itemColumn<String>('bank_id')!;

    final manager = $$BanksTableTableManager(
      $_db,
      $_db.banks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<TransactionRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'credit_cards__id__transactions__card_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StatementsTable, List<StatementRow>>
  _statementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.statements,
    aliasName: 'credit_cards__id__statements__card_id',
  );

  $$StatementsTableProcessedTableManager get statementsRefs {
    final manager = $$StatementsTableTableManager(
      $_db,
      $_db.statements,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_statementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CashbackEntriesTable, List<CashbackEntryRow>>
  _cashbackEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cashbackEntries,
    aliasName: 'credit_cards__id__cashback_entries__card_id',
  );

  $$CashbackEntriesTableProcessedTableManager get cashbackEntriesRefs {
    final manager = $$CashbackEntriesTableTableManager(
      $_db,
      $_db.cashbackEntries,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cashbackEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CashbackRulesTable, List<CashbackRuleRow>>
  _cashbackRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cashbackRules,
    aliasName: 'credit_cards__id__cashback_rules__card_id',
  );

  $$CashbackRulesTableProcessedTableManager get cashbackRulesRefs {
    final manager = $$CashbackRulesTableTableManager(
      $_db,
      $_db.cashbackRules,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cashbackRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RewardAccountsTable, List<RewardAccountRow>>
  _rewardAccountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rewardAccounts,
    aliasName: 'credit_cards__id__reward_accounts__card_id',
  );

  $$RewardAccountsTableProcessedTableManager get rewardAccountsRefs {
    final manager = $$RewardAccountsTableTableManager(
      $_db,
      $_db.rewardAccounts,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rewardAccountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CreditCardsTableFilterComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardholderName => $composableBuilder(
    column: $table.cardholderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastFour => $composableBuilder(
    column: $table.lastFour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditLimitMinor => $composableBuilder(
    column: $table.creditLimitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentOutstandingMinor => $composableBuilder(
    column: $table.currentOutstandingMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statementDay => $composableBuilder(
    column: $table.statementDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get billingCycleStart => $composableBuilder(
    column: $table.billingCycleStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get billingCycleEnd => $composableBuilder(
    column: $table.billingCycleEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rewardProgramme => $composableBuilder(
    column: $table.rewardProgramme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BanksTableFilterComposer get bankId {
    final $$BanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableFilterComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> statementsRefs(
    Expression<bool> Function($$StatementsTableFilterComposer f) f,
  ) {
    final $$StatementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.statements,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatementsTableFilterComposer(
            $db: $db,
            $table: $db.statements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cashbackEntriesRefs(
    Expression<bool> Function($$CashbackEntriesTableFilterComposer f) f,
  ) {
    final $$CashbackEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashbackEntries,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashbackEntriesTableFilterComposer(
            $db: $db,
            $table: $db.cashbackEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cashbackRulesRefs(
    Expression<bool> Function($$CashbackRulesTableFilterComposer f) f,
  ) {
    final $$CashbackRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashbackRules,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashbackRulesTableFilterComposer(
            $db: $db,
            $table: $db.cashbackRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rewardAccountsRefs(
    Expression<bool> Function($$RewardAccountsTableFilterComposer f) f,
  ) {
    final $$RewardAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewardAccounts,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardAccountsTableFilterComposer(
            $db: $db,
            $table: $db.rewardAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardholderName => $composableBuilder(
    column: $table.cardholderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastFour => $composableBuilder(
    column: $table.lastFour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditLimitMinor => $composableBuilder(
    column: $table.creditLimitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentOutstandingMinor => $composableBuilder(
    column: $table.currentOutstandingMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statementDay => $composableBuilder(
    column: $table.statementDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get billingCycleStart => $composableBuilder(
    column: $table.billingCycleStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get billingCycleEnd => $composableBuilder(
    column: $table.billingCycleEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rewardProgramme => $composableBuilder(
    column: $table.rewardProgramme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BanksTableOrderingComposer get bankId {
    final $$BanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableOrderingComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CreditCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditCardsTable> {
  $$CreditCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardholderName => $composableBuilder(
    column: $table.cardholderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get network =>
      $composableBuilder(column: $table.network, builder: (column) => column);

  GeneratedColumn<String> get lastFour =>
      $composableBuilder(column: $table.lastFour, builder: (column) => column);

  GeneratedColumn<int> get creditLimitMinor => $composableBuilder(
    column: $table.creditLimitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentOutstandingMinor => $composableBuilder(
    column: $table.currentOutstandingMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get statementDay => $composableBuilder(
    column: $table.statementDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<DateTime> get billingCycleStart => $composableBuilder(
    column: $table.billingCycleStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get billingCycleEnd => $composableBuilder(
    column: $table.billingCycleEnd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get rewardProgramme => $composableBuilder(
    column: $table.rewardProgramme,
    builder: (column) => column,
  );

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BanksTableAnnotationComposer get bankId {
    final $$BanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableAnnotationComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> statementsRefs<T extends Object>(
    Expression<T> Function($$StatementsTableAnnotationComposer a) f,
  ) {
    final $$StatementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.statements,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatementsTableAnnotationComposer(
            $db: $db,
            $table: $db.statements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cashbackEntriesRefs<T extends Object>(
    Expression<T> Function($$CashbackEntriesTableAnnotationComposer a) f,
  ) {
    final $$CashbackEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashbackEntries,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashbackEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.cashbackEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cashbackRulesRefs<T extends Object>(
    Expression<T> Function($$CashbackRulesTableAnnotationComposer a) f,
  ) {
    final $$CashbackRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashbackRules,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashbackRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.cashbackRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rewardAccountsRefs<T extends Object>(
    Expression<T> Function($$RewardAccountsTableAnnotationComposer a) f,
  ) {
    final $$RewardAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewardAccounts,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.rewardAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CreditCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditCardsTable,
          CreditCardRow,
          $$CreditCardsTableFilterComposer,
          $$CreditCardsTableOrderingComposer,
          $$CreditCardsTableAnnotationComposer,
          $$CreditCardsTableCreateCompanionBuilder,
          $$CreditCardsTableUpdateCompanionBuilder,
          (CreditCardRow, $$CreditCardsTableReferences),
          CreditCardRow,
          PrefetchHooks Function({
            bool bankId,
            bool transactionsRefs,
            bool statementsRefs,
            bool cashbackEntriesRefs,
            bool cashbackRulesRefs,
            bool rewardAccountsRefs,
          })
        > {
  $$CreditCardsTableTableManager(_$AppDatabase db, $CreditCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bankId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> cardholderName = const Value.absent(),
                Value<String> network = const Value.absent(),
                Value<String> lastFour = const Value.absent(),
                Value<int> creditLimitMinor = const Value.absent(),
                Value<int> currentOutstandingMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int?> statementDay = const Value.absent(),
                Value<int?> dueDay = const Value.absent(),
                Value<DateTime?> billingCycleStart = const Value.absent(),
                Value<DateTime?> billingCycleEnd = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> rewardProgramme = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreditCardsCompanion(
                id: id,
                bankId: bankId,
                displayName: displayName,
                cardholderName: cardholderName,
                network: network,
                lastFour: lastFour,
                creditLimitMinor: creditLimitMinor,
                currentOutstandingMinor: currentOutstandingMinor,
                currencyCode: currencyCode,
                statementDay: statementDay,
                dueDay: dueDay,
                billingCycleStart: billingCycleStart,
                billingCycleEnd: billingCycleEnd,
                status: status,
                rewardProgramme: rewardProgramme,
                colorValue: colorValue,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bankId,
                required String displayName,
                Value<String?> cardholderName = const Value.absent(),
                required String network,
                required String lastFour,
                required int creditLimitMinor,
                Value<int> currentOutstandingMinor = const Value.absent(),
                required String currencyCode,
                Value<int?> statementDay = const Value.absent(),
                Value<int?> dueDay = const Value.absent(),
                Value<DateTime?> billingCycleStart = const Value.absent(),
                Value<DateTime?> billingCycleEnd = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> rewardProgramme = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CreditCardsCompanion.insert(
                id: id,
                bankId: bankId,
                displayName: displayName,
                cardholderName: cardholderName,
                network: network,
                lastFour: lastFour,
                creditLimitMinor: creditLimitMinor,
                currentOutstandingMinor: currentOutstandingMinor,
                currencyCode: currencyCode,
                statementDay: statementDay,
                dueDay: dueDay,
                billingCycleStart: billingCycleStart,
                billingCycleEnd: billingCycleEnd,
                status: status,
                rewardProgramme: rewardProgramme,
                colorValue: colorValue,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CreditCardsTable, CreditCardRow>(table),
                  $$CreditCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bankId = false,
                transactionsRefs = false,
                statementsRefs = false,
                cashbackEntriesRefs = false,
                cashbackRulesRefs = false,
                rewardAccountsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (statementsRefs) db.statements,
                    if (cashbackEntriesRefs) db.cashbackEntries,
                    if (cashbackRulesRefs) db.cashbackRules,
                    if (rewardAccountsRefs) db.rewardAccounts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bankId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.bankId,
                            referencedTable: $$CreditCardsTableReferences
                                ._bankIdTable(db),
                            referencedColumn: $$CreditCardsTableReferences
                                ._bankIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          CreditCardRow,
                          $CreditCardsTable,
                          TransactionRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CreditCardsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreditCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_id',
                          typedResults: items,
                        ),
                      if (statementsRefs)
                        await $_getPrefetchedDataByColumns<
                          CreditCardRow,
                          $CreditCardsTable,
                          StatementRow,
                          $StatementsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CreditCardsTableReferences
                              ._statementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreditCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).statementsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_id',
                          typedResults: items,
                        ),
                      if (cashbackEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          CreditCardRow,
                          $CreditCardsTable,
                          CashbackEntryRow,
                          $CashbackEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CreditCardsTableReferences
                              ._cashbackEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreditCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).cashbackEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_id',
                          typedResults: items,
                        ),
                      if (cashbackRulesRefs)
                        await $_getPrefetchedDataByColumns<
                          CreditCardRow,
                          $CreditCardsTable,
                          CashbackRuleRow,
                          $CashbackRulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CreditCardsTableReferences
                              ._cashbackRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreditCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).cashbackRulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_id',
                          typedResults: items,
                        ),
                      if (rewardAccountsRefs)
                        await $_getPrefetchedDataByColumns<
                          CreditCardRow,
                          $CreditCardsTable,
                          RewardAccountRow,
                          $RewardAccountsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CreditCardsTableReferences
                              ._rewardAccountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CreditCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).rewardAccountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CreditCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditCardsTable,
      CreditCardRow,
      $$CreditCardsTableFilterComposer,
      $$CreditCardsTableOrderingComposer,
      $$CreditCardsTableAnnotationComposer,
      $$CreditCardsTableCreateCompanionBuilder,
      $$CreditCardsTableUpdateCompanionBuilder,
      (CreditCardRow, $$CreditCardsTableReferences),
      CreditCardRow,
      PrefetchHooks Function({
        bool bankId,
        bool transactionsRefs,
        bool statementsRefs,
        bool cashbackEntriesRefs,
        bool cashbackRulesRefs,
        bool rewardAccountsRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  Value<String?> parentId,
  Value<bool> isSystemCategory,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> parentId,
  Value<bool> isSystemCategory,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$AppDatabase db) =>
      db.categories.createAlias('categories__parent_id__categories__id');

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<TransactionRow>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CashbackRulesTable, List<CashbackRuleRow>>
  _cashbackRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cashbackRules,
    aliasName: 'categories__id__cashback_rules__category_id',
  );

  $$CashbackRulesTableProcessedTableManager get cashbackRulesRefs {
    final manager = $$CashbackRulesTableTableManager(
      $_db,
      $_db.cashbackRules,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cashbackRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystemCategory => $composableBuilder(
    column: $table.isSystemCategory,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cashbackRulesRefs(
    Expression<bool> Function($$CashbackRulesTableFilterComposer f) f,
  ) {
    final $$CashbackRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashbackRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashbackRulesTableFilterComposer(
            $db: $db,
            $table: $db.cashbackRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystemCategory => $composableBuilder(
    column: $table.isSystemCategory,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isSystemCategory => $composableBuilder(
    column: $table.isSystemCategory,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cashbackRulesRefs<T extends Object>(
    Expression<T> Function($$CashbackRulesTableAnnotationComposer a) f,
  ) {
    final $$CashbackRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashbackRules,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashbackRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.cashbackRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({
            bool parentId,
            bool transactionsRefs,
            bool cashbackRulesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<bool> isSystemCategory = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                parentId: parentId,
                isSystemCategory: isSystemCategory,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentId = const Value.absent(),
                Value<bool> isSystemCategory = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                isSystemCategory: isSystemCategory,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, CategoryRow>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                transactionsRefs = false,
                cashbackRulesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (cashbackRulesRefs) db.cashbackRules,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $$CategoriesTableReferences
                                ._parentIdTable(db),
                            referencedColumn: $$CategoriesTableReferences
                                ._parentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          TransactionRow,
                          $TransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (cashbackRulesRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryRow,
                          $CategoriesTable,
                          CashbackRuleRow,
                          $CashbackRulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._cashbackRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).cashbackRulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({
        bool parentId,
        bool transactionsRefs,
        bool cashbackRulesRefs,
      })
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      Value<String?> cardId,
      Value<String?> bankId,
      Value<String?> merchantOriginal,
      Value<String?> merchantNormalized,
      required int amountMinor,
      required String currencyCode,
      required DateTime transactionDate,
      Value<DateTime?> postingDate,
      required String transactionType,
      Value<String?> categoryId,
      required String status,
      Value<String?> sourceConfidence,
      Value<String?> notes,
      Value<String?> fingerprint,
      Value<int?> fingerprintVersion,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String?> cardId,
      Value<String?> bankId,
      Value<String?> merchantOriginal,
      Value<String?> merchantNormalized,
      Value<int> amountMinor,
      Value<String> currencyCode,
      Value<DateTime> transactionDate,
      Value<DateTime?> postingDate,
      Value<String> transactionType,
      Value<String?> categoryId,
      Value<String> status,
      Value<String?> sourceConfidence,
      Value<String?> notes,
      Value<String?> fingerprint,
      Value<int?> fingerprintVersion,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CreditCardsTable _cardIdTable(_$AppDatabase db) =>
      db.creditCards.createAlias('transactions__card_id__credit_cards__id');

  $$CreditCardsTableProcessedTableManager? get cardId {
    final $_column = $_itemColumn<String>('card_id');
    if ($_column == null) return null;
    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BanksTable _bankIdTable(_$AppDatabase db) =>
      db.banks.createAlias('transactions__bank_id__banks__id');

  $$BanksTableProcessedTableManager? get bankId {
    final $_column = $_itemColumn<String>('bank_id');
    if ($_column == null) return null;
    final manager = $$BanksTableTableManager(
      $_db,
      $_db.banks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TransactionSourcesTable,
    List<TransactionSourceRow>
  >
  _transactionSourcesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionSources,
        aliasName: 'transactions__id__transaction_sources__transaction_id',
      );

  $$TransactionSourcesTableProcessedTableManager get transactionSourcesRefs {
    final manager = $$TransactionSourcesTableTableManager(
      $_db,
      $_db.transactionSources,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionSourcesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $StatementTransactionsTable,
    List<StatementTransactionRow>
  >
  _statementTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.statementTransactions,
        aliasName: 'transactions__id__statement_transactions__transaction_id',
      );

  $$StatementTransactionsTableProcessedTableManager
  get statementTransactionsRefs {
    final manager = $$StatementTransactionsTableTableManager(
      $_db,
      $_db.statementTransactions,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _statementTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CashbackEntriesTable, List<CashbackEntryRow>>
  _cashbackEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cashbackEntries,
    aliasName: 'transactions__id__cashback_entries__transaction_id',
  );

  $$CashbackEntriesTableProcessedTableManager get cashbackEntriesRefs {
    final manager = $$CashbackEntriesTableTableManager(
      $_db,
      $_db.cashbackEntries,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cashbackEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RewardEntriesTable, List<RewardEntryRow>>
  _rewardEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rewardEntries,
    aliasName: 'transactions__id__reward_entries__transaction_id',
  );

  $$RewardEntriesTableProcessedTableManager get rewardEntriesRefs {
    final manager = $$RewardEntriesTableTableManager(
      $_db,
      $_db.rewardEntries,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rewardEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantOriginal => $composableBuilder(
    column: $table.merchantOriginal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantNormalized => $composableBuilder(
    column: $table.merchantNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get postingDate => $composableBuilder(
    column: $table.postingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceConfidence => $composableBuilder(
    column: $table.sourceConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fingerprintVersion => $composableBuilder(
    column: $table.fingerprintVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CreditCardsTableFilterComposer get cardId {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BanksTableFilterComposer get bankId {
    final $$BanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableFilterComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionSourcesRefs(
    Expression<bool> Function($$TransactionSourcesTableFilterComposer f) f,
  ) {
    final $$TransactionSourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionSources,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionSourcesTableFilterComposer(
            $db: $db,
            $table: $db.transactionSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> statementTransactionsRefs(
    Expression<bool> Function($$StatementTransactionsTableFilterComposer f) f,
  ) {
    final $$StatementTransactionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.statementTransactions,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StatementTransactionsTableFilterComposer(
                $db: $db,
                $table: $db.statementTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> cashbackEntriesRefs(
    Expression<bool> Function($$CashbackEntriesTableFilterComposer f) f,
  ) {
    final $$CashbackEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashbackEntries,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashbackEntriesTableFilterComposer(
            $db: $db,
            $table: $db.cashbackEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rewardEntriesRefs(
    Expression<bool> Function($$RewardEntriesTableFilterComposer f) f,
  ) {
    final $$RewardEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewardEntries,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardEntriesTableFilterComposer(
            $db: $db,
            $table: $db.rewardEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantOriginal => $composableBuilder(
    column: $table.merchantOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantNormalized => $composableBuilder(
    column: $table.merchantNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get postingDate => $composableBuilder(
    column: $table.postingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceConfidence => $composableBuilder(
    column: $table.sourceConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fingerprintVersion => $composableBuilder(
    column: $table.fingerprintVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreditCardsTableOrderingComposer get cardId {
    final $$CreditCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableOrderingComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BanksTableOrderingComposer get bankId {
    final $$BanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableOrderingComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get merchantOriginal => $composableBuilder(
    column: $table.merchantOriginal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantNormalized => $composableBuilder(
    column: $table.merchantNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get postingDate => $composableBuilder(
    column: $table.postingDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get sourceConfidence => $composableBuilder(
    column: $table.sourceConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
    column: $table.fingerprint,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fingerprintVersion => $composableBuilder(
    column: $table.fingerprintVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CreditCardsTableAnnotationComposer get cardId {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BanksTableAnnotationComposer get bankId {
    final $$BanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableAnnotationComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionSourcesRefs<T extends Object>(
    Expression<T> Function($$TransactionSourcesTableAnnotationComposer a) f,
  ) {
    final $$TransactionSourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionSources,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionSourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> statementTransactionsRefs<T extends Object>(
    Expression<T> Function($$StatementTransactionsTableAnnotationComposer a) f,
  ) {
    final $$StatementTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.statementTransactions,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StatementTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.statementTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> cashbackEntriesRefs<T extends Object>(
    Expression<T> Function($$CashbackEntriesTableAnnotationComposer a) f,
  ) {
    final $$CashbackEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cashbackEntries,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CashbackEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.cashbackEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rewardEntriesRefs<T extends Object>(
    Expression<T> Function($$RewardEntriesTableAnnotationComposer a) f,
  ) {
    final $$RewardEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewardEntries,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.rewardEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (TransactionRow, $$TransactionsTableReferences),
          TransactionRow,
          PrefetchHooks Function({
            bool cardId,
            bool bankId,
            bool categoryId,
            bool transactionSourcesRefs,
            bool statementTransactionsRefs,
            bool cashbackEntriesRefs,
            bool rewardEntriesRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> cardId = const Value.absent(),
                Value<String?> bankId = const Value.absent(),
                Value<String?> merchantOriginal = const Value.absent(),
                Value<String?> merchantNormalized = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<DateTime?> postingDate = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> sourceConfidence = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> fingerprint = const Value.absent(),
                Value<int?> fingerprintVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                cardId: cardId,
                bankId: bankId,
                merchantOriginal: merchantOriginal,
                merchantNormalized: merchantNormalized,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                transactionDate: transactionDate,
                postingDate: postingDate,
                transactionType: transactionType,
                categoryId: categoryId,
                status: status,
                sourceConfidence: sourceConfidence,
                notes: notes,
                fingerprint: fingerprint,
                fingerprintVersion: fingerprintVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> cardId = const Value.absent(),
                Value<String?> bankId = const Value.absent(),
                Value<String?> merchantOriginal = const Value.absent(),
                Value<String?> merchantNormalized = const Value.absent(),
                required int amountMinor,
                required String currencyCode,
                required DateTime transactionDate,
                Value<DateTime?> postingDate = const Value.absent(),
                required String transactionType,
                Value<String?> categoryId = const Value.absent(),
                required String status,
                Value<String?> sourceConfidence = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> fingerprint = const Value.absent(),
                Value<int?> fingerprintVersion = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                cardId: cardId,
                bankId: bankId,
                merchantOriginal: merchantOriginal,
                merchantNormalized: merchantNormalized,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                transactionDate: transactionDate,
                postingDate: postingDate,
                transactionType: transactionType,
                categoryId: categoryId,
                status: status,
                sourceConfidence: sourceConfidence,
                notes: notes,
                fingerprint: fingerprint,
                fingerprintVersion: fingerprintVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TransactionRow>(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cardId = false,
                bankId = false,
                categoryId = false,
                transactionSourcesRefs = false,
                statementTransactionsRefs = false,
                cashbackEntriesRefs = false,
                rewardEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionSourcesRefs) db.transactionSources,
                    if (statementTransactionsRefs) db.statementTransactions,
                    if (cashbackEntriesRefs) db.cashbackEntries,
                    if (rewardEntriesRefs) db.rewardEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cardId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cardId,
                            referencedTable: $$TransactionsTableReferences
                                ._cardIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._cardIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (bankId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.bankId,
                            referencedTable: $$TransactionsTableReferences
                                ._bankIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._bankIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TransactionsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TransactionsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionSourcesRefs)
                        await $_getPrefetchedDataByColumns<
                          TransactionRow,
                          $TransactionsTable,
                          TransactionSourceRow,
                          $TransactionSourcesTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._transactionSourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionSourcesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transaction_id',
                          typedResults: items,
                        ),
                      if (statementTransactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          TransactionRow,
                          $TransactionsTable,
                          StatementTransactionRow,
                          $StatementTransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._statementTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).statementTransactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transaction_id',
                          typedResults: items,
                        ),
                      if (cashbackEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          TransactionRow,
                          $TransactionsTable,
                          CashbackEntryRow,
                          $CashbackEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._cashbackEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).cashbackEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transaction_id',
                          typedResults: items,
                        ),
                      if (rewardEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          TransactionRow,
                          $TransactionsTable,
                          RewardEntryRow,
                          $RewardEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._rewardEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).rewardEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transaction_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (TransactionRow, $$TransactionsTableReferences),
      TransactionRow,
      PrefetchHooks Function({
        bool cardId,
        bool bankId,
        bool categoryId,
        bool transactionSourcesRefs,
        bool statementTransactionsRefs,
        bool cashbackEntriesRefs,
        bool rewardEntriesRefs,
      })
    >;
typedef $$ImportJobsTableCreateCompanionBuilder = ImportJobsCompanion Function({
  required String id,
  required String sourceType,
  required String status,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  Value<int?> progress,
  Value<int> recordsFound,
  Value<int> recordsImported,
  Value<int> recordsSkipped,
  Value<int> recordsRequiringReview,
  Value<String?> errorCode,
  Value<int> rowid,
});
typedef $$ImportJobsTableUpdateCompanionBuilder = ImportJobsCompanion Function({
  Value<String> id,
  Value<String> sourceType,
  Value<String> status,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<int?> progress,
  Value<int> recordsFound,
  Value<int> recordsImported,
  Value<int> recordsSkipped,
  Value<int> recordsRequiringReview,
  Value<String?> errorCode,
  Value<int> rowid,
});

final class $$ImportJobsTableReferences
    extends BaseReferences<_$AppDatabase, $ImportJobsTable, ImportJobRow> {
  $$ImportJobsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $TransactionSourcesTable,
    List<TransactionSourceRow>
  >
  _transactionSourcesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionSources,
        aliasName: 'import_jobs__id__transaction_sources__import_job_id',
      );

  $$TransactionSourcesTableProcessedTableManager get transactionSourcesRefs {
    final manager = $$TransactionSourcesTableTableManager(
      $_db,
      $_db.transactionSources,
    ).filter((f) => f.importJobId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionSourcesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ImportJobsTableFilterComposer
    extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordsFound => $composableBuilder(
    column: $table.recordsFound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordsImported => $composableBuilder(
    column: $table.recordsImported,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordsSkipped => $composableBuilder(
    column: $table.recordsSkipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordsRequiringReview => $composableBuilder(
    column: $table.recordsRequiringReview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionSourcesRefs(
    Expression<bool> Function($$TransactionSourcesTableFilterComposer f) f,
  ) {
    final $$TransactionSourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionSources,
      getReferencedColumn: (t) => t.importJobId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionSourcesTableFilterComposer(
            $db: $db,
            $table: $db.transactionSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ImportJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordsFound => $composableBuilder(
    column: $table.recordsFound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordsImported => $composableBuilder(
    column: $table.recordsImported,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordsSkipped => $composableBuilder(
    column: $table.recordsSkipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordsRequiringReview => $composableBuilder(
    column: $table.recordsRequiringReview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImportJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImportJobsTable> {
  $$ImportJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get recordsFound => $composableBuilder(
    column: $table.recordsFound,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordsImported => $composableBuilder(
    column: $table.recordsImported,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordsSkipped => $composableBuilder(
    column: $table.recordsSkipped,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordsRequiringReview => $composableBuilder(
    column: $table.recordsRequiringReview,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  Expression<T> transactionSourcesRefs<T extends Object>(
    Expression<T> Function($$TransactionSourcesTableAnnotationComposer a) f,
  ) {
    final $$TransactionSourcesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionSources,
          getReferencedColumn: (t) => t.importJobId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionSourcesTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionSources,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ImportJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ImportJobsTable,
          ImportJobRow,
          $$ImportJobsTableFilterComposer,
          $$ImportJobsTableOrderingComposer,
          $$ImportJobsTableAnnotationComposer,
          $$ImportJobsTableCreateCompanionBuilder,
          $$ImportJobsTableUpdateCompanionBuilder,
          (ImportJobRow, $$ImportJobsTableReferences),
          ImportJobRow,
          PrefetchHooks Function({bool transactionSourcesRefs})
        > {
  $$ImportJobsTableTableManager(_$AppDatabase db, $ImportJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImportJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImportJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImportJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> progress = const Value.absent(),
                Value<int> recordsFound = const Value.absent(),
                Value<int> recordsImported = const Value.absent(),
                Value<int> recordsSkipped = const Value.absent(),
                Value<int> recordsRequiringReview = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportJobsCompanion(
                id: id,
                sourceType: sourceType,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                progress: progress,
                recordsFound: recordsFound,
                recordsImported: recordsImported,
                recordsSkipped: recordsSkipped,
                recordsRequiringReview: recordsRequiringReview,
                errorCode: errorCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceType,
                required String status,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> progress = const Value.absent(),
                Value<int> recordsFound = const Value.absent(),
                Value<int> recordsImported = const Value.absent(),
                Value<int> recordsSkipped = const Value.absent(),
                Value<int> recordsRequiringReview = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImportJobsCompanion.insert(
                id: id,
                sourceType: sourceType,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                progress: progress,
                recordsFound: recordsFound,
                recordsImported: recordsImported,
                recordsSkipped: recordsSkipped,
                recordsRequiringReview: recordsRequiringReview,
                errorCode: errorCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ImportJobsTable, ImportJobRow>(table),
                  $$ImportJobsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionSourcesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionSourcesRefs) db.transactionSources,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionSourcesRefs)
                    await $_getPrefetchedDataByColumns<
                      ImportJobRow,
                      $ImportJobsTable,
                      TransactionSourceRow,
                      $TransactionSourcesTable
                    >(
                      currentTable: table,
                      referencedTable: $$ImportJobsTableReferences
                          ._transactionSourcesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ImportJobsTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionSourcesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'import_job_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ImportJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ImportJobsTable,
      ImportJobRow,
      $$ImportJobsTableFilterComposer,
      $$ImportJobsTableOrderingComposer,
      $$ImportJobsTableAnnotationComposer,
      $$ImportJobsTableCreateCompanionBuilder,
      $$ImportJobsTableUpdateCompanionBuilder,
      (ImportJobRow, $$ImportJobsTableReferences),
      ImportJobRow,
      PrefetchHooks Function({bool transactionSourcesRefs})
    >;
typedef $$TransactionSourcesTableCreateCompanionBuilder =
    TransactionSourcesCompanion Function({
      required String id,
      Value<String?> transactionId,
      required String sourceType,
      Value<String?> sourceReference,
      Value<DateTime?> sourceDate,
      required String originalDescription,
      Value<String?> importJobId,
      Value<String?> parserId,
      Value<String?> parserVersion,
      required String matchStatus,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TransactionSourcesTableUpdateCompanionBuilder =
    TransactionSourcesCompanion Function({
      Value<String> id,
      Value<String?> transactionId,
      Value<String> sourceType,
      Value<String?> sourceReference,
      Value<DateTime?> sourceDate,
      Value<String> originalDescription,
      Value<String?> importJobId,
      Value<String?> parserId,
      Value<String?> parserVersion,
      Value<String> matchStatus,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TransactionSourcesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionSourcesTable,
          TransactionSourceRow
        > {
  $$TransactionSourcesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('transaction_sources__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<String>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ImportJobsTable _importJobIdTable(_$AppDatabase db) => db.importJobs
      .createAlias('transaction_sources__import_job_id__import_jobs__id');

  $$ImportJobsTableProcessedTableManager? get importJobId {
    final $_column = $_itemColumn<String>('import_job_id');
    if ($_column == null) return null;
    final manager = $$ImportJobsTableTableManager(
      $_db,
      $_db.importJobs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_importJobIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionSourcesTable> {
  $$TransactionSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sourceDate => $composableBuilder(
    column: $table.sourceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalDescription => $composableBuilder(
    column: $table.originalDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parserId => $composableBuilder(
    column: $table.parserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchStatus => $composableBuilder(
    column: $table.matchStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportJobsTableFilterComposer get importJobId {
    final $$ImportJobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importJobId,
      referencedTable: $db.importJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportJobsTableFilterComposer(
            $db: $db,
            $table: $db.importJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionSourcesTable> {
  $$TransactionSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sourceDate => $composableBuilder(
    column: $table.sourceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalDescription => $composableBuilder(
    column: $table.originalDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parserId => $composableBuilder(
    column: $table.parserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchStatus => $composableBuilder(
    column: $table.matchStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportJobsTableOrderingComposer get importJobId {
    final $$ImportJobsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importJobId,
      referencedTable: $db.importJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportJobsTableOrderingComposer(
            $db: $db,
            $table: $db.importJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionSourcesTable> {
  $$TransactionSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sourceDate => $composableBuilder(
    column: $table.sourceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalDescription => $composableBuilder(
    column: $table.originalDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parserId =>
      $composableBuilder(column: $table.parserId, builder: (column) => column);

  GeneratedColumn<String> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get matchStatus => $composableBuilder(
    column: $table.matchStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ImportJobsTableAnnotationComposer get importJobId {
    final $$ImportJobsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.importJobId,
      referencedTable: $db.importJobs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImportJobsTableAnnotationComposer(
            $db: $db,
            $table: $db.importJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionSourcesTable,
          TransactionSourceRow,
          $$TransactionSourcesTableFilterComposer,
          $$TransactionSourcesTableOrderingComposer,
          $$TransactionSourcesTableAnnotationComposer,
          $$TransactionSourcesTableCreateCompanionBuilder,
          $$TransactionSourcesTableUpdateCompanionBuilder,
          (TransactionSourceRow, $$TransactionSourcesTableReferences),
          TransactionSourceRow,
          PrefetchHooks Function({bool transactionId, bool importJobId})
        > {
  $$TransactionSourcesTableTableManager(
    _$AppDatabase db,
    $TransactionSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionSourcesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<DateTime?> sourceDate = const Value.absent(),
                Value<String> originalDescription = const Value.absent(),
                Value<String?> importJobId = const Value.absent(),
                Value<String?> parserId = const Value.absent(),
                Value<String?> parserVersion = const Value.absent(),
                Value<String> matchStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionSourcesCompanion(
                id: id,
                transactionId: transactionId,
                sourceType: sourceType,
                sourceReference: sourceReference,
                sourceDate: sourceDate,
                originalDescription: originalDescription,
                importJobId: importJobId,
                parserId: parserId,
                parserVersion: parserVersion,
                matchStatus: matchStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> transactionId = const Value.absent(),
                required String sourceType,
                Value<String?> sourceReference = const Value.absent(),
                Value<DateTime?> sourceDate = const Value.absent(),
                required String originalDescription,
                Value<String?> importJobId = const Value.absent(),
                Value<String?> parserId = const Value.absent(),
                Value<String?> parserVersion = const Value.absent(),
                required String matchStatus,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionSourcesCompanion.insert(
                id: id,
                transactionId: transactionId,
                sourceType: sourceType,
                sourceReference: sourceReference,
                sourceDate: sourceDate,
                originalDescription: originalDescription,
                importJobId: importJobId,
                parserId: parserId,
                parserVersion: parserVersion,
                matchStatus: matchStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionSourcesTable, TransactionSourceRow>(
                    table,
                  ),
                  $$TransactionSourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({transactionId = false, importJobId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (transactionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable: $$TransactionSourcesTableReferences
                                ._transactionIdTable(db),
                            referencedColumn:
                                $$TransactionSourcesTableReferences
                                    ._transactionIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (importJobId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.importJobId,
                            referencedTable: $$TransactionSourcesTableReferences
                                ._importJobIdTable(db),
                            referencedColumn:
                                $$TransactionSourcesTableReferences
                                    ._importJobIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionSourcesTable,
      TransactionSourceRow,
      $$TransactionSourcesTableFilterComposer,
      $$TransactionSourcesTableOrderingComposer,
      $$TransactionSourcesTableAnnotationComposer,
      $$TransactionSourcesTableCreateCompanionBuilder,
      $$TransactionSourcesTableUpdateCompanionBuilder,
      (TransactionSourceRow, $$TransactionSourcesTableReferences),
      TransactionSourceRow,
      PrefetchHooks Function({bool transactionId, bool importJobId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String id,
      required String settingKey,
      Value<String?> encryptedValue,
      Value<String?> plainValue,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> id,
      Value<String> settingKey,
      Value<String?> encryptedValue,
      Value<String?> plainValue,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedValue => $composableBuilder(
    column: $table.encryptedValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plainValue => $composableBuilder(
    column: $table.plainValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedValue => $composableBuilder(
    column: $table.encryptedValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plainValue => $composableBuilder(
    column: $table.plainValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get encryptedValue => $composableBuilder(
    column: $table.encryptedValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plainValue => $composableBuilder(
    column: $table.plainValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> settingKey = const Value.absent(),
                Value<String?> encryptedValue = const Value.absent(),
                Value<String?> plainValue = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                settingKey: settingKey,
                encryptedValue: encryptedValue,
                plainValue: plainValue,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String settingKey,
                Value<String?> encryptedValue = const Value.absent(),
                Value<String?> plainValue = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                settingKey: settingKey,
                encryptedValue: encryptedValue,
                plainValue: plainValue,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSettingRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTable,
                    AppSettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;
typedef $$ReviewItemsTableCreateCompanionBuilder =
    ReviewItemsCompanion Function({
      required String id,
      required String entityType,
      Value<String?> entityId,
      Value<String?> sourceType,
      Value<String?> sourceReference,
      required String reasonCode,
      required String userMessage,
      Value<String?> details,
      Value<String> status,
      required DateTime createdAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });
typedef $$ReviewItemsTableUpdateCompanionBuilder =
    ReviewItemsCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String?> entityId,
      Value<String?> sourceType,
      Value<String?> sourceReference,
      Value<String> reasonCode,
      Value<String> userMessage,
      Value<String?> details,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> resolvedAt,
      Value<int> rowid,
    });

class $$ReviewItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewItemsTable> {
  $$ReviewItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userMessage => $composableBuilder(
    column: $table.userMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewItemsTable> {
  $$ReviewItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userMessage => $composableBuilder(
    column: $table.userMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewItemsTable> {
  $$ReviewItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceReference => $composableBuilder(
    column: $table.sourceReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userMessage => $composableBuilder(
    column: $table.userMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );
}

class $$ReviewItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewItemsTable,
          ReviewItemRow,
          $$ReviewItemsTableFilterComposer,
          $$ReviewItemsTableOrderingComposer,
          $$ReviewItemsTableAnnotationComposer,
          $$ReviewItemsTableCreateCompanionBuilder,
          $$ReviewItemsTableUpdateCompanionBuilder,
          (
            ReviewItemRow,
            BaseReferences<_$AppDatabase, $ReviewItemsTable, ReviewItemRow>,
          ),
          ReviewItemRow,
          PrefetchHooks Function()
        > {
  $$ReviewItemsTableTableManager(_$AppDatabase db, $ReviewItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<String?> sourceType = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                Value<String> reasonCode = const Value.absent(),
                Value<String> userMessage = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewItemsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                sourceType: sourceType,
                sourceReference: sourceReference,
                reasonCode: reasonCode,
                userMessage: userMessage,
                details: details,
                status: status,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                Value<String?> entityId = const Value.absent(),
                Value<String?> sourceType = const Value.absent(),
                Value<String?> sourceReference = const Value.absent(),
                required String reasonCode,
                required String userMessage,
                Value<String?> details = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewItemsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                sourceType: sourceType,
                sourceReference: sourceReference,
                reasonCode: reasonCode,
                userMessage: userMessage,
                details: details,
                status: status,
                createdAt: createdAt,
                resolvedAt: resolvedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewItemsTable, ReviewItemRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ReviewItemsTable,
                    ReviewItemRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewItemsTable,
      ReviewItemRow,
      $$ReviewItemsTableFilterComposer,
      $$ReviewItemsTableOrderingComposer,
      $$ReviewItemsTableAnnotationComposer,
      $$ReviewItemsTableCreateCompanionBuilder,
      $$ReviewItemsTableUpdateCompanionBuilder,
      (
        ReviewItemRow,
        BaseReferences<_$AppDatabase, $ReviewItemsTable, ReviewItemRow>,
      ),
      ReviewItemRow,
      PrefetchHooks Function()
    >;
typedef $$StatementsTableCreateCompanionBuilder = StatementsCompanion Function({
  required String id,
  Value<String?> cardId,
  Value<String?> bankId,
  required DateTime statementPeriodStart,
  required DateTime statementPeriodEnd,
  required DateTime statementDate,
  Value<DateTime?> paymentDueDate,
  Value<int> previousBalanceMinor,
  Value<int> totalDueMinor,
  Value<int> minimumDueMinor,
  required String currencyCode,
  required String encryptedFilePath,
  required String fileHash,
  Value<int> fileSizeBytes,
  required String processingStatus,
  Value<String?> parserId,
  Value<String?> parserVersion,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$StatementsTableUpdateCompanionBuilder = StatementsCompanion Function({
  Value<String> id,
  Value<String?> cardId,
  Value<String?> bankId,
  Value<DateTime> statementPeriodStart,
  Value<DateTime> statementPeriodEnd,
  Value<DateTime> statementDate,
  Value<DateTime?> paymentDueDate,
  Value<int> previousBalanceMinor,
  Value<int> totalDueMinor,
  Value<int> minimumDueMinor,
  Value<String> currencyCode,
  Value<String> encryptedFilePath,
  Value<String> fileHash,
  Value<int> fileSizeBytes,
  Value<String> processingStatus,
  Value<String?> parserId,
  Value<String?> parserVersion,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$StatementsTableReferences
    extends BaseReferences<_$AppDatabase, $StatementsTable, StatementRow> {
  $$StatementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CreditCardsTable _cardIdTable(_$AppDatabase db) =>
      db.creditCards.createAlias('statements__card_id__credit_cards__id');

  $$CreditCardsTableProcessedTableManager? get cardId {
    final $_column = $_itemColumn<String>('card_id');
    if ($_column == null) return null;
    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BanksTable _bankIdTable(_$AppDatabase db) =>
      db.banks.createAlias('statements__bank_id__banks__id');

  $$BanksTableProcessedTableManager? get bankId {
    final $_column = $_itemColumn<String>('bank_id');
    if ($_column == null) return null;
    final manager = $$BanksTableTableManager(
      $_db,
      $_db.banks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $StatementTransactionsTable,
    List<StatementTransactionRow>
  >
  _statementTransactionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.statementTransactions,
        aliasName: 'statements__id__statement_transactions__statement_id',
      );

  $$StatementTransactionsTableProcessedTableManager
  get statementTransactionsRefs {
    final manager = $$StatementTransactionsTableTableManager(
      $_db,
      $_db.statementTransactions,
    ).filter((f) => f.statementId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _statementTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StatementsTableFilterComposer
    extends Composer<_$AppDatabase, $StatementsTable> {
  $$StatementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get statementPeriodStart => $composableBuilder(
    column: $table.statementPeriodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get statementPeriodEnd => $composableBuilder(
    column: $table.statementPeriodEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get statementDate => $composableBuilder(
    column: $table.statementDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentDueDate => $composableBuilder(
    column: $table.paymentDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get previousBalanceMinor => $composableBuilder(
    column: $table.previousBalanceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDueMinor => $composableBuilder(
    column: $table.totalDueMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumDueMinor => $composableBuilder(
    column: $table.minimumDueMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get encryptedFilePath => $composableBuilder(
    column: $table.encryptedFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processingStatus => $composableBuilder(
    column: $table.processingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parserId => $composableBuilder(
    column: $table.parserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CreditCardsTableFilterComposer get cardId {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BanksTableFilterComposer get bankId {
    final $$BanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableFilterComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> statementTransactionsRefs(
    Expression<bool> Function($$StatementTransactionsTableFilterComposer f) f,
  ) {
    final $$StatementTransactionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.statementTransactions,
          getReferencedColumn: (t) => t.statementId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StatementTransactionsTableFilterComposer(
                $db: $db,
                $table: $db.statementTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StatementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StatementsTable> {
  $$StatementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get statementPeriodStart => $composableBuilder(
    column: $table.statementPeriodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get statementPeriodEnd => $composableBuilder(
    column: $table.statementPeriodEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get statementDate => $composableBuilder(
    column: $table.statementDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDueDate => $composableBuilder(
    column: $table.paymentDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get previousBalanceMinor => $composableBuilder(
    column: $table.previousBalanceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDueMinor => $composableBuilder(
    column: $table.totalDueMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumDueMinor => $composableBuilder(
    column: $table.minimumDueMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get encryptedFilePath => $composableBuilder(
    column: $table.encryptedFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processingStatus => $composableBuilder(
    column: $table.processingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parserId => $composableBuilder(
    column: $table.parserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreditCardsTableOrderingComposer get cardId {
    final $$CreditCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableOrderingComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BanksTableOrderingComposer get bankId {
    final $$BanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableOrderingComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StatementsTable> {
  $$StatementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get statementPeriodStart => $composableBuilder(
    column: $table.statementPeriodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get statementPeriodEnd => $composableBuilder(
    column: $table.statementPeriodEnd,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get statementDate => $composableBuilder(
    column: $table.statementDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paymentDueDate => $composableBuilder(
    column: $table.paymentDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get previousBalanceMinor => $composableBuilder(
    column: $table.previousBalanceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDueMinor => $composableBuilder(
    column: $table.totalDueMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumDueMinor => $composableBuilder(
    column: $table.minimumDueMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get encryptedFilePath => $composableBuilder(
    column: $table.encryptedFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processingStatus => $composableBuilder(
    column: $table.processingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parserId =>
      $composableBuilder(column: $table.parserId, builder: (column) => column);

  GeneratedColumn<String> get parserVersion => $composableBuilder(
    column: $table.parserVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CreditCardsTableAnnotationComposer get cardId {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BanksTableAnnotationComposer get bankId {
    final $$BanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableAnnotationComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> statementTransactionsRefs<T extends Object>(
    Expression<T> Function($$StatementTransactionsTableAnnotationComposer a) f,
  ) {
    final $$StatementTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.statementTransactions,
          getReferencedColumn: (t) => t.statementId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StatementTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.statementTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StatementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StatementsTable,
          StatementRow,
          $$StatementsTableFilterComposer,
          $$StatementsTableOrderingComposer,
          $$StatementsTableAnnotationComposer,
          $$StatementsTableCreateCompanionBuilder,
          $$StatementsTableUpdateCompanionBuilder,
          (StatementRow, $$StatementsTableReferences),
          StatementRow,
          PrefetchHooks Function({
            bool cardId,
            bool bankId,
            bool statementTransactionsRefs,
          })
        > {
  $$StatementsTableTableManager(_$AppDatabase db, $StatementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StatementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StatementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StatementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> cardId = const Value.absent(),
                Value<String?> bankId = const Value.absent(),
                Value<DateTime> statementPeriodStart = const Value.absent(),
                Value<DateTime> statementPeriodEnd = const Value.absent(),
                Value<DateTime> statementDate = const Value.absent(),
                Value<DateTime?> paymentDueDate = const Value.absent(),
                Value<int> previousBalanceMinor = const Value.absent(),
                Value<int> totalDueMinor = const Value.absent(),
                Value<int> minimumDueMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> encryptedFilePath = const Value.absent(),
                Value<String> fileHash = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<String> processingStatus = const Value.absent(),
                Value<String?> parserId = const Value.absent(),
                Value<String?> parserVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StatementsCompanion(
                id: id,
                cardId: cardId,
                bankId: bankId,
                statementPeriodStart: statementPeriodStart,
                statementPeriodEnd: statementPeriodEnd,
                statementDate: statementDate,
                paymentDueDate: paymentDueDate,
                previousBalanceMinor: previousBalanceMinor,
                totalDueMinor: totalDueMinor,
                minimumDueMinor: minimumDueMinor,
                currencyCode: currencyCode,
                encryptedFilePath: encryptedFilePath,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                processingStatus: processingStatus,
                parserId: parserId,
                parserVersion: parserVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> cardId = const Value.absent(),
                Value<String?> bankId = const Value.absent(),
                required DateTime statementPeriodStart,
                required DateTime statementPeriodEnd,
                required DateTime statementDate,
                Value<DateTime?> paymentDueDate = const Value.absent(),
                Value<int> previousBalanceMinor = const Value.absent(),
                Value<int> totalDueMinor = const Value.absent(),
                Value<int> minimumDueMinor = const Value.absent(),
                required String currencyCode,
                required String encryptedFilePath,
                required String fileHash,
                Value<int> fileSizeBytes = const Value.absent(),
                required String processingStatus,
                Value<String?> parserId = const Value.absent(),
                Value<String?> parserVersion = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StatementsCompanion.insert(
                id: id,
                cardId: cardId,
                bankId: bankId,
                statementPeriodStart: statementPeriodStart,
                statementPeriodEnd: statementPeriodEnd,
                statementDate: statementDate,
                paymentDueDate: paymentDueDate,
                previousBalanceMinor: previousBalanceMinor,
                totalDueMinor: totalDueMinor,
                minimumDueMinor: minimumDueMinor,
                currencyCode: currencyCode,
                encryptedFilePath: encryptedFilePath,
                fileHash: fileHash,
                fileSizeBytes: fileSizeBytes,
                processingStatus: processingStatus,
                parserId: parserId,
                parserVersion: parserVersion,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StatementsTable, StatementRow>(table),
                  $$StatementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cardId = false,
                bankId = false,
                statementTransactionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (statementTransactionsRefs) db.statementTransactions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cardId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cardId,
                            referencedTable: $$StatementsTableReferences
                                ._cardIdTable(db),
                            referencedColumn: $$StatementsTableReferences
                                ._cardIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (bankId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.bankId,
                            referencedTable: $$StatementsTableReferences
                                ._bankIdTable(db),
                            referencedColumn: $$StatementsTableReferences
                                ._bankIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (statementTransactionsRefs)
                        await $_getPrefetchedDataByColumns<
                          StatementRow,
                          $StatementsTable,
                          StatementTransactionRow,
                          $StatementTransactionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$StatementsTableReferences
                              ._statementTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StatementsTableReferences(
                                db,
                                table,
                                p0,
                              ).statementTransactionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'statement_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StatementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StatementsTable,
      StatementRow,
      $$StatementsTableFilterComposer,
      $$StatementsTableOrderingComposer,
      $$StatementsTableAnnotationComposer,
      $$StatementsTableCreateCompanionBuilder,
      $$StatementsTableUpdateCompanionBuilder,
      (StatementRow, $$StatementsTableReferences),
      StatementRow,
      PrefetchHooks Function({
        bool cardId,
        bool bankId,
        bool statementTransactionsRefs,
      })
    >;
typedef $$StatementTransactionsTableCreateCompanionBuilder =
    StatementTransactionsCompanion Function({
      required String id,
      required String statementId,
      Value<String?> transactionId,
      required String description,
      Value<String?> merchantNormalized,
      required int amountMinor,
      required String currencyCode,
      required DateTime transactionDate,
      Value<DateTime?> postingDate,
      required String transactionType,
      required String matchStatus,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StatementTransactionsTableUpdateCompanionBuilder =
    StatementTransactionsCompanion Function({
      Value<String> id,
      Value<String> statementId,
      Value<String?> transactionId,
      Value<String> description,
      Value<String?> merchantNormalized,
      Value<int> amountMinor,
      Value<String> currencyCode,
      Value<DateTime> transactionDate,
      Value<DateTime?> postingDate,
      Value<String> transactionType,
      Value<String> matchStatus,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StatementTransactionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StatementTransactionsTable,
          StatementTransactionRow
        > {
  $$StatementTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StatementsTable _statementIdTable(_$AppDatabase db) => db.statements
      .createAlias('statement_transactions__statement_id__statements__id');

  $$StatementsTableProcessedTableManager get statementId {
    final $_column = $_itemColumn<String>('statement_id')!;

    final manager = $$StatementsTableTableManager(
      $_db,
      $_db.statements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_statementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('statement_transactions__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<String>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StatementTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $StatementTransactionsTable> {
  $$StatementTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantNormalized => $composableBuilder(
    column: $table.merchantNormalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get postingDate => $composableBuilder(
    column: $table.postingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchStatus => $composableBuilder(
    column: $table.matchStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StatementsTableFilterComposer get statementId {
    final $$StatementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.statementId,
      referencedTable: $db.statements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatementsTableFilterComposer(
            $db: $db,
            $table: $db.statements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatementTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StatementTransactionsTable> {
  $$StatementTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantNormalized => $composableBuilder(
    column: $table.merchantNormalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get postingDate => $composableBuilder(
    column: $table.postingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchStatus => $composableBuilder(
    column: $table.matchStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StatementsTableOrderingComposer get statementId {
    final $$StatementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.statementId,
      referencedTable: $db.statements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatementsTableOrderingComposer(
            $db: $db,
            $table: $db.statements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatementTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StatementTransactionsTable> {
  $$StatementTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantNormalized => $composableBuilder(
    column: $table.merchantNormalized,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get postingDate => $composableBuilder(
    column: $table.postingDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get matchStatus => $composableBuilder(
    column: $table.matchStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StatementsTableAnnotationComposer get statementId {
    final $$StatementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.statementId,
      referencedTable: $db.statements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatementsTableAnnotationComposer(
            $db: $db,
            $table: $db.statements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatementTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StatementTransactionsTable,
          StatementTransactionRow,
          $$StatementTransactionsTableFilterComposer,
          $$StatementTransactionsTableOrderingComposer,
          $$StatementTransactionsTableAnnotationComposer,
          $$StatementTransactionsTableCreateCompanionBuilder,
          $$StatementTransactionsTableUpdateCompanionBuilder,
          (StatementTransactionRow, $$StatementTransactionsTableReferences),
          StatementTransactionRow,
          PrefetchHooks Function({bool statementId, bool transactionId})
        > {
  $$StatementTransactionsTableTableManager(
    _$AppDatabase db,
    $StatementTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StatementTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StatementTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StatementTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> statementId = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> merchantNormalized = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<DateTime?> postingDate = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<String> matchStatus = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StatementTransactionsCompanion(
                id: id,
                statementId: statementId,
                transactionId: transactionId,
                description: description,
                merchantNormalized: merchantNormalized,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                transactionDate: transactionDate,
                postingDate: postingDate,
                transactionType: transactionType,
                matchStatus: matchStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String statementId,
                Value<String?> transactionId = const Value.absent(),
                required String description,
                Value<String?> merchantNormalized = const Value.absent(),
                required int amountMinor,
                required String currencyCode,
                required DateTime transactionDate,
                Value<DateTime?> postingDate = const Value.absent(),
                required String transactionType,
                required String matchStatus,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StatementTransactionsCompanion.insert(
                id: id,
                statementId: statementId,
                transactionId: transactionId,
                description: description,
                merchantNormalized: merchantNormalized,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                transactionDate: transactionDate,
                postingDate: postingDate,
                transactionType: transactionType,
                matchStatus: matchStatus,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $StatementTransactionsTable,
                    StatementTransactionRow
                  >(table),
                  $$StatementTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({statementId = false, transactionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (statementId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.statementId,
                            referencedTable:
                                $$StatementTransactionsTableReferences
                                    ._statementIdTable(db),
                            referencedColumn:
                                $$StatementTransactionsTableReferences
                                    ._statementIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (transactionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable:
                                $$StatementTransactionsTableReferences
                                    ._transactionIdTable(db),
                            referencedColumn:
                                $$StatementTransactionsTableReferences
                                    ._transactionIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$StatementTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StatementTransactionsTable,
      StatementTransactionRow,
      $$StatementTransactionsTableFilterComposer,
      $$StatementTransactionsTableOrderingComposer,
      $$StatementTransactionsTableAnnotationComposer,
      $$StatementTransactionsTableCreateCompanionBuilder,
      $$StatementTransactionsTableUpdateCompanionBuilder,
      (StatementTransactionRow, $$StatementTransactionsTableReferences),
      StatementTransactionRow,
      PrefetchHooks Function({bool statementId, bool transactionId})
    >;
typedef $$CashbackEntriesTableCreateCompanionBuilder =
    CashbackEntriesCompanion Function({
      required String id,
      required String cardId,
      Value<String?> transactionId,
      required int amountMinor,
      required String currencyCode,
      required String status,
      required DateTime earnedAt,
      Value<DateTime?> creditedAt,
      Value<DateTime?> reversedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CashbackEntriesTableUpdateCompanionBuilder =
    CashbackEntriesCompanion Function({
      Value<String> id,
      Value<String> cardId,
      Value<String?> transactionId,
      Value<int> amountMinor,
      Value<String> currencyCode,
      Value<String> status,
      Value<DateTime> earnedAt,
      Value<DateTime?> creditedAt,
      Value<DateTime?> reversedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CashbackEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $CashbackEntriesTable, CashbackEntryRow> {
  $$CashbackEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreditCardsTable _cardIdTable(_$AppDatabase db) =>
      db.creditCards.createAlias('cashback_entries__card_id__credit_cards__id');

  $$CreditCardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('cashback_entries__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<String>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CashbackEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CashbackEntriesTable> {
  $$CashbackEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creditedAt => $composableBuilder(
    column: $table.creditedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CreditCardsTableFilterComposer get cardId {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashbackEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CashbackEntriesTable> {
  $$CashbackEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get earnedAt => $composableBuilder(
    column: $table.earnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creditedAt => $composableBuilder(
    column: $table.creditedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreditCardsTableOrderingComposer get cardId {
    final $$CreditCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableOrderingComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashbackEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashbackEntriesTable> {
  $$CashbackEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get earnedAt =>
      $composableBuilder(column: $table.earnedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get creditedAt => $composableBuilder(
    column: $table.creditedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reversedAt => $composableBuilder(
    column: $table.reversedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CreditCardsTableAnnotationComposer get cardId {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashbackEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashbackEntriesTable,
          CashbackEntryRow,
          $$CashbackEntriesTableFilterComposer,
          $$CashbackEntriesTableOrderingComposer,
          $$CashbackEntriesTableAnnotationComposer,
          $$CashbackEntriesTableCreateCompanionBuilder,
          $$CashbackEntriesTableUpdateCompanionBuilder,
          (CashbackEntryRow, $$CashbackEntriesTableReferences),
          CashbackEntryRow,
          PrefetchHooks Function({bool cardId, bool transactionId})
        > {
  $$CashbackEntriesTableTableManager(
    _$AppDatabase db,
    $CashbackEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashbackEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashbackEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashbackEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> earnedAt = const Value.absent(),
                Value<DateTime?> creditedAt = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashbackEntriesCompanion(
                id: id,
                cardId: cardId,
                transactionId: transactionId,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                status: status,
                earnedAt: earnedAt,
                creditedAt: creditedAt,
                reversedAt: reversedAt,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardId,
                Value<String?> transactionId = const Value.absent(),
                required int amountMinor,
                required String currencyCode,
                required String status,
                required DateTime earnedAt,
                Value<DateTime?> creditedAt = const Value.absent(),
                Value<DateTime?> reversedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CashbackEntriesCompanion.insert(
                id: id,
                cardId: cardId,
                transactionId: transactionId,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                status: status,
                earnedAt: earnedAt,
                creditedAt: creditedAt,
                reversedAt: reversedAt,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CashbackEntriesTable, CashbackEntryRow>(table),
                  $$CashbackEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false, transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$CashbackEntriesTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$CashbackEntriesTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (transactionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.transactionId,
                        referencedTable: $$CashbackEntriesTableReferences
                            ._transactionIdTable(db),
                        referencedColumn: $$CashbackEntriesTableReferences
                            ._transactionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CashbackEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashbackEntriesTable,
      CashbackEntryRow,
      $$CashbackEntriesTableFilterComposer,
      $$CashbackEntriesTableOrderingComposer,
      $$CashbackEntriesTableAnnotationComposer,
      $$CashbackEntriesTableCreateCompanionBuilder,
      $$CashbackEntriesTableUpdateCompanionBuilder,
      (CashbackEntryRow, $$CashbackEntriesTableReferences),
      CashbackEntryRow,
      PrefetchHooks Function({bool cardId, bool transactionId})
    >;
typedef $$CashbackRulesTableCreateCompanionBuilder =
    CashbackRulesCompanion Function({
      required String id,
      required String cardId,
      required String kind,
      Value<int?> rateBasisPoints,
      Value<int?> flatAmountMinor,
      Value<String?> categoryId,
      Value<String?> merchantContains,
      Value<int?> monthlyCapMinor,
      required String currencyCode,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CashbackRulesTableUpdateCompanionBuilder =
    CashbackRulesCompanion Function({
      Value<String> id,
      Value<String> cardId,
      Value<String> kind,
      Value<int?> rateBasisPoints,
      Value<int?> flatAmountMinor,
      Value<String?> categoryId,
      Value<String?> merchantContains,
      Value<int?> monthlyCapMinor,
      Value<String> currencyCode,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CashbackRulesTableReferences
    extends
        BaseReferences<_$AppDatabase, $CashbackRulesTable, CashbackRuleRow> {
  $$CashbackRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreditCardsTable _cardIdTable(_$AppDatabase db) =>
      db.creditCards.createAlias('cashback_rules__card_id__credit_cards__id');

  $$CreditCardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('cashback_rules__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CashbackRulesTableFilterComposer
    extends Composer<_$AppDatabase, $CashbackRulesTable> {
  $$CashbackRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rateBasisPoints => $composableBuilder(
    column: $table.rateBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flatAmountMinor => $composableBuilder(
    column: $table.flatAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchantContains => $composableBuilder(
    column: $table.merchantContains,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyCapMinor => $composableBuilder(
    column: $table.monthlyCapMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CreditCardsTableFilterComposer get cardId {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashbackRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CashbackRulesTable> {
  $$CashbackRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rateBasisPoints => $composableBuilder(
    column: $table.rateBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flatAmountMinor => $composableBuilder(
    column: $table.flatAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchantContains => $composableBuilder(
    column: $table.merchantContains,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyCapMinor => $composableBuilder(
    column: $table.monthlyCapMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreditCardsTableOrderingComposer get cardId {
    final $$CreditCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableOrderingComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashbackRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashbackRulesTable> {
  $$CashbackRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get rateBasisPoints => $composableBuilder(
    column: $table.rateBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get flatAmountMinor => $composableBuilder(
    column: $table.flatAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchantContains => $composableBuilder(
    column: $table.merchantContains,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyCapMinor => $composableBuilder(
    column: $table.monthlyCapMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CreditCardsTableAnnotationComposer get cardId {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CashbackRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashbackRulesTable,
          CashbackRuleRow,
          $$CashbackRulesTableFilterComposer,
          $$CashbackRulesTableOrderingComposer,
          $$CashbackRulesTableAnnotationComposer,
          $$CashbackRulesTableCreateCompanionBuilder,
          $$CashbackRulesTableUpdateCompanionBuilder,
          (CashbackRuleRow, $$CashbackRulesTableReferences),
          CashbackRuleRow,
          PrefetchHooks Function({bool cardId, bool categoryId})
        > {
  $$CashbackRulesTableTableManager(_$AppDatabase db, $CashbackRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashbackRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashbackRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashbackRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> rateBasisPoints = const Value.absent(),
                Value<int?> flatAmountMinor = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> merchantContains = const Value.absent(),
                Value<int?> monthlyCapMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashbackRulesCompanion(
                id: id,
                cardId: cardId,
                kind: kind,
                rateBasisPoints: rateBasisPoints,
                flatAmountMinor: flatAmountMinor,
                categoryId: categoryId,
                merchantContains: merchantContains,
                monthlyCapMinor: monthlyCapMinor,
                currencyCode: currencyCode,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardId,
                required String kind,
                Value<int?> rateBasisPoints = const Value.absent(),
                Value<int?> flatAmountMinor = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> merchantContains = const Value.absent(),
                Value<int?> monthlyCapMinor = const Value.absent(),
                required String currencyCode,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CashbackRulesCompanion.insert(
                id: id,
                cardId: cardId,
                kind: kind,
                rateBasisPoints: rateBasisPoints,
                flatAmountMinor: flatAmountMinor,
                categoryId: categoryId,
                merchantContains: merchantContains,
                monthlyCapMinor: monthlyCapMinor,
                currencyCode: currencyCode,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CashbackRulesTable, CashbackRuleRow>(table),
                  $$CashbackRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$CashbackRulesTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$CashbackRulesTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$CashbackRulesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$CashbackRulesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CashbackRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashbackRulesTable,
      CashbackRuleRow,
      $$CashbackRulesTableFilterComposer,
      $$CashbackRulesTableOrderingComposer,
      $$CashbackRulesTableAnnotationComposer,
      $$CashbackRulesTableCreateCompanionBuilder,
      $$CashbackRulesTableUpdateCompanionBuilder,
      (CashbackRuleRow, $$CashbackRulesTableReferences),
      CashbackRuleRow,
      PrefetchHooks Function({bool cardId, bool categoryId})
    >;
typedef $$RewardAccountsTableCreateCompanionBuilder =
    RewardAccountsCompanion Function({
      required String id,
      required String cardId,
      required String programmeName,
      Value<int> currentPoints,
      Value<int?> estimatedValueMinor,
      Value<String?> currencyCode,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RewardAccountsTableUpdateCompanionBuilder =
    RewardAccountsCompanion Function({
      Value<String> id,
      Value<String> cardId,
      Value<String> programmeName,
      Value<int> currentPoints,
      Value<int?> estimatedValueMinor,
      Value<String?> currencyCode,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RewardAccountsTableReferences
    extends
        BaseReferences<_$AppDatabase, $RewardAccountsTable, RewardAccountRow> {
  $$RewardAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CreditCardsTable _cardIdTable(_$AppDatabase db) =>
      db.creditCards.createAlias('reward_accounts__card_id__credit_cards__id');

  $$CreditCardsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $$CreditCardsTableTableManager(
      $_db,
      $_db.creditCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RewardEntriesTable, List<RewardEntryRow>>
  _rewardEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rewardEntries,
    aliasName: 'reward_accounts__id__reward_entries__reward_account_id',
  );

  $$RewardEntriesTableProcessedTableManager get rewardEntriesRefs {
    final manager = $$RewardEntriesTableTableManager($_db, $_db.rewardEntries)
        .filter(
          (f) => f.rewardAccountId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_rewardEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RewardAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $RewardAccountsTable> {
  $$RewardAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programmeName => $composableBuilder(
    column: $table.programmeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentPoints => $composableBuilder(
    column: $table.currentPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedValueMinor => $composableBuilder(
    column: $table.estimatedValueMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CreditCardsTableFilterComposer get cardId {
    final $$CreditCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableFilterComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> rewardEntriesRefs(
    Expression<bool> Function($$RewardEntriesTableFilterComposer f) f,
  ) {
    final $$RewardEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewardEntries,
      getReferencedColumn: (t) => t.rewardAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardEntriesTableFilterComposer(
            $db: $db,
            $table: $db.rewardEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RewardAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardAccountsTable> {
  $$RewardAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programmeName => $composableBuilder(
    column: $table.programmeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentPoints => $composableBuilder(
    column: $table.currentPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedValueMinor => $composableBuilder(
    column: $table.estimatedValueMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CreditCardsTableOrderingComposer get cardId {
    final $$CreditCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableOrderingComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardAccountsTable> {
  $$RewardAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get programmeName => $composableBuilder(
    column: $table.programmeName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentPoints => $composableBuilder(
    column: $table.currentPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedValueMinor => $composableBuilder(
    column: $table.estimatedValueMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CreditCardsTableAnnotationComposer get cardId {
    final $$CreditCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.creditCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CreditCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.creditCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> rewardEntriesRefs<T extends Object>(
    Expression<T> Function($$RewardEntriesTableAnnotationComposer a) f,
  ) {
    final $$RewardEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewardEntries,
      getReferencedColumn: (t) => t.rewardAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.rewardEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RewardAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardAccountsTable,
          RewardAccountRow,
          $$RewardAccountsTableFilterComposer,
          $$RewardAccountsTableOrderingComposer,
          $$RewardAccountsTableAnnotationComposer,
          $$RewardAccountsTableCreateCompanionBuilder,
          $$RewardAccountsTableUpdateCompanionBuilder,
          (RewardAccountRow, $$RewardAccountsTableReferences),
          RewardAccountRow,
          PrefetchHooks Function({bool cardId, bool rewardEntriesRefs})
        > {
  $$RewardAccountsTableTableManager(
    _$AppDatabase db,
    $RewardAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> programmeName = const Value.absent(),
                Value<int> currentPoints = const Value.absent(),
                Value<int?> estimatedValueMinor = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardAccountsCompanion(
                id: id,
                cardId: cardId,
                programmeName: programmeName,
                currentPoints: currentPoints,
                estimatedValueMinor: estimatedValueMinor,
                currencyCode: currencyCode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String cardId,
                required String programmeName,
                Value<int> currentPoints = const Value.absent(),
                Value<int?> estimatedValueMinor = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RewardAccountsCompanion.insert(
                id: id,
                cardId: cardId,
                programmeName: programmeName,
                currentPoints: currentPoints,
                estimatedValueMinor: estimatedValueMinor,
                currencyCode: currencyCode,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RewardAccountsTable, RewardAccountRow>(table),
                  $$RewardAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false, rewardEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (rewardEntriesRefs) db.rewardEntries,
              ],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.cardId,
                        referencedTable: $$RewardAccountsTableReferences
                            ._cardIdTable(db),
                        referencedColumn: $$RewardAccountsTableReferences
                            ._cardIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (rewardEntriesRefs)
                    await $_getPrefetchedDataByColumns<
                      RewardAccountRow,
                      $RewardAccountsTable,
                      RewardEntryRow,
                      $RewardEntriesTable
                    >(
                      currentTable: table,
                      referencedTable: $$RewardAccountsTableReferences
                          ._rewardEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RewardAccountsTableReferences(
                            db,
                            table,
                            p0,
                          ).rewardEntriesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'reward_account_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RewardAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardAccountsTable,
      RewardAccountRow,
      $$RewardAccountsTableFilterComposer,
      $$RewardAccountsTableOrderingComposer,
      $$RewardAccountsTableAnnotationComposer,
      $$RewardAccountsTableCreateCompanionBuilder,
      $$RewardAccountsTableUpdateCompanionBuilder,
      (RewardAccountRow, $$RewardAccountsTableReferences),
      RewardAccountRow,
      PrefetchHooks Function({bool cardId, bool rewardEntriesRefs})
    >;
typedef $$RewardEntriesTableCreateCompanionBuilder =
    RewardEntriesCompanion Function({
      required String id,
      required String rewardAccountId,
      Value<String?> transactionId,
      required int points,
      required String entryType,
      Value<String?> description,
      Value<DateTime?> expiresAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RewardEntriesTableUpdateCompanionBuilder =
    RewardEntriesCompanion Function({
      Value<String> id,
      Value<String> rewardAccountId,
      Value<String?> transactionId,
      Value<int> points,
      Value<String> entryType,
      Value<String?> description,
      Value<DateTime?> expiresAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$RewardEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $RewardEntriesTable, RewardEntryRow> {
  $$RewardEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RewardAccountsTable _rewardAccountIdTable(_$AppDatabase db) => db
      .rewardAccounts
      .createAlias('reward_entries__reward_account_id__reward_accounts__id');

  $$RewardAccountsTableProcessedTableManager get rewardAccountId {
    final $_column = $_itemColumn<String>('reward_account_id')!;

    final manager = $$RewardAccountsTableTableManager(
      $_db,
      $_db.rewardAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rewardAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('reward_entries__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<String>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RewardEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $RewardEntriesTable> {
  $$RewardEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryType => $composableBuilder(
    column: $table.entryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RewardAccountsTableFilterComposer get rewardAccountId {
    final $$RewardAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardAccountId,
      referencedTable: $db.rewardAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardAccountsTableFilterComposer(
            $db: $db,
            $table: $db.rewardAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardEntriesTable> {
  $$RewardEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryType => $composableBuilder(
    column: $table.entryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RewardAccountsTableOrderingComposer get rewardAccountId {
    final $$RewardAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardAccountId,
      referencedTable: $db.rewardAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.rewardAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardEntriesTable> {
  $$RewardEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<String> get entryType =>
      $composableBuilder(column: $table.entryType, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$RewardAccountsTableAnnotationComposer get rewardAccountId {
    final $$RewardAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rewardAccountId,
      referencedTable: $db.rewardAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.rewardAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardEntriesTable,
          RewardEntryRow,
          $$RewardEntriesTableFilterComposer,
          $$RewardEntriesTableOrderingComposer,
          $$RewardEntriesTableAnnotationComposer,
          $$RewardEntriesTableCreateCompanionBuilder,
          $$RewardEntriesTableUpdateCompanionBuilder,
          (RewardEntryRow, $$RewardEntriesTableReferences),
          RewardEntryRow,
          PrefetchHooks Function({bool rewardAccountId, bool transactionId})
        > {
  $$RewardEntriesTableTableManager(_$AppDatabase db, $RewardEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rewardAccountId = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<String> entryType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardEntriesCompanion(
                id: id,
                rewardAccountId: rewardAccountId,
                transactionId: transactionId,
                points: points,
                entryType: entryType,
                description: description,
                expiresAt: expiresAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rewardAccountId,
                Value<String?> transactionId = const Value.absent(),
                required int points,
                required String entryType,
                Value<String?> description = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RewardEntriesCompanion.insert(
                id: id,
                rewardAccountId: rewardAccountId,
                transactionId: transactionId,
                points: points,
                entryType: entryType,
                description: description,
                expiresAt: expiresAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RewardEntriesTable, RewardEntryRow>(table),
                  $$RewardEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({rewardAccountId = false, transactionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (rewardAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.rewardAccountId,
                            referencedTable: $$RewardEntriesTableReferences
                                ._rewardAccountIdTable(db),
                            referencedColumn: $$RewardEntriesTableReferences
                                ._rewardAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (transactionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.transactionId,
                            referencedTable: $$RewardEntriesTableReferences
                                ._transactionIdTable(db),
                            referencedColumn: $$RewardEntriesTableReferences
                                ._transactionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RewardEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardEntriesTable,
      RewardEntryRow,
      $$RewardEntriesTableFilterComposer,
      $$RewardEntriesTableOrderingComposer,
      $$RewardEntriesTableAnnotationComposer,
      $$RewardEntriesTableCreateCompanionBuilder,
      $$RewardEntriesTableUpdateCompanionBuilder,
      (RewardEntryRow, $$RewardEntriesTableReferences),
      RewardEntryRow,
      PrefetchHooks Function({bool rewardAccountId, bool transactionId})
    >;
typedef $$BankRulesTableCreateCompanionBuilder = BankRulesCompanion Function({
  required String id,
  required String bankId,
  required String ruleType,
  required String configurationVersion,
  required String configuration,
  Value<String> status,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BankRulesTableUpdateCompanionBuilder = BankRulesCompanion Function({
  Value<String> id,
  Value<String> bankId,
  Value<String> ruleType,
  Value<String> configurationVersion,
  Value<String> configuration,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$BankRulesTableReferences
    extends BaseReferences<_$AppDatabase, $BankRulesTable, BankRuleRow> {
  $$BankRulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BanksTable _bankIdTable(_$AppDatabase db) =>
      db.banks.createAlias('bank_rules__bank_id__banks__id');

  $$BanksTableProcessedTableManager get bankId {
    final $_column = $_itemColumn<String>('bank_id')!;

    final manager = $$BanksTableTableManager(
      $_db,
      $_db.banks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bankIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BankRulesTableFilterComposer
    extends Composer<_$AppDatabase, $BankRulesTable> {
  $$BankRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleType => $composableBuilder(
    column: $table.ruleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configurationVersion => $composableBuilder(
    column: $table.configurationVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configuration => $composableBuilder(
    column: $table.configuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BanksTableFilterComposer get bankId {
    final $$BanksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableFilterComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $BankRulesTable> {
  $$BankRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleType => $composableBuilder(
    column: $table.ruleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configurationVersion => $composableBuilder(
    column: $table.configurationVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configuration => $composableBuilder(
    column: $table.configuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BanksTableOrderingComposer get bankId {
    final $$BanksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableOrderingComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BankRulesTable> {
  $$BankRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ruleType =>
      $composableBuilder(column: $table.ruleType, builder: (column) => column);

  GeneratedColumn<String> get configurationVersion => $composableBuilder(
    column: $table.configurationVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get configuration => $composableBuilder(
    column: $table.configuration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BanksTableAnnotationComposer get bankId {
    final $$BanksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bankId,
      referencedTable: $db.banks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BanksTableAnnotationComposer(
            $db: $db,
            $table: $db.banks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BankRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BankRulesTable,
          BankRuleRow,
          $$BankRulesTableFilterComposer,
          $$BankRulesTableOrderingComposer,
          $$BankRulesTableAnnotationComposer,
          $$BankRulesTableCreateCompanionBuilder,
          $$BankRulesTableUpdateCompanionBuilder,
          (BankRuleRow, $$BankRulesTableReferences),
          BankRuleRow,
          PrefetchHooks Function({bool bankId})
        > {
  $$BankRulesTableTableManager(_$AppDatabase db, $BankRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BankRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BankRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BankRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bankId = const Value.absent(),
                Value<String> ruleType = const Value.absent(),
                Value<String> configurationVersion = const Value.absent(),
                Value<String> configuration = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BankRulesCompanion(
                id: id,
                bankId: bankId,
                ruleType: ruleType,
                configurationVersion: configurationVersion,
                configuration: configuration,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bankId,
                required String ruleType,
                required String configurationVersion,
                required String configuration,
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BankRulesCompanion.insert(
                id: id,
                bankId: bankId,
                ruleType: ruleType,
                configurationVersion: configurationVersion,
                configuration: configuration,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BankRulesTable, BankRuleRow>(table),
                  $$BankRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bankId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (bankId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bankId,
                        referencedTable: $$BankRulesTableReferences
                            ._bankIdTable(db),
                        referencedColumn: $$BankRulesTableReferences
                            ._bankIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BankRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BankRulesTable,
      BankRuleRow,
      $$BankRulesTableFilterComposer,
      $$BankRulesTableOrderingComposer,
      $$BankRulesTableAnnotationComposer,
      $$BankRulesTableCreateCompanionBuilder,
      $$BankRulesTableUpdateCompanionBuilder,
      (BankRuleRow, $$BankRulesTableReferences),
      BankRuleRow,
      PrefetchHooks Function({bool bankId})
    >;
typedef $$EmailAccountsTableCreateCompanionBuilder =
    EmailAccountsCompanion Function({
      required String id,
      required String provider,
      required String emailAddress,
      required String secureTokenReference,
      Value<String> status,
      Value<bool> syncEnabled,
      required DateTime connectedAt,
      Value<DateTime?> lastSuccessfulSync,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$EmailAccountsTableUpdateCompanionBuilder =
    EmailAccountsCompanion Function({
      Value<String> id,
      Value<String> provider,
      Value<String> emailAddress,
      Value<String> secureTokenReference,
      Value<String> status,
      Value<bool> syncEnabled,
      Value<DateTime> connectedAt,
      Value<DateTime?> lastSuccessfulSync,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$EmailAccountsTableReferences
    extends
        BaseReferences<_$AppDatabase, $EmailAccountsTable, EmailAccountRow> {
  $$EmailAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SyncCheckpointsTable, List<SyncCheckpointRow>>
  _syncCheckpointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.syncCheckpoints,
    aliasName: 'email_accounts__id__sync_checkpoints__email_account_id',
  );

  $$SyncCheckpointsTableProcessedTableManager get syncCheckpointsRefs {
    final manager = $$SyncCheckpointsTableTableManager(
      $_db,
      $_db.syncCheckpoints,
    ).filter((f) => f.emailAccountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _syncCheckpointsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmailAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $EmailAccountsTable> {
  $$EmailAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailAddress => $composableBuilder(
    column: $table.emailAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secureTokenReference => $composableBuilder(
    column: $table.secureTokenReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get syncEnabled => $composableBuilder(
    column: $table.syncEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessfulSync => $composableBuilder(
    column: $table.lastSuccessfulSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> syncCheckpointsRefs(
    Expression<bool> Function($$SyncCheckpointsTableFilterComposer f) f,
  ) {
    final $$SyncCheckpointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncCheckpoints,
      getReferencedColumn: (t) => t.emailAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncCheckpointsTableFilterComposer(
            $db: $db,
            $table: $db.syncCheckpoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmailAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailAccountsTable> {
  $$EmailAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailAddress => $composableBuilder(
    column: $table.emailAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secureTokenReference => $composableBuilder(
    column: $table.secureTokenReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get syncEnabled => $composableBuilder(
    column: $table.syncEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessfulSync => $composableBuilder(
    column: $table.lastSuccessfulSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmailAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailAccountsTable> {
  $$EmailAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get emailAddress => $composableBuilder(
    column: $table.emailAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secureTokenReference => $composableBuilder(
    column: $table.secureTokenReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get syncEnabled => $composableBuilder(
    column: $table.syncEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSuccessfulSync => $composableBuilder(
    column: $table.lastSuccessfulSync,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> syncCheckpointsRefs<T extends Object>(
    Expression<T> Function($$SyncCheckpointsTableAnnotationComposer a) f,
  ) {
    final $$SyncCheckpointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.syncCheckpoints,
      getReferencedColumn: (t) => t.emailAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SyncCheckpointsTableAnnotationComposer(
            $db: $db,
            $table: $db.syncCheckpoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmailAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailAccountsTable,
          EmailAccountRow,
          $$EmailAccountsTableFilterComposer,
          $$EmailAccountsTableOrderingComposer,
          $$EmailAccountsTableAnnotationComposer,
          $$EmailAccountsTableCreateCompanionBuilder,
          $$EmailAccountsTableUpdateCompanionBuilder,
          (EmailAccountRow, $$EmailAccountsTableReferences),
          EmailAccountRow,
          PrefetchHooks Function({bool syncCheckpointsRefs})
        > {
  $$EmailAccountsTableTableManager(_$AppDatabase db, $EmailAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmailAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmailAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmailAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> emailAddress = const Value.absent(),
                Value<String> secureTokenReference = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> syncEnabled = const Value.absent(),
                Value<DateTime> connectedAt = const Value.absent(),
                Value<DateTime?> lastSuccessfulSync = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmailAccountsCompanion(
                id: id,
                provider: provider,
                emailAddress: emailAddress,
                secureTokenReference: secureTokenReference,
                status: status,
                syncEnabled: syncEnabled,
                connectedAt: connectedAt,
                lastSuccessfulSync: lastSuccessfulSync,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String provider,
                required String emailAddress,
                required String secureTokenReference,
                Value<String> status = const Value.absent(),
                Value<bool> syncEnabled = const Value.absent(),
                required DateTime connectedAt,
                Value<DateTime?> lastSuccessfulSync = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EmailAccountsCompanion.insert(
                id: id,
                provider: provider,
                emailAddress: emailAddress,
                secureTokenReference: secureTokenReference,
                status: status,
                syncEnabled: syncEnabled,
                connectedAt: connectedAt,
                lastSuccessfulSync: lastSuccessfulSync,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmailAccountsTable, EmailAccountRow>(table),
                  $$EmailAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({syncCheckpointsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (syncCheckpointsRefs) db.syncCheckpoints,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (syncCheckpointsRefs)
                    await $_getPrefetchedDataByColumns<
                      EmailAccountRow,
                      $EmailAccountsTable,
                      SyncCheckpointRow,
                      $SyncCheckpointsTable
                    >(
                      currentTable: table,
                      referencedTable: $$EmailAccountsTableReferences
                          ._syncCheckpointsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EmailAccountsTableReferences(
                            db,
                            table,
                            p0,
                          ).syncCheckpointsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'email_account_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EmailAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailAccountsTable,
      EmailAccountRow,
      $$EmailAccountsTableFilterComposer,
      $$EmailAccountsTableOrderingComposer,
      $$EmailAccountsTableAnnotationComposer,
      $$EmailAccountsTableCreateCompanionBuilder,
      $$EmailAccountsTableUpdateCompanionBuilder,
      (EmailAccountRow, $$EmailAccountsTableReferences),
      EmailAccountRow,
      PrefetchHooks Function({bool syncCheckpointsRefs})
    >;
typedef $$SyncCheckpointsTableCreateCompanionBuilder =
    SyncCheckpointsCompanion Function({
      required String id,
      required String emailAccountId,
      Value<String?> providerCheckpoint,
      Value<DateTime?> lastSyncStarted,
      Value<DateTime?> lastSyncCompleted,
      required String status,
      Value<String?> errorCode,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncCheckpointsTableUpdateCompanionBuilder =
    SyncCheckpointsCompanion Function({
      Value<String> id,
      Value<String> emailAccountId,
      Value<String?> providerCheckpoint,
      Value<DateTime?> lastSyncStarted,
      Value<DateTime?> lastSyncCompleted,
      Value<String> status,
      Value<String?> errorCode,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SyncCheckpointsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SyncCheckpointsTable,
          SyncCheckpointRow
        > {
  $$SyncCheckpointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmailAccountsTable _emailAccountIdTable(_$AppDatabase db) => db
      .emailAccounts
      .createAlias('sync_checkpoints__email_account_id__email_accounts__id');

  $$EmailAccountsTableProcessedTableManager get emailAccountId {
    final $_column = $_itemColumn<String>('email_account_id')!;

    final manager = $$EmailAccountsTableTableManager(
      $_db,
      $_db.emailAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_emailAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SyncCheckpointsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncCheckpointsTable> {
  $$SyncCheckpointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerCheckpoint => $composableBuilder(
    column: $table.providerCheckpoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncStarted => $composableBuilder(
    column: $table.lastSyncStarted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncCompleted => $composableBuilder(
    column: $table.lastSyncCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmailAccountsTableFilterComposer get emailAccountId {
    final $$EmailAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailAccountId,
      referencedTable: $db.emailAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailAccountsTableFilterComposer(
            $db: $db,
            $table: $db.emailAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncCheckpointsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncCheckpointsTable> {
  $$SyncCheckpointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerCheckpoint => $composableBuilder(
    column: $table.providerCheckpoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncStarted => $composableBuilder(
    column: $table.lastSyncStarted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncCompleted => $composableBuilder(
    column: $table.lastSyncCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmailAccountsTableOrderingComposer get emailAccountId {
    final $$EmailAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailAccountId,
      referencedTable: $db.emailAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.emailAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncCheckpointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncCheckpointsTable> {
  $$SyncCheckpointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get providerCheckpoint => $composableBuilder(
    column: $table.providerCheckpoint,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncStarted => $composableBuilder(
    column: $table.lastSyncStarted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncCompleted => $composableBuilder(
    column: $table.lastSyncCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EmailAccountsTableAnnotationComposer get emailAccountId {
    final $$EmailAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emailAccountId,
      referencedTable: $db.emailAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmailAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.emailAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SyncCheckpointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncCheckpointsTable,
          SyncCheckpointRow,
          $$SyncCheckpointsTableFilterComposer,
          $$SyncCheckpointsTableOrderingComposer,
          $$SyncCheckpointsTableAnnotationComposer,
          $$SyncCheckpointsTableCreateCompanionBuilder,
          $$SyncCheckpointsTableUpdateCompanionBuilder,
          (SyncCheckpointRow, $$SyncCheckpointsTableReferences),
          SyncCheckpointRow,
          PrefetchHooks Function({bool emailAccountId})
        > {
  $$SyncCheckpointsTableTableManager(
    _$AppDatabase db,
    $SyncCheckpointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncCheckpointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncCheckpointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncCheckpointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> emailAccountId = const Value.absent(),
                Value<String?> providerCheckpoint = const Value.absent(),
                Value<DateTime?> lastSyncStarted = const Value.absent(),
                Value<DateTime?> lastSyncCompleted = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncCheckpointsCompanion(
                id: id,
                emailAccountId: emailAccountId,
                providerCheckpoint: providerCheckpoint,
                lastSyncStarted: lastSyncStarted,
                lastSyncCompleted: lastSyncCompleted,
                status: status,
                errorCode: errorCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String emailAccountId,
                Value<String?> providerCheckpoint = const Value.absent(),
                Value<DateTime?> lastSyncStarted = const Value.absent(),
                Value<DateTime?> lastSyncCompleted = const Value.absent(),
                required String status,
                Value<String?> errorCode = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncCheckpointsCompanion.insert(
                id: id,
                emailAccountId: emailAccountId,
                providerCheckpoint: providerCheckpoint,
                lastSyncStarted: lastSyncStarted,
                lastSyncCompleted: lastSyncCompleted,
                status: status,
                errorCode: errorCode,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncCheckpointsTable, SyncCheckpointRow>(table),
                  $$SyncCheckpointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({emailAccountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (emailAccountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.emailAccountId,
                        referencedTable: $$SyncCheckpointsTableReferences
                            ._emailAccountIdTable(db),
                        referencedColumn: $$SyncCheckpointsTableReferences
                            ._emailAccountIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SyncCheckpointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncCheckpointsTable,
      SyncCheckpointRow,
      $$SyncCheckpointsTableFilterComposer,
      $$SyncCheckpointsTableOrderingComposer,
      $$SyncCheckpointsTableAnnotationComposer,
      $$SyncCheckpointsTableCreateCompanionBuilder,
      $$SyncCheckpointsTableUpdateCompanionBuilder,
      (SyncCheckpointRow, $$SyncCheckpointsTableReferences),
      SyncCheckpointRow,
      PrefetchHooks Function({bool emailAccountId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BanksTableTableManager get banks =>
      $$BanksTableTableManager(_db, _db.banks);
  $$CreditCardsTableTableManager get creditCards =>
      $$CreditCardsTableTableManager(_db, _db.creditCards);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$ImportJobsTableTableManager get importJobs =>
      $$ImportJobsTableTableManager(_db, _db.importJobs);
  $$TransactionSourcesTableTableManager get transactionSources =>
      $$TransactionSourcesTableTableManager(_db, _db.transactionSources);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ReviewItemsTableTableManager get reviewItems =>
      $$ReviewItemsTableTableManager(_db, _db.reviewItems);
  $$StatementsTableTableManager get statements =>
      $$StatementsTableTableManager(_db, _db.statements);
  $$StatementTransactionsTableTableManager get statementTransactions =>
      $$StatementTransactionsTableTableManager(_db, _db.statementTransactions);
  $$CashbackEntriesTableTableManager get cashbackEntries =>
      $$CashbackEntriesTableTableManager(_db, _db.cashbackEntries);
  $$CashbackRulesTableTableManager get cashbackRules =>
      $$CashbackRulesTableTableManager(_db, _db.cashbackRules);
  $$RewardAccountsTableTableManager get rewardAccounts =>
      $$RewardAccountsTableTableManager(_db, _db.rewardAccounts);
  $$RewardEntriesTableTableManager get rewardEntries =>
      $$RewardEntriesTableTableManager(_db, _db.rewardEntries);
  $$BankRulesTableTableManager get bankRules =>
      $$BankRulesTableTableManager(_db, _db.bankRules);
  $$EmailAccountsTableTableManager get emailAccounts =>
      $$EmailAccountsTableTableManager(_db, _db.emailAccounts);
  $$SyncCheckpointsTableTableManager get syncCheckpoints =>
      $$SyncCheckpointsTableTableManager(_db, _db.syncCheckpoints);
}
