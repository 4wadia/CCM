import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;

class PdfPasswordException implements Exception {
  const PdfPasswordException();
}

class PdfExtractionException implements Exception {
  const PdfExtractionException({this.cause});

  final Object? cause;

  @override
  String toString() => 'PdfExtractionException';
}

abstract interface class PdfTextExtractor {
  Future<String> extract({required List<int> bytes, String? password});
}

/// Local Syncfusion PDF text extraction. The package is used only for parsing
/// bytes already in app-private storage; no content leaves the device.
class SyncfusionPdfTextExtractor implements PdfTextExtractor {
  const SyncfusionPdfTextExtractor();

  @override
  Future<String> extract({required List<int> bytes, String? password}) async {
    try {
      final document = syncfusion.PdfDocument(
        inputBytes: Uint8List.fromList(bytes),
        password: password,
      );
      try {
        return syncfusion.PdfTextExtractor(document)
            .extractText(layoutText: true);
      } finally {
        document.dispose();
      }
    } catch (error) {
      final message = error.toString().toLowerCase();
      if (message.contains('password') ||
          message.contains('encrypt') ||
          message.contains('decrypt')) {
        throw const PdfPasswordException();
      }
      throw PdfExtractionException(cause: error);
    }
  }
}
