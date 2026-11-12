/// Structured audit state for an idempotent import run.
enum ImportJobStatus {
  running,
  completed,
  completedWithReview,
  failed;

  static ImportJobStatus fromStorage(String value) {
    return ImportJobStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => ImportJobStatus.failed,
    );
  }
}

class ImportJob {
  const ImportJob({
    required this.id,
    required this.sourceType,
    required this.status,
    required this.startedAt,
    required this.recordsFound,
    required this.recordsImported,
    required this.recordsSkipped,
    required this.recordsRequiringReview,
    this.completedAt,
    this.progress,
    this.errorCode,
  });

  final String id;
  final String sourceType;
  final ImportJobStatus status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? progress;
  final int recordsFound;
  final int recordsImported;
  final int recordsSkipped;
  final int recordsRequiringReview;
  final String? errorCode;
}

enum ReviewStatus {
  open,
  resolved,
  dismissed;

  static ReviewStatus fromStorage(String value) {
    return ReviewStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => ReviewStatus.open,
    );
  }
}

/// A record that could not be imported unambiguously. Review rows are never
/// silently discarded and never contain credentials.
class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.entityType,
    required this.reasonCode,
    required this.userMessage,
    required this.status,
    required this.createdAt,
    this.entityId,
    this.sourceType,
    this.sourceReference,
    this.details,
    this.resolvedAt,
  });

  final String id;
  final String entityType;
  final String? entityId;
  final String? sourceType;
  final String? sourceReference;
  final String reasonCode;
  final String userMessage;
  final String? details;
  final ReviewStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
}
