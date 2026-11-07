import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../domain/entities/bank.dart';
import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/services/card_form_validation.dart';
import '../../../../domain/services/money_amount.dart';

class CardEditorSheet extends ConsumerStatefulWidget {
  const CardEditorSheet({super.key, this.card});

  final CreditCard? card;

  @override
  ConsumerState<CardEditorSheet> createState() => _CardEditorSheetState();
}

class _CardEditorSheetState extends ConsumerState<CardEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _issuerController;
  late final TextEditingController _countryController;
  late final TextEditingController _nameController;
  late final TextEditingController _cardholderController;
  late final TextEditingController _lastFourController;
  late final TextEditingController _limitController;
  late final TextEditingController _outstandingController;
  late final TextEditingController _currencyController;
  late final TextEditingController _statementDayController;
  late final TextEditingController _dueDayController;
  late final TextEditingController _rewardsController;
  late CardNetwork _network;
  bool _saving = false;
  bool _saveFailed = false;
  bool _issuerLoadFailed = false;

  @override
  void initState() {
    super.initState();
    final card = widget.card;
    _issuerController = TextEditingController();
    _countryController = TextEditingController(text: 'US');
    _nameController = TextEditingController(text: card?.displayName ?? '');
    _cardholderController = TextEditingController(
      text: card?.cardholderName ?? '',
    );
    _lastFourController = TextEditingController(text: card?.lastFour ?? '');
    _limitController = TextEditingController(
      text: card == null
          ? ''
          : _formatInitialAmount(card.creditLimitMinor, card.currencyCode),
    );
    _outstandingController = TextEditingController(
      text: card == null || card.currentOutstandingMinor == 0
          ? ''
          : _formatInitialAmount(
              card.currentOutstandingMinor,
              card.currencyCode,
            ),
    );
    _currencyController = TextEditingController(
      text: card?.currencyCode ?? 'USD',
    );
    _statementDayController = TextEditingController(
      text: card?.statementDay?.toString() ?? '',
    );
    _dueDayController = TextEditingController(
      text: card?.dueDay?.toString() ?? '',
    );
    _rewardsController = TextEditingController(
      text: card?.rewardProgramme ?? '',
    );
    _network = card?.network ?? CardNetwork.visa;
    _loadIssuer(card);
  }

  @override
  void dispose() {
    _issuerController.dispose();
    _countryController.dispose();
    _nameController.dispose();
    _cardholderController.dispose();
    _lastFourController.dispose();
    _limitController.dispose();
    _outstandingController.dispose();
    _currencyController.dispose();
    _statementDayController.dispose();
    _dueDayController.dispose();
    _rewardsController.dispose();
    super.dispose();
  }

  Future<void> _loadIssuer(CreditCard? card) async {
    if (card == null) return;
    try {
      final repository = await ref.read(bankRepositoryProvider.future);
      final bank = await repository.getById(card.bankId);
      if (!mounted) return;
      if (bank == null) {
        setState(() => _issuerLoadFailed = true);
        return;
      }
      _issuerController.text = bank.displayName;
      _countryController.text = bank.countryCode;
    } catch (_) {
      if (mounted) setState(() => _issuerLoadFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.card != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        top: 16,
        right: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isEditing ? 'Edit card' : 'Add card',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_issuerLoadFailed) ...[
                const Text(
                  'Issuer details could not be loaded. Enter them again.',
                ),
                const SizedBox(height: 8),
              ],
              TextFormField(
                key: const Key('card-issuer'),
                controller: _issuerController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Issuer'),
                validator: CardFormValidation.requiredText,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('card-country'),
                      controller: _countryController,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 2,
                      decoration: const InputDecoration(
                        labelText: 'Country code',
                        counterText: '',
                      ),
                      validator: CardFormValidation.countryCode,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      key: const Key('card-name'),
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Card name'),
                      validator: CardFormValidation.requiredText,
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<CardNetwork>(
                key: const Key('card-network'),
                initialValue: _network,
                decoration: const InputDecoration(labelText: 'Network'),
                items: [
                  for (final network in CardNetwork.values)
                    DropdownMenuItem(
                      value: network,
                      child: Text(_networkLabel(network)),
                    ),
                ],
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value != null) setState(() => _network = value);
                      },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('card-last-four'),
                      controller: _lastFourController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      decoration: const InputDecoration(
                        labelText: 'Last four digits',
                        counterText: '',
                      ),
                      validator: CardFormValidation.lastFour,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: const Key('card-currency'),
                      controller: _currencyController,
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 3,
                      decoration: const InputDecoration(
                        labelText: 'Currency',
                        counterText: '',
                      ),
                      validator: CardFormValidation.currency,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              TextFormField(
                key: const Key('card-limit'),
                controller: _limitController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Credit limit',
                  hintText: 'Enter an amount without separators',
                ),
                validator: (value) => CardFormValidation.creditLimit(
                  value,
                  _currencyController.text,
                ),
              ),
              TextFormField(
                key: const Key('card-outstanding'),
                controller: _outstandingController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Current outstanding (optional)',
                  helperText: 'Your reconciled balance, not a sum of purchases',
                  hintText: 'Leave blank for zero',
                ),
                validator: (value) => CardFormValidation.outstanding(
                  value,
                  _currencyController.text,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('card-statement-day'),
                      controller: _statementDayController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Statement day (optional)',
                      ),
                      validator: CardFormValidation.dayOfMonth,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      key: const Key('card-due-day'),
                      controller: _dueDayController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Due day (optional)',
                      ),
                      validator: CardFormValidation.dayOfMonth,
                    ),
                  ),
                ],
              ),
              TextFormField(
                key: const Key('cardholder-name'),
                controller: _cardholderController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Cardholder name (optional)',
                ),
              ),
              TextFormField(
                key: const Key('card-rewards'),
                controller: _rewardsController,
                decoration: const InputDecoration(
                  labelText: 'Reward programme (optional)',
                ),
              ),
              if (_saveFailed) ...[
                const SizedBox(height: 12),
                const Text('The card could not be saved. Please try again.'),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                key: const Key('save-card'),
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(isEditing ? 'Save changes' : 'Save card'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _saveFailed = false;
    });

    try {
      final bankRepository = await ref.read(bankRepositoryProvider.future);
      final cardRepository = await ref.read(
        creditCardRepositoryProvider.future,
      );
      final issuer = _issuerController.text.trim();
      final countryCode = _countryController.text.trim().toUpperCase();
      final banks = await bankRepository.getAll();
      final matchingBanks = banks.where(
        (bank) =>
            bank.countryCode == countryCode &&
            bank.displayName.toLowerCase() == issuer.toLowerCase(),
      );
      final now = DateTime.now().toUtc();
      final bank = matchingBanks.isNotEmpty
          ? matchingBanks.first
          : Bank(
              id: _newId('bank'),
              displayName: issuer,
              countryCode: countryCode,
              region: countryCode,
              createdAt: now,
              updatedAt: now,
            );
      if (matchingBanks.isEmpty) await bankRepository.upsert(bank);

      final existing = widget.card;
      final card = CreditCard(
        id: existing?.id ?? _newId('card'),
        bankId: bank.id,
        displayName: _nameController.text.trim(),
        cardholderName: _optionalText(_cardholderController.text),
        network: _network,
        lastFour: _lastFourController.text.trim(),
        creditLimitMinor: MoneyAmount.parseMinorUnits(
          _limitController.text,
          _currencyController.text.trim().toUpperCase(),
        )!,
        currentOutstandingMinor: _parseOutstanding(
          _outstandingController.text,
          _currencyController.text,
        ),
        currencyCode: _currencyController.text.trim().toUpperCase(),
        statementDay: _optionalDay(_statementDayController.text),
        dueDay: _optionalDay(_dueDayController.text),
        status: existing?.status ?? CardStatus.active,
        rewardProgramme: _optionalText(_rewardsController.text),
        colorValue: existing?.colorValue,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      );
      await cardRepository.upsert(card);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _saveFailed = true;
        });
      }
    }
  }

  int _parseOutstanding(String value, String currencyCode) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 0;
    return MoneyAmount.parseNonNegativeMinorUnits(
      trimmed,
      currencyCode.trim().toUpperCase(),
    )!;
  }

  int? _optionalDay(String value) {
    return value.trim().isEmpty ? null : int.parse(value.trim());
  }

  String? _optionalText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _formatInitialAmount(int amountMinor, String currencyCode) {
    final formatted = MoneyAmount.formatMinorUnits(amountMinor, currencyCode);
    return formatted.substring(currencyCode.length + 1).replaceAll(',', '');
  }

  String _networkLabel(CardNetwork network) {
    return switch (network) {
      CardNetwork.visa => 'Visa',
      CardNetwork.mastercard => 'Mastercard',
      CardNetwork.americanExpress => 'American Express',
      CardNetwork.rupay => 'RuPay',
      CardNetwork.discover => 'Discover',
      CardNetwork.other => 'Other',
    };
  }

  String _newId(String prefix) {
    final randomPart = Random.secure().nextInt(0x7fffffff).toRadixString(16);
    return '${prefix}_${DateTime.now().microsecondsSinceEpoch}_$randomPart';
  }
}
