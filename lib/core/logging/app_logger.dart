import 'dart:developer' as developer;

/// Single logging entry point.
///
/// Call sites log identifiers, status codes, and counts — never payloads.
/// The following must never be passed to this API: card numbers, CVV, PIN,
/// SMS/email/PDF content, statement text, PDF passwords, OAuth tokens, keys, or
/// birth dates used by password rules.
abstract final class AppLogger {
  static const String _name = 'credit_card_manager';

  static void debug(String message) {
    developer.log(message, name: _name, level: 500);
  }

  static void info(String message) {
    developer.log(message, name: _name, level: 800);
  }

  static void warning(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: _name,
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: _name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
