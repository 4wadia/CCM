import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/errors/app_failure.dart';
import '../../domain/entities/email_account.dart';
import 'email_classifier.dart';

class GmailProfile {
  const GmailProfile({required this.emailAddress});

  final String emailAddress;
}

class GmailAttachmentData {
  const GmailAttachmentData({required this.bytes});

  final List<int> bytes;
}

class GmailUnauthorizedException implements Exception {
  const GmailUnauthorizedException();
}

abstract interface class GmailClient {
  Future<GmailProfile> getProfile(String accessToken);

  Future<List<EmailCandidate>> searchMessages({
    required String accessToken,
    required String query,
    int maxResults = 25,
  });

  Future<GmailAttachmentData> downloadAttachment({
    required String accessToken,
    required String messageId,
    required String attachmentId,
    int maxBytes = 20 * 1024 * 1024,
  });
}

class GoogleGmailClient implements GmailClient {
  GoogleGmailClient({
    http.Client? httpClient,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ],
  }) : _http = httpClient ?? http.Client();

  static const String _host = 'gmail.googleapis.com';

  final http.Client _http;
  final List<Duration> retryDelays;

  @override
  Future<GmailProfile> getProfile(String accessToken) async {
    final json = await _getJson(
      Uri.https(_host, '/gmail/v1/users/me/profile'),
      accessToken,
    );
    final email = json['emailAddress'] as String?;
    if (email == null) {
      throw const AppFailure(
        code: 'CCM-GMAIL-009',
        message: 'The Gmail profile did not include an email address.',
      );
    }
    return GmailProfile(emailAddress: email);
  }

  @override
  Future<List<EmailCandidate>> searchMessages({
    required String accessToken,
    required String query,
    int maxResults = 25,
  }) async {
    final listJson = await _getJson(
      Uri.https(_host, '/gmail/v1/users/me/messages', <String, String>{
        'q': query,
        'maxResults': maxResults.toString(),
      }),
      accessToken,
    );
    final messages = (listJson['messages'] as List<Object?>? ?? const [])
        .whereType<Map<String, Object?>>();
    final candidates = <EmailCandidate>[];
    for (final message in messages) {
      final id = message['id'] as String?;
      if (id == null) continue;
      final json = await _getJson(
        Uri.https(_host, '/gmail/v1/users/me/messages/$id', <String, String>{
          'format': 'full',
        }),
        accessToken,
      );
      candidates.add(_toCandidate(id, json));
    }
    return candidates;
  }

  @override
  Future<GmailAttachmentData> downloadAttachment({
    required String accessToken,
    required String messageId,
    required String attachmentId,
    int maxBytes = 20 * 1024 * 1024,
  }) async {
    final json = await _getJson(
      Uri.https(
        _host,
        '/gmail/v1/users/me/messages/$messageId/attachments/$attachmentId',
      ),
      accessToken,
    );
    final encoded = json['data'] as String?;
    if (encoded == null) {
      throw const AppFailure(
        code: 'CCM-GMAIL-010',
        message: 'The statement attachment was empty.',
      );
    }
    final bytes = base64Url.decode(base64Url.normalize(encoded));
    if (bytes.length > maxBytes) {
      throw const AppFailure(
        code: 'CCM-GMAIL-011',
        message: 'The statement attachment is too large to import.',
      );
    }
    return GmailAttachmentData(bytes: bytes);
  }

  EmailCandidate _toCandidate(String id, Map<String, Object?> json) {
    final payload = json['payload'] as Map<String, Object?>? ?? const {};
    final headers = <String, String>{};
    for (final header
        in (payload['headers'] as List<Object?>? ?? const [])
            .whereType<Map<String, Object?>>()) {
      final name = header['name']?.toString().toLowerCase();
      if (name != null) headers[name] = header['value']?.toString() ?? '';
    }
    final attachments = <EmailAttachment>[];
    _collectAttachments(payload, attachments);
    final internalDate = int.tryParse(json['internalDate']?.toString() ?? '');
    final receivedAt = internalDate == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(internalDate);
    return EmailClassifier.classify(
      messageId: id,
      sender: headers['from'] ?? '',
      subject: headers['subject'] ?? '',
      receivedAt: receivedAt,
      attachments: attachments,
    );
  }

  void _collectAttachments(
    Map<String, Object?> part,
    List<EmailAttachment> target,
  ) {
    final body = part['body'] as Map<String, Object?>?;
    final attachmentId = body?['attachmentId'] as String?;
    final fileName = part['filename'] as String? ?? '';
    final mimeType = part['mimeType'] as String? ?? '';
    final size = (body?['size'] as num?)?.toInt() ?? 0;
    if (attachmentId != null &&
        (mimeType.toLowerCase() == 'application/pdf' ||
            fileName.toLowerCase().endsWith('.pdf'))) {
      target.add(
        EmailAttachment(
          attachmentId: attachmentId,
          fileName: fileName,
          mimeType: mimeType,
          sizeBytes: size,
        ),
      );
    }
    for (final child
        in (part['parts'] as List<Object?>? ?? const [])
            .whereType<Map<String, Object?>>()) {
      _collectAttachments(child, target);
    }
  }

  Future<Map<String, Object?>> _getJson(Uri uri, String accessToken) async {
    Object? lastError;
    for (var attempt = 0; attempt <= retryDelays.length; attempt++) {
      try {
        final response = await _http.get(
          uri,
          headers: <String, String>{
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        );
        if (response.statusCode == 401) {
          throw const GmailUnauthorizedException();
        }
        if (response.statusCode == 429 || response.statusCode >= 500) {
          lastError = AppFailure(
            code: 'CCM-GMAIL-012',
            message: 'Gmail is temporarily unavailable.',
            cause: 'HTTP ${response.statusCode}',
          );
          if (attempt < retryDelays.length) {
            await Future<void>.delayed(retryDelays[attempt]);
            continue;
          }
          throw lastError;
        }
        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw AppFailure(
            code: 'CCM-GMAIL-013',
            message: 'Gmail rejected the request.',
            cause: 'HTTP ${response.statusCode}',
          );
        }
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, Object?>) return decoded;
        throw const AppFailure(
          code: 'CCM-GMAIL-014',
          message: 'Gmail returned an unexpected response.',
        );
      } on SocketException catch (error) {
        lastError = AppFailure(
          code: 'CCM-GMAIL-015',
          message: 'Gmail could not be reached.',
          cause: error,
        );
        if (attempt < retryDelays.length) {
          await Future<void>.delayed(retryDelays[attempt]);
          continue;
        }
        throw lastError;
      } on TimeoutException catch (error) {
        lastError = AppFailure(
          code: 'CCM-GMAIL-015',
          message: 'Gmail did not respond in time.',
          cause: error,
        );
        if (attempt < retryDelays.length) {
          await Future<void>.delayed(retryDelays[attempt]);
          continue;
        }
        throw lastError;
      }
    }
    throw lastError ??
        const AppFailure(
          code: 'CCM-GMAIL-015',
          message: 'Gmail could not be reached.',
        );
  }
}

abstract final class GmailQueryBuilder {
  static String build({DateTime? after, int lookbackDays = 60}) {
    final cutoff =
        after ?? DateTime.now().subtract(Duration(days: lookbackDays));
    final date =
        '${cutoff.year.toString().padLeft(4, '0')}/'
        '${cutoff.month.toString().padLeft(2, '0')}/'
        '${cutoff.day.toString().padLeft(2, '0')}';
    return 'has:attachment filename:pdf '
        '(subject:(statement OR bill OR "credit card") OR '
        'from:(hdfcbank OR icicibank OR sbi OR axisbank OR kotak OR amex OR hsbc OR citibank)) '
        'after:$date';
  }
}
