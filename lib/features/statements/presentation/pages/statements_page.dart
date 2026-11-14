import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/providers.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../domain/entities/bank.dart';
import '../../../../domain/entities/credit_card.dart';
import '../../../../domain/entities/statement.dart';
import '../../../../domain/services/money_amount.dart';
import '../../../../integrations/pdf/password_strategy.dart';
import '../../../../integrations/pdf/statement_import_service.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../providers/statement_providers.dart';

class StatementsPage extends ConsumerStatefulWidget {
  const StatementsPage({super.key});

  @override
  ConsumerState<StatementsPage> createState() => _StatementsPageState();
}

class _StatementsPageState extends ConsumerState<StatementsPage> {
  bool _importing = false;

  @override
  Widget build(BuildContext context) {
    final statements = ref.watch(statementsProvider);
    final cards = ref.watch(creditCardsProvider);
    final banks = ref.watch(knownBanksProvider);
    final cardMap = <String, CreditCard>{
      for (final card in cards.asData?.value ?? const <CreditCard>[])
        card.id: card,
    };
    final bankMap = <String, Bank>{
      for (final bank in banks.asData?.value ?? const <Bank>[]) bank.id: bank,
    };

    return Scaffold(
      key: const Key('statements-page'),
      appBar: AppBar(
        title: const Text('Statements'),
        actions: [
          IconButton(
            key: const Key('import-statement'),
            tooltip: 'Import PDF statement',
            onPressed: _importing ? null : _importPdf,
            icon: _importing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_file_outlined),
          ),
        ],
      ),
      body: statements.when(
        loading: () => const AppLoadingState(message: 'Loading statements…'),
        error: (_, _) => AppErrorState(
          message: 'Statements could not be loaded.',
          onRetry: () => ref.invalidate(statementsProvider),
        ),
        data: (items) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(statementsProvider),
          child: items.isEmpty
              ? ListView(
                  children: [
                    SizedBox(
                      height: 480,
                      child: AppEmptyState(
                        icon: Icons.description_outlined,
                        title: 'No statements yet',
                        subtitle:
                            'Import an encrypted PDF locally, or connect Gmail '
                            'in Account to fetch credit-card statements.',
                        actionLabel: 'Import PDF',
                        onAction: _importPdf,
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final statement = items[index];
                    return _StatementCard(
                      statement: statement,
                      card: statement.cardId == null
                          ? null
                          : cardMap[statement.cardId],
                      bank: statement.bankId == null
                          ? null
                          : bankMap[statement.bankId],
                      onTap: () => _openStatement(statement),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> _importPdf() async {
    if (_importing) return;
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        dialogTitle: 'Choose a card statement PDF',
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        _showError('The selected PDF is empty.');
        return;
      }
      if (!mounted) return;
      final password = await _askPassword();
      if (password == null || !mounted) return;
      setState(() => _importing = true);
      final service = await ref.read(statementImportServiceProvider.future);
      final result = await service.importBytes(
        bytes: bytes,
        fileName: file.name,
        passwordInputs: StatementPasswordInputs(
          userPassword: password.trim().isEmpty ? null : password,
        ),
      );
      if (!mounted) return;
      _showResult(result);
      _refresh();
    } on AppFailure catch (error) {
      _showError(error.message);
    } catch (_) {
      _showError('The statement could not be imported.');
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<String?> _askPassword() async {
    final controller = TextEditingController();
    var obscure = true;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Statement password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'If the PDF is password-protected, enter the password now. '
                'It is used only for this local extraction and is not stored.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                obscureText: obscure,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Password (optional)',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => obscure = !obscure),
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Import'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    return result;
  }

  void _showResult(StatementImportResult result) {
    final parts = <String>[
      if (result.duplicate) 'Already imported',
      if (result.imported > 0) '${result.imported} transactions imported',
      if (result.skipped > 0) '${result.skipped} matched existing',
      if (result.requiresReview > 0) '${result.requiresReview} need review',
    ];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          parts.isEmpty ? 'Statement processed.' : parts.join(' · '),
        ),
      ),
    );
  }

  Future<void> _openStatement(Statement statement) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _StatementDetailSheet(statement: statement),
    );
  }

  void _refresh() {
    ref.invalidate(statementsProvider);
    ref.invalidate(reviewItemsProvider);
    ref.invalidate(reviewCountProvider);
    ref.invalidate(transactionsProvider);
    ref.invalidate(transactionCountProvider);
    ref.invalidate(recentTransactionsProvider);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _StatementCard extends StatelessWidget {
  const _StatementCard({
    required this.statement,
    required this.card,
    required this.bank,
    required this.onTap,
  });

  final Statement statement;
  final CreditCard? card;
  final Bank? bank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  card == null
                      ? 'Unmatched statement'
                      : '${card!.displayName} •••• ${card!.lastFour}',
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusPill(status: statement.processingStatus),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${formatShortDate(statement.statementPeriodStart)} – '
            '${formatShortDate(statement.statementPeriodEnd)}',
            style: theme.textTheme.bodySmall,
          ),
          if (bank != null)
            Text(bank!.displayName, style: theme.textTheme.labelSmall),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Total due',
                  amountMinor: statement.totalDueMinor,
                  currencyCode: statement.currencyCode,
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Minimum due',
                  amountMinor: statement.minimumDueMinor,
                  currencyCode: statement.currencyCode,
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Due date',
                  text: formatShortDate(statement.paymentDueDate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final StatementProcessingStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      StatementProcessingStatus.reconciled => (
        'Reconciled',
        Theme.of(context).colorScheme.tertiaryContainer,
      ),
      StatementProcessingStatus.needsReview => (
        'Needs review',
        Theme.of(context).colorScheme.errorContainer,
      ),
      StatementProcessingStatus.processing ||
      StatementProcessingStatus.downloaded => (
        'Processing',
        Theme.of(context).colorScheme.secondaryContainer,
      ),
      StatementProcessingStatus.failed => (
        'Failed',
        Theme.of(context).colorScheme.errorContainer,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    this.amountMinor,
    this.currencyCode,
    this.text,
  });

  final String label;
  final int? amountMinor;
  final String? currencyCode;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        if (amountMinor != null && currencyCode != null)
          CurrencyText(
            amountMinor: amountMinor!,
            currencyCode: currencyCode!,
            style: theme.textTheme.labelMedium,
          )
        else
          Text(text ?? '—', style: theme.textTheme.labelMedium),
      ],
    );
  }
}

