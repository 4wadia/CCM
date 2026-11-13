import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/router.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../domain/entities/email_account.dart';
import '../../../../domain/entities/import_job.dart';
import '../../../../domain/services/csv_exporter.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading_state.dart';
import '../../../cards/presentation/providers/card_providers.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../rewards/presentation/providers/reward_providers.dart';
import '../../../statements/presentation/providers/statement_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../providers/settings_providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String? _busy;

  bool get _isBusy => _busy != null;

  @override
  Widget build(BuildContext context) {
    final gmail = ref.watch(gmailStatusProvider);
    final configured = ref.watch(gmailConfiguredProvider);
    final checkpoint = ref.watch(syncCheckpointProvider);
    final smsSupported = ref.watch(smsSupportedProvider);
    final smsPermission = ref.watch(smsPermissionProvider);
    final jobs = ref.watch(importJobsProvider);

    return Scaffold(
      key: const Key('settings-page'),
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          const _SectionLabel('Privacy and storage'),
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lock_outline),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Local-first by design',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Card data, transactions, statements, and reward balances '
                  'stay in an encrypted local database. There is no analytics '
                  'SDK, cloud database, or remote financial processing.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('Gmail statements'),
          _gmailSection(context, configured, gmail, checkpoint),
          const SizedBox(height: 18),
          const _SectionLabel('SMS transaction alerts'),
          _smsSection(context, smsSupported, smsPermission),
          const SizedBox(height: 18),
          const _SectionLabel('Statements and exports'),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Import PDF statement'),
                  subtitle: const Text(
                    'Choose a PDF from local storage. Passwords are used only '
                    'in memory and are never stored.',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _isBusy
                      ? null
                      : () => context.push(AppRoutes.statements),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.ios_share_outlined),
                  title: const Text('Export transactions as CSV'),
                  subtitle: const Text(
                    'Export the most recent 1,000 transactions with only the '
                    'last four card digits.',
                  ),
                  trailing: _busy == 'csv'
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: _isBusy ? null : _exportCsv,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('Encrypted backup'),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.backup_outlined),
                  title: const Text('Create encrypted backup'),
                  subtitle: const Text(
                    'Creates a portable .ccmbackup envelope with Argon2id and '
                    'authenticated AES-256-GCM encryption. OAuth tokens and '
                    'device keys are excluded.',
                  ),
                  trailing: _busy == 'backup'
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: _isBusy ? null : _createBackup,
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.restore_outlined),
                  title: const Text('Restore from backup'),
                  subtitle: const Text(
                    'Restoring replaces local card, transaction, statement, and '
                    'reward data. Gmail credentials must be reconnected.',
                  ),
                  trailing: _busy == 'restore'
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: _isBusy ? null : _restoreBackup,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('Import history'),
          jobs.when(
            loading: () =>
                const AppLoadingState(message: 'Loading import history…'),
            error: (_, _) => AppErrorState(
              message: 'Import history could not be loaded.',
              onRetry: () => ref.invalidate(importJobsProvider),
            ),
            data: (items) => items.isEmpty
                ? const AppCard(
                    child: Text('No imports have run on this device yet.'),
                  )
                : Column(
                    children: [
                      for (final job in items) _ImportJobTile(job: job),
                    ],
                  ),
          ),
          const SizedBox(height: 18),
          const _SectionLabel('Danger zone'),
          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              title: const Text('Delete all local data'),
              subtitle: const Text(
                'Destroys the encrypted database, statement files, local keys, '
                'and Gmail tokens. This cannot be undone and there is no '
                'remote copy.',
              ),
              trailing: _busy == 'wipe'
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: _isBusy ? null : _wipeAll,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Credit Card Manager · local-only build',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gmailSection(
    BuildContext context,
    bool configured,
    AsyncValue<EmailAccount?> gmail,
    AsyncValue<SyncCheckpoint?> checkpoint,
  ) {
    if (!configured) {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gmail is disabled in this build.'),
            const SizedBox(height: 6),
            const Text(
              'On Android, Gmail uses Google Play services and needs an Android '
              'OAuth client for this package and signing certificate. On iOS, '
              'provide GMAIL_CLIENT_ID and GMAIL_REDIRECT_URI at build time. '
              'No client secret or token is stored in the database.',
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _showGmailSetupHelp,
              icon: const Icon(Icons.help_outline),
              label: const Text('Setup help'),
            ),
          ],
        ),
      );
    }
    return gmail.when(
      loading: () => const AppLoadingState(message: 'Checking Gmail…'),
      error: (_, _) =>
          const AppCard(child: Text('Gmail status could not be loaded.')),
      data: (account) => account == null
          ? AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Connected statements are never uploaded. Gmail access is '
                    'read-only and is limited to statement messages.',
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: _isBusy ? null : _connectGmail,
                        icon: _busy == 'gmail-connect'
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.link),
                        label: const Text('Connect Gmail'),
                      ),
                      TextButton.icon(
                        onPressed: _showGmailSetupHelp,
                        icon: const Icon(Icons.help_outline),
                        label: const Text('Setup help'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.alternate_email),
                    title: Text(account.emailAddress),
                    subtitle: Text(
                      [
                        account.status,
                        if (account.lastSuccessfulSync != null)
                          'Last sync ${formatDateTime(account.lastSuccessfulSync)}',
                      ].join(' · '),
                    ),
                  ),
                  checkpoint.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (value) => value == null
                        ? const SizedBox.shrink()
                        : Text(
                            'Checkpoint: ${value.status}'
                            '${value.errorCode == null ? '' : ' · ${value.errorCode}'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: _isBusy ? null : _syncGmail,
                        icon: _busy == 'gmail-sync'
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sync),
                        label: const Text('Sync now'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isBusy ? null : _disconnectGmail,
                        icon: const Icon(Icons.link_off),
                        label: const Text('Disconnect'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _smsSection(
    BuildContext context,
    bool supported,
    AsyncValue<bool> permission,
  ) {
    if (!supported) {
      return const AppCard(
        child: Text(
          'SMS import is unavailable on this platform. Android is the only '
          'platform with permission-gated SMS inbox access; iOS does not '
          'provide access to the SMS inbox.',
        ),
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.sms_outlined),
            title: const Text('Android SMS import'),
            subtitle: permission.when(
              loading: () => const Text('Checking permission…'),
              error: (_, _) => const Text('Permission status unavailable.'),
              data: (granted) => Text(
                granted
                    ? 'Permission granted. Only credit-card transaction alerts '
                          'are parsed; debit-card, bank-account, UPI, ATM, and '
                          'wallet messages are skipped. Raw inbox contents are '
                          'not uploaded.'
                    : 'Permission is required before any message can be read.',
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _isBusy ? null : _requestSmsPermission,
                icon: const Icon(Icons.verified_user_outlined),
                label: const Text('Grant permission'),
              ),
              FilledButton.icon(
                onPressed: _isBusy ? null : _importSms,
                icon: _busy == 'sms'
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download_outlined),
                label: const Text('Import recent SMS'),
              ),
              OutlinedButton.icon(
                onPressed: _isBusy ? null : _clearSms,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                icon: _busy == 'sms-clear'
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_sweep_outlined),
                label: const Text('Clear imported SMS'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showGmailSetupHelp() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set up Gmail access'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Android uses Google Play services for authorization. The app '
                'does not embed a client secret or refresh token.',
              ),
              SizedBox(height: 12),
              Text('1. Create or select a Google Cloud project.'),
              Text('2. Enable the Gmail API for that project.'),
              Text(
                '3. Configure the OAuth consent screen and add your Google '
                'account as a test user.',
              ),
              Text('4. Create an OAuth client ID of type Android with:'),
              SizedBox(height: 6),
              SelectableText('Package: app.creditcardmanager'),
              SelectableText(
                'SHA-1: 7E:34:4B:52:D0:99:39:52:85:71:B4:71:A8:D1:AE:35:'
                'C6:3B:EC:16',
              ),
              SizedBox(height: 12),
              Text(
                'Then tap Connect Gmail. Access is read-only and limited to '
                'Gmail messages that may contain statement PDFs. Tokens stay in '
                'Android secure storage; the database stores only an opaque '
                'reference.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _connectGmail() async {
    await _run('gmail-connect', () async {
      final service = await ref.read(gmailSyncServiceProvider.future);
      final account = await service.connect();
      ref.invalidate(gmailStatusProvider);
      ref.invalidate(syncCheckpointProvider);
      ref.invalidate(importJobsProvider);
      _showMessage('Connected ${account.emailAddress}.');
    });
  }

  Future<void> _syncGmail() async {
    await _run('gmail-sync', () async {
      final service = await ref.read(gmailSyncServiceProvider.future);
      final result = await service.sync();
      _invalidateAfterImport();
      _showMessage(
        'Examined ${result.messagesExamined} messages · '
        '${result.statementsProcessed} statements · '
        '${result.requiresReview} need review'
        '${result.errors == 0 ? '' : ' · ${result.errors} errors'}.',
      );
    });
  }

  Future<void> _disconnectGmail() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Gmail?'),
        content: const Text(
          'Local Gmail tokens are deleted. Imported statements and '
          'transactions are kept. Remote access may also need to be revoked '
          'from your Google account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run('gmail-disconnect', () async {
      final service = await ref.read(gmailSyncServiceProvider.future);
      await service.disconnect();
      ref.invalidate(gmailStatusProvider);
      ref.invalidate(syncCheckpointProvider);
      _showMessage('Gmail disconnected.');
    });
  }

  Future<void> _requestSmsPermission() async {
    await _run('sms-permission', () async {
      final platform = ref.read(smsPlatformProvider);
      final granted = await platform.requestPermission();
      ref.invalidate(smsPermissionProvider);
      _showMessage(
        granted
            ? 'SMS permission granted.'
            : 'SMS permission was not granted. No messages were read.',
      );
    });
  }

  Future<void> _importSms() async {
    await _run('sms', () async {
      final service = await ref.read(smsImportServiceProvider.future);
      if (!await service.hasPermission()) {
        final granted = await service.requestPermission();
        if (!granted) {
          _showMessage('SMS permission is required. No messages were read.');
          return;
        }
      }
      final result = await service.importRecent();
      _invalidateAfterImport();
      ref.invalidate(smsPermissionProvider);
      _showMessage(
        'Read ${result.messagesRead} messages · '
        '${result.creditCardAlerts} credit-card alerts · '
        '${result.imported} imported · ${result.skipped} skipped · '
        '${result.requiresReview} need review · '
        '${result.ignored} non-credit ignored.',
      );
    });
  }

  Future<void> _clearSms() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear imported SMS data?'),
        content: const Text(
          'This removes SMS-imported transactions, SMS review items, and SMS '
          'import history from this app. It does not delete any messages from '
          'your phone inbox. Statements and manually entered transactions are '
          'kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear SMS data'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run('sms-clear', () async {
      final service = await ref.read(smsImportServiceProvider.future);
      final result = await service.clearImported();
      _invalidateAfterImport();
      ref.invalidate(smsPermissionProvider);
      _showMessage(
        'Cleared ${result.deletedTransactions} SMS transactions and '
        '${result.deletedReviews} review items. '
        'Phone messages were not changed.',
      );
    });
  }

  Future<void> _exportCsv() async {
    await _run('csv', () async {
      final transactions = await ref.read(transactionRepositoryProvider.future);
      final cards = await ref.read(creditCardRepositoryProvider.future);
      final items = await transactions.search(limit: 1000);
      if (items.isEmpty) {
        _showMessage('There are no transactions to export.');
        return;
      }
      final cardItems = await cards.getAll(includeArchived: true);
      final csv = CsvExporter.export(
        transactions: items,
        cards: {for (final card in cardItems) card.id: card},
      );
      await FilePicker.saveFile(
        fileName: 'transactions-${formatFileDate(DateTime.now())}.csv',
        bytes: Uint8List.fromList(utf8.encode(csv)),
        mimeType: 'text/csv',
        dialogTitle: 'Save transaction export',
      );
    });
  }

  Future<void> _createBackup() async {
    final password = await _askPassword(confirm: true);
    if (password == null) return;
    await _run('backup', () async {
      final service = await ref.read(backupServiceProvider.future);
      final bytes = await service.create(password: password);
      await FilePicker.saveFile(
        fileName: 'ccm-backup-${formatFileDate(DateTime.now())}.ccmbackup',
        bytes: bytes,
        mimeType: 'application/octet-stream',
        dialogTitle: 'Save encrypted backup',
      );
      _showMessage(
        'Encrypted backup created. Keep the backup password safe; it cannot '
        'be recovered.',
      );
    });
  }

  Future<void> _restoreBackup() async {
    final file = await FilePicker.pickFile(
      type: FileType.any,
      dialogTitle: 'Choose a .ccmbackup file',
    );
    if (file == null || !mounted) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    final password = await _askPassword(confirm: false);
    if (password == null) return;
    await _run('restore', () async {
      final service = await ref.read(backupServiceProvider.future);
      final manifest = await service.restore(bytes: bytes, password: password);
      _invalidateAfterRestore();
      final transactions = manifest.tableCounts['transactions'] ?? 0;
      _showMessage(
        'Restored $transactions transactions and '
        '${manifest.includedFiles} statement files.',
      );
    });
  }

  Future<void> _wipeAll() async {
    final controller = TextEditingController();
    var canDelete = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Delete all local data?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'This permanently destroys the encrypted database, statement '
                'files, local keys, and Gmail tokens. Type DELETE to confirm.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Type DELETE'),
                onChanged: (value) =>
                    setState(() => canDelete = value.trim() == 'DELETE'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: canDelete ? () => Navigator.pop(context, true) : null,
              child: const Text('Delete everything'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (confirmed != true) return;
    await _run('wipe', () async {
      final service = await ref.read(localDataServiceProvider.future);
      await service.wipeAll();
      _invalidateAfterWipe();
      _showMessage('All local data has been deleted.');
    });
  }

  Future<String?> _askPassword({required bool confirm}) async {
    final first = TextEditingController();
    final second = TextEditingController();
    var obscure = true;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(confirm ? 'Protect backup' : 'Unlock backup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                confirm
                    ? 'Use at least 12 characters. The password is not stored '
                          'and cannot be recovered.'
                    : 'Enter the password used when this backup was created.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: first,
                obscureText: obscure,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Backup password',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => obscure = !obscure),
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              if (confirm) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: second,
                  obscureText: obscure,
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (first.text.length < 12) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Use at least 12 characters.'),
                    ),
                  );
                  return;
                }
                if (confirm && first.text != second.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match.')),
                  );
                  return;
                }
                Navigator.pop(context, first.text);
              },
              child: Text(confirm ? 'Create' : 'Restore'),
            ),
          ],
        ),
      ),
    );
    first.dispose();
    second.dispose();
    return result;
  }

  Future<void> _run(String key, Future<void> Function() action) async {
    if (_isBusy) return;
    setState(() => _busy = key);
    try {
      await action();
    } on AppFailure catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('The operation could not be completed.');
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  void _invalidateAfterImport() {
    ref.invalidate(statementsProvider);
    ref.invalidate(reviewItemsProvider);
    ref.invalidate(reviewCountProvider);
    ref.invalidate(transactionsProvider);
    ref.invalidate(transactionCountProvider);
    ref.invalidate(recentTransactionsProvider);
    ref.invalidate(homeDashboardProvider);
    ref.invalidate(importJobsProvider);
    ref.invalidate(gmailStatusProvider);
    ref.invalidate(syncCheckpointProvider);
    ref.invalidate(cashbackEntriesProvider);
  }

  void _invalidateAfterRestore() {
    _invalidateAfterImport();
    ref.invalidate(creditCardsProvider);
    ref.invalidate(knownBanksProvider);
    ref.invalidate(transactionCategoriesProvider);
    ref.invalidate(rewardsOverviewProvider);
    ref.invalidate(cashbackRulesProvider);
  }

  void _invalidateAfterWipe() {
    ref.invalidate(appDatabaseProvider);
    ref.invalidate(databaseFileProvider);
    ref.invalidate(localDataServiceProvider);
    ref.invalidate(gmailStatusProvider);
    ref.invalidate(syncCheckpointProvider);
    ref.invalidate(smsPermissionProvider);
    ref.invalidate(importJobsProvider);
    ref.invalidate(statementsProvider);
    ref.invalidate(reviewItemsProvider);
    ref.invalidate(reviewCountProvider);
    ref.invalidate(transactionsProvider);
    ref.invalidate(transactionCountProvider);
    ref.invalidate(recentTransactionsProvider);
    ref.invalidate(creditCardsProvider);
    ref.invalidate(knownBanksProvider);
    ref.invalidate(transactionCategoriesProvider);
    ref.invalidate(homeDashboardProvider);
    ref.invalidate(cashbackEntriesProvider);
    ref.invalidate(cashbackRulesProvider);
    ref.invalidate(rewardsOverviewProvider);
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _ImportJobTile extends StatelessWidget {
  const _ImportJobTile({required this.job});

  final ImportJob job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(job.sourceType, style: theme.textTheme.titleSmall),
              ),
              Text(job.status.name, style: theme.textTheme.labelSmall),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${formatDateTime(job.startedAt)} · '
            '${job.recordsImported} imported · '
            '${job.recordsSkipped} skipped · '
            '${job.recordsRequiringReview} review',
            style: theme.textTheme.bodySmall,
          ),
          if (job.errorCode != null)
            Text(
              job.errorCode!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}
