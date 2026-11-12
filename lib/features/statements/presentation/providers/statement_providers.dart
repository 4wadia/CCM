import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../domain/entities/statement.dart';

final statementsProvider = FutureProvider<List<Statement>>((ref) async {
  final repository = await ref.watch(statementRepositoryProvider.future);
  return repository.getAll();
});

final statementTransactionsProvider =
    FutureProvider.family<List<StatementTransaction>, String>((
      ref,
      statementId,
    ) async {
      final repository = await ref.watch(statementRepositoryProvider.future);
      return repository.transactionsFor(statementId);
    });
