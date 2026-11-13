import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../domain/entities/email_account.dart';
import '../../../../domain/entities/import_job.dart';

final gmailStatusProvider = FutureProvider<EmailAccount?>((ref) async {
  final repository = await ref.watch(emailAccountRepositoryProvider.future);
  return repository.firstConnected();
});

final syncCheckpointProvider = FutureProvider<SyncCheckpoint?>((ref) async {
  final account = await ref.watch(gmailStatusProvider.future);
  if (account == null) return null;
  final repository = await ref.watch(emailAccountRepositoryProvider.future);
  return repository.checkpointFor(account.id);
});

final importJobsProvider = FutureProvider<List<ImportJob>>((ref) async {
  final repository = await ref.watch(importJobRepositoryProvider.future);
  return repository.recent(limit: 8);
});

final gmailConfiguredProvider = Provider<bool>(
  (ref) => ref.watch(oauthServiceProvider).isConfigured,
);

final smsSupportedProvider = Provider<bool>(
  (ref) => ref.watch(smsPlatformProvider).isSupported,
);

final smsPermissionProvider = FutureProvider<bool>((ref) async {
  final platform = ref.watch(smsPlatformProvider);
  if (!platform.isSupported) return false;
  return platform.hasPermission();
});
