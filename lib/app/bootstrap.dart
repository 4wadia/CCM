import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging/app_logger.dart';
import 'app.dart';

/// Application entry point.
///
/// Keep this function small. Database opens, platform channels, and background
/// task registration are added by the milestones that own them, and must not
/// block the first frame.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    AppLogger.error(
      'Unhandled Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    AppLogger.error(
      'Unhandled platform error',
      error: error,
      stackTrace: stackTrace,
    );
    return true;
  };

  runApp(const ProviderScope(child: CreditCardManagerApp()));
}
