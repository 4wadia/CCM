import '../entities/import_job.dart';

abstract interface class ImportJobRepository {
  Future<void> save(ImportJob job);

  Future<ImportJob?> getById(String id);

  Future<List<ImportJob>> recent({int limit = 10});
}

abstract interface class ReviewRepository {
  Future<void> add(ReviewItem item);

  Future<List<ReviewItem>> listOpen({int limit = 100});

  Future<int> countOpen();

  Future<void> resolve(String id);

  Future<void> resolveForEntity({
    required String entityType,
    required String entityId,
  });

  Future<void> dismiss(String id);

  Future<void> deleteAll();
}
