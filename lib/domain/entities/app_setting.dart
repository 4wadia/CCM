/// A persisted application setting.
///
/// Secrets belong in platform secure storage, never in this entity.
class AppSetting {
  const AppSetting({
    required this.key,
    required this.updatedAt,
    this.plainValue,
    this.encryptedValue,
  });

  final String key;
  final String? plainValue;
  final String? encryptedValue;
  final DateTime updatedAt;
}
