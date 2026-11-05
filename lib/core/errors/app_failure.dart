/// A typed, user-safe failure returned across layer boundaries.
///
/// [code] is stable and documented (`CCM-<DOMAIN>-<NNN>`). [message] is safe to
/// show to the user and must never contain card numbers, message content, or
/// credentials. [cause] is for local diagnosis only and is never serialized.
class AppFailure implements Exception {
  const AppFailure({required this.code, required this.message, this.cause});

  final String code;
  final String message;
  final Object? cause;

  @override
  String toString() => 'AppFailure($code)';
}
