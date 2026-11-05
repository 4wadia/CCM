abstract interface class SettingsRepository {
  Future<String?> getPlain(String key);

  /// Inserts or updates a plain setting.
  Future<void> setPlain(String key, String value);

  Future<void> remove(String key);
}
