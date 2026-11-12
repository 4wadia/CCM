import 'dart:io';

import 'package:flutter/services.dart';

import '../../core/errors/app_failure.dart';
import '../../domain/entities/sms_message.dart';

/// Permission-gated native SMS access. iOS deliberately returns unsupported.
abstract interface class SmsPlatform {
  bool get isSupported;

  Future<bool> hasPermission();

  Future<bool> requestPermission();

  Future<List<SmsMessage>> readMessages({
    required DateTime from,
    DateTime? to,
    int limit = 500,
  });
}

class MethodChannelSmsPlatform implements SmsPlatform {
  MethodChannelSmsPlatform({this.channel = _defaultChannel});

  static const MethodChannel _defaultChannel = MethodChannel(
    'app.creditcardmanager/sms',
  );

  final MethodChannel channel;

  @override
  bool get isSupported => Platform.isAndroid;

  @override
  Future<bool> hasPermission() async {
    if (!isSupported) return false;
    try {
      return await channel.invokeMethod<bool>('hasPermission') ?? false;
    } on PlatformException catch (error) {
      throw AppFailure(
        code: 'CCM-SMS-001',
        message: 'SMS permission could not be checked.',
        cause: error,
      );
    } on MissingPluginException catch (error) {
      throw AppFailure(
        code: 'CCM-SMS-002',
        message: 'SMS import is not available on this platform.',
        cause: error,
      );
    }
  }

  @override
  Future<bool> requestPermission() async {
    if (!isSupported) return false;
    try {
      return await channel.invokeMethod<bool>('requestPermission') ?? false;
    } on PlatformException catch (error) {
      throw AppFailure(
        code: 'CCM-SMS-003',
        message: 'SMS permission could not be requested.',
        cause: error,
      );
    } on MissingPluginException catch (error) {
      throw AppFailure(
        code: 'CCM-SMS-002',
        message: 'SMS import is not available on this platform.',
        cause: error,
      );
    }
  }

  @override
  Future<List<SmsMessage>> readMessages({
    required DateTime from,
    DateTime? to,
    int limit = 500,
  }) async {
    if (!isSupported) return const <SmsMessage>[];
    try {
      final rows = await channel.invokeListMethod<Map<Object?, Object?>>(
        'readMessages',
        <String, Object?>{
          'fromMillis': from.millisecondsSinceEpoch,
          'toMillis': (to ?? DateTime.now()).millisecondsSinceEpoch,
          'limit': limit,
        },
      );
      if (rows == null) return const <SmsMessage>[];
      return rows
          .map(
            (row) => SmsMessage(
              id: row['id']?.toString() ?? '',
              sender: row['sender']?.toString() ?? '',
              body: row['body']?.toString() ?? '',
              receivedAt: DateTime.fromMillisecondsSinceEpoch(
                (row['receivedAtMillis'] as num?)?.toInt() ?? 0,
              ),
            ),
          )
          .where((message) => message.id.isNotEmpty)
          .toList(growable: false);
    } on PlatformException catch (error) {
      throw AppFailure(
        code: 'CCM-SMS-004',
        message: 'SMS messages could not be read.',
        cause: error,
      );
    } on MissingPluginException catch (error) {
      throw AppFailure(
        code: 'CCM-SMS-002',
        message: 'SMS import is not available on this platform.',
        cause: error,
      );
    }
  }
}

class UnsupportedSmsPlatform implements SmsPlatform {
  const UnsupportedSmsPlatform();

  @override
  bool get isSupported => false;

  @override
  Future<bool> hasPermission() async => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<List<SmsMessage>> readMessages({
    required DateTime from,
    DateTime? to,
    int limit = 500,
  }) async => const <SmsMessage>[];
}