class _StatementDetailSheet extends ConsumerWidget {
  const _StatementDetailSheet({required this.statement});

  final Statement statement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(statementTransactionsProvider(statement.id));
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Statement details',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          AppCard(
            child: Column(
              children: [
                _row(
                  context,
                  'Period',
                  '${formatShortDate(statement.statementPeriodStart)} – ${formatShortDate(statement.statementPeriodEnd)}',
                ),
                _row(
                  context,
                  'Statement date',
                  formatShortDate(statement.statementDate),
                ),
                _row(
                  context,
                  'Due date',
                  formatShortDate(statement.paymentDueDate),
                ),
                _row(
                  context,
                  'Total due',
                  _amount(statement.totalDueMinor, statement.currencyCode),
                ),
                _row(
                  context,
                  'Minimum due',
                  _amount(statement.minimumDueMinor, statement.currencyCode),
                ),
                _row(
                  context,
                  'Previous balance',
                  _amount(
                    statement.previousBalanceMinor,
                    statement.currencyCode,
                  ),
                ),
                _row(context, 'Status', statement.processingStatus.name),
                if (statement.parserId != null)
                  _row(
                    context,
                    'Parser',
                    '${statement.parserId} v${statement.parserVersion ?? '?'}',
                  ),
              ],
            ),
          ),
          if (statement.processingStatus ==
              StatementProcessingStatus.needsReview)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'This statement has unresolved review items. Open the review '
                'queue from Transactions to correct them.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text('Statement transactions', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          transactions.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) =>
                const Text('Statement transactions could not be loaded.'),
            data: (items) => items.isEmpty
                ? const Text('No transactions were extracted.')
                : Column(
                    children: [
                      for (final tx in items)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            tx.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${formatShortDate(tx.transactionDate)} · '
                            '${tx.matchStatus.name}',
                          ),
                          trailing: CurrencyText(
                            amountMinor: tx.amountMinor,
                            currencyCode: tx.currencyCode,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _amount(int amount, String currency) =>
      MoneyAmount.formatMinorUnits(amount, currency);

  Widget _row(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
