import 'package:drift/drift.dart';

import '../../domain/repositories/settings_repository.dart';
import '../database/app_database.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<String?> getPlain(String key) async {
    final query = _db.select(_db.appSettings)
      ..where((table) => table.settingKey.equals(key));
    final row = await query.getSingleOrNull();
    return row?.plainValue;
  }

  @override
  Future<void> setPlain(String key, String value) async {
    final query = _db.select(_db.appSettings)
      ..where((table) => table.settingKey.equals(key));
    final existing = await query.getSingleOrNull();
    final now = DateTime.now().toUtc();

    if (existing == null) {
      await _db
          .into(_db.appSettings)
          .insert(
            AppSettingsCompanion.insert(
              id: 'setting:$key',
              settingKey: key,
              plainValue: Value(value),
              updatedAt: now,
            ),
          );
      return;
    }

    final update = _db.update(_db.appSettings)
      ..where((table) => table.id.equals(existing.id));
    await update.write(
      AppSettingsCompanion(plainValue: Value(value), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> remove(String key) async {
    await (_db.delete(
      _db.appSettings,
    )..where((table) => table.settingKey.equals(key))).go();
  }
}
