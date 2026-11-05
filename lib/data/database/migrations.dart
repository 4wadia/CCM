import 'package:drift/drift.dart';

/// Schema version understood by this build.
///
/// Increment when a table or index changes. Add the matching step to
/// [DatabaseMigrations.stepsFor] in the same change.
const int latestSchemaVersion = 1;

/// One forward migration step.
typedef MigrationStep = Future<void> Function();

/// Raised when an upgrade path is missing. Failing loudly is safer than opening
/// a database whose schema does not match the application's expectations.
class MissingMigrationException implements Exception {
  const MissingMigrationException({
    required this.from,
    required this.to,
    required this.missingVersion,
  });

  final int from;
  final int to;
  final int missingVersion;

  @override
  String toString() =>
      'MissingMigrationException: no migration step to schema version '
      '$missingVersion (upgrade $from -> $to)';
}

/// Raised when the file was written by a newer application version.
///
/// Opening it could read unknown columns or write data the newer schema cannot
/// represent, so the database must not be opened.
class SchemaDowngradeException implements Exception {
  const SchemaDowngradeException({required this.from, required this.to});

  final int from;
  final int to;

  @override
  String toString() =>
      'SchemaDowngradeException: database version $from is newer than '
      'supported version $to';
}

/// Applies ordered steps until [to] is reached.
///
/// Exposed separately from Drift's [Migrator] so the sequencing logic can be
/// unit-tested with plain closures.
Future<void> applyMigrationPlan({
  required int from,
  required int to,
  required Map<int, Future<void> Function()> steps,
}) async {
  if (from < 0 || to < from) {
    throw ArgumentError('Invalid migration range $from -> $to');
  }

  for (var version = from + 1; version <= to; version++) {
    final step = steps[version];
    if (step == null) {
      throw MissingMigrationException(
        from: from,
        to: to,
        missingVersion: version,
      );
    }
    await step();
  }
}

/// Schema migrations for the application database.
abstract final class DatabaseMigrations {
  /// Builds the step map for the given [migrator].
  ///
  /// Real steps are added as the schema evolves. Until then an upgrade request
  /// that needs a step fails instead of silently opening an old schema.
  static Map<int, MigrationStep> stepsFor(Migrator migrator) {
    return <int, MigrationStep>{
      // 2: () async { await migrator.addColumn(...); },
    };
  }

  static Future<void> run(
    Migrator migrator, {
    required int from,
    required int to,
  }) async {
    if (to < from) {
      throw SchemaDowngradeException(from: from, to: to);
    }

    if (to > latestSchemaVersion) {
      throw MissingMigrationException(
        from: from,
        to: to,
        missingVersion: latestSchemaVersion + 1,
      );
    }

    await applyMigrationPlan(from: from, to: to, steps: stepsFor(migrator));
  }
}
