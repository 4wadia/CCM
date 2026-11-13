import 'package:drift/drift.dart';

import '../../domain/entities/import_job.dart';
import '../../domain/repositories/import_job_repository.dart';
import '../database/app_database.dart';

class ImportJobRepositoryImpl implements ImportJobRepository {
  ImportJobRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> save(ImportJob job) async {
    await _db
        .into(_db.importJobs)
        .insertOnConflictUpdate(
          ImportJobsCompanion.insert(
            id: job.id,
            sourceType: job.sourceType,
            status: job.status.name,
            startedAt: job.startedAt,
            completedAt: Value(job.completedAt),
            progress: Value(job.progress),
            recordsFound: Value(job.recordsFound),
            recordsImported: Value(job.recordsImported),
            recordsSkipped: Value(job.recordsSkipped),
            recordsRequiringReview: Value(job.recordsRequiringReview),
            errorCode: Value(job.errorCode),
          ),
        );
  }

  @override
  Future<ImportJob?> getById(String id) async {
    final row = await (_db.select(
      _db.importJobs,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntity(row);
  }

  @override
  Future<List<ImportJob>> recent({int limit = 10}) async {
    final rows =
        await (_db.select(_db.importJobs)
              ..orderBy([(table) => OrderingTerm.desc(table.startedAt)])
              ..limit(limit))
            .get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<int> deleteBySourceType(String sourceType) {
    return (_db.delete(
      _db.importJobs,
    )..where((table) => table.sourceType.equals(sourceType))).go();
  }

  ImportJob _toEntity(ImportJobRow row) {
    return ImportJob(
      id: row.id,
      sourceType: row.sourceType,
      status: ImportJobStatus.fromStorage(row.status),
      startedAt: row.startedAt,
      completedAt: row.completedAt,
      progress: row.progress,
      recordsFound: row.recordsFound,
      recordsImported: row.recordsImported,
      recordsSkipped: row.recordsSkipped,
      recordsRequiringReview: row.recordsRequiringReview,
      errorCode: row.errorCode,
    );
  }
}

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> add(ReviewItem item) async {
    await _db
        .into(_db.reviewItems)
        .insert(
          ReviewItemsCompanion.insert(
            id: item.id,
            entityType: item.entityType,
            entityId: Value(item.entityId),
            sourceType: Value(item.sourceType),
            sourceReference: Value(item.sourceReference),
            reasonCode: item.reasonCode,
            userMessage: item.userMessage,
            details: Value(item.details),
            status: Value(item.status.name),
            createdAt: item.createdAt,
            resolvedAt: Value(item.resolvedAt),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<List<ReviewItem>> listOpen({int limit = 100}) async {
    final rows =
        await (_db.select(_db.reviewItems)
              ..where((table) => table.status.equals(ReviewStatus.open.name))
              ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
              ..limit(limit))
            .get();
    return rows.map(_toEntity).toList(growable: false);
  }

  @override
  Future<int> countOpen() async {
    final count = _db.reviewItems.id.count();
    final row =
        await (_db.selectOnly(_db.reviewItems)
              ..addColumns([count])
              ..where(_db.reviewItems.status.equals(ReviewStatus.open.name)))
            .getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<void> resolve(String id) => _setStatus(id, ReviewStatus.resolved);

  @override
  Future<void> resolveForEntity({
    required String entityType,
    required String entityId,
  }) async {
    await (_db.update(_db.reviewItems)..where(
          (table) =>
              table.entityType.equals(entityType) &
              table.entityId.equals(entityId) &
              table.status.equals(ReviewStatus.open.name),
        ))
        .write(
          ReviewItemsCompanion(
            status: Value(ReviewStatus.resolved.name),
            resolvedAt: Value(DateTime.now().toUtc()),
          ),
        );
  }

  @override
  Future<void> dismiss(String id) => _setStatus(id, ReviewStatus.dismissed);

  Future<void> _setStatus(String id, ReviewStatus status) async {
    await (_db.update(
      _db.reviewItems,
    )..where((table) => table.id.equals(id))).write(
      ReviewItemsCompanion(
        status: Value(status.name),
        resolvedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<int> deleteBySourceType(String sourceType) {
    return (_db.delete(
      _db.reviewItems,
    )..where((table) => table.sourceType.equals(sourceType))).go();
  }

  @override
  Future<void> deleteAll() async {
    await _db.delete(_db.reviewItems).go();
  }

  ReviewItem _toEntity(ReviewItemRow row) {
    return ReviewItem(
      id: row.id,
      entityType: row.entityType,
      entityId: row.entityId,
      sourceType: row.sourceType,
      sourceReference: row.sourceReference,
      reasonCode: row.reasonCode,
      userMessage: row.userMessage,
      details: row.details,
      status: ReviewStatus.fromStorage(row.status),
      createdAt: row.createdAt,
      resolvedAt: row.resolvedAt,
    );
  }
}
