import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/providers.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/transaction_category.dart';
import '../../../../domain/services/ids.dart';
import '../../../../domain/services/merchant_normalizer.dart';
import '../../../../domain/services/money_amount.dart';
import '../../../../domain/services/transaction_fingerprint.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../providers/transaction_providers.dart';

class TransactionEditorSheet extends ConsumerStatefulWidget {
  const TransactionEditorSheet({super.key, this.initialCard, this.transaction});

  final CreditCard? initialCard;
  final CardTransaction? transaction;

  bool get isEditing => transaction != null;

  @override
  ConsumerState<TransactionEditorSheet> createState() =>
      _TransactionEditorSheetState();
}

class _TransactionEditorSheetState
    extends ConsumerState<TransactionEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _merchant;
  late final TextEditingController _amount;
  late final TextEditingController _notes;
  DateTime _date = DateTime.now();
  TransactionType _type = TransactionType.purchase;
  String? _cardId;
  String? _categoryId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _merchant = TextEditingController(text: tx?.displayMerchant ?? '');
    _cardId = tx?.cardId ?? widget.initialCard?.id;
    _categoryId = tx?.categoryId;
    _date = tx?.transactionDate ?? DateTime.now();
    _type = tx?.transactionType ?? TransactionType.purchase;
    _amount = TextEditingController(
      text: tx == null
          ? ''
          : MoneyAmount.formatMinorUnits(
              tx.amountMinor.abs(),
              tx.currencyCode,
            ).substring(tx.currencyCode.length + 1).replaceAll(',', ''),
    );
    _notes = TextEditingController(text: tx?.notes ?? '');
  }

  @override
  void dispose() {
    _merchant.dispose();
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(creditCardsProvider);
    final categories = ref.watch(transactionCategoriesProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 18,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: cards.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Text('Cards could not be loaded.'),
        data: (cardItems) => categories.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Text('Categories could not be loaded.'),
          data: (categoryItems) => _form(context, cardItems, categoryItems),
        ),
      ),
    );
  }

  Widget _form(
    BuildContext context,
    List<CreditCard> cards,
    List<TransactionCategory> categories,
  ) {
    final selectedCard = cards.where((card) => card.id == _cardId).firstOrNull;
    final currency = selectedCard?.currencyCode ?? 'INR';

    if (_cardId == null && widget.initialCard == null && cards.isNotEmpty) {
      _cardId = cards.first.id;
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.isEditing ? 'Edit transaction' : 'Add transaction',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _cardId,
              decoration: const InputDecoration(labelText: 'Card'),
              items: [
                for (final card in cards.where((card) => card.isActive))
                  DropdownMenuItem(
                    value: card.id,
                    child: Text(
                      '${card.displayName} •••• ${card.lastFour}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: widget.isEditing
                  ? null
                  : (value) => setState(() => _cardId = value),
              validator: (value) => value == null ? 'Choose a card.' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _merchant,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Merchant'),
              validator: (value) => (value == null || value.trim().length < 2)
                  ? 'Enter a merchant name.'
                  : null,
            ),
            const SizedBox(height: 12),
            if (!widget.isEditing) ...[
              TextFormField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '$currency ',
                ),
                validator: (value) {
                  final parsed = MoneyAmount.parseNonNegativeMinorUnits(
                    value ?? '',
                    currency,
                  );
                  if (parsed == null || parsed == 0) {
                    return 'Enter a valid amount.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<TransactionType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: [
                  for (final type in TransactionType.values)
                    DropdownMenuItem(value: type, child: Text(type.label)),
                ],
                onChanged: (value) =>
                    setState(() => _type = value ?? TransactionType.purchase),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text('Date: ${formatShortDate(_date)}'),
              ),
              const SizedBox(height: 12),
            ] else
              Text(
                'Amount, date, and direction are fixed after import. You can '
                'correct the merchant, card, and category here.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            DropdownButtonFormField<String>(
              initialValue: _categoryId ?? '',
              decoration: const InputDecoration(labelText: 'Category'),
              items: [
                const DropdownMenuItem(value: '', child: Text('Uncategorised')),
                for (final category in categories)
                  DropdownMenuItem(
                    value: category.id,
                    child: Text(category.name),
                  ),
              ],
              onChanged: (value) => setState(
                () =>
                    _categoryId = value == null || value.isEmpty ? null : value,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notes,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : () => _save(cards),
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving…' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save(List<CreditCard> cards) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final repository = await ref.read(transactionRepositoryProvider.future);
      final merchant = _merchant.text.trim();
      final normalized = MerchantNormalizer.normalize(merchant);
      final editing = widget.transaction;
      if (editing != null) {
        await repository.updateMerchant(
          id: editing.id,
          merchantOriginal: merchant,
          merchantNormalized: normalized,
        );
        await repository.updateCategory(editing.id, _categoryId);
        if (_cardId != null && _cardId != editing.cardId) {
          final card = cards.firstWhere((card) => card.id == _cardId);
          await repository.assignCard(
            id: editing.id,
            cardId: card.id,
            bankId: card.bankId,
          );
        }
        final reviews = await ref.read(reviewRepositoryProvider.future);
        await reviews.resolveForEntity(
          entityType: 'transaction',
          entityId: editing.id,
        );
      } else {
        final card = cards.firstWhere((candidate) => candidate.id == _cardId);
        final amount = MoneyAmount.parseNonNegativeMinorUnits(
          _amount.text,
          card.currencyCode,
        );
        if (amount == null || amount == 0) {
          throw const AppFailure(
            code: 'CCM-TX-001',
            message: 'Enter a valid amount.',
          );
        }
        final now = DateTime.now().toUtc();
        final signed = _type.isDebit ? amount : -amount;
        final fingerprint = TransactionFingerprint.compute(
          cardId: card.id,
          amountMinor: signed,
          currencyCode: card.currencyCode,
          transactionDate: _date,
          merchant: normalized,
          type: _type,
        );
        if (fingerprint != null) {
          final duplicate = await repository.findByFingerprint(fingerprint);
          if (duplicate != null) {
            throw const AppFailure(
              code: 'CCM-TX-002',
              message:
                  'A matching transaction already exists. It was not added '
                  'again.',
            );
          }
        }
        final id = Ids.next('tx');
        final transaction = CardTransaction(
          id: id,
          cardId: card.id,
          bankId: card.bankId,
          merchantOriginal: merchant,
          merchantNormalized: normalized,
          amountMinor: signed,
          currencyCode: card.currencyCode,
          transactionDate: DateTime(_date.year, _date.month, _date.day),
          transactionType: _type,
          categoryId: _categoryId,
          status: TransactionStatus.posted,
          sourceConfidence: SourceConfidence.high,
          notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          fingerprint: fingerprint,
          fingerprintVersion: fingerprint == null
              ? null
              : TransactionFingerprint.currentVersion,
          createdAt: now,
          updatedAt: now,
        );
        await repository.insertWithSource(
          transaction: transaction,
          source: TransactionSource(
            id: Ids.next('source'),
            transactionId: id,
            sourceType: TransactionSourceType.manual,
            sourceReference: 'manual:$id',
            sourceDate: transaction.transactionDate,
            originalDescription: merchant,
            parserId: 'manual',
            parserVersion: '1',
            matchStatus: SourceMatchStatus.created,
            createdAt: now,
          ),
        );
      }
      if (mounted) Navigator.pop(context, true);
    } on AppFailure catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('The transaction could not be saved.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
