import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Location of the encrypted database inside app-private storage.
///
/// The directory is intentionally app-private. Statement files live in a
/// sibling directory with opaque names.
Future<File> appDatabaseFile() async {
  final directory = await _appSupportDirectory();
  return File(p.join(directory.path, 'ccm.sqlite'));
}

/// Opaque encrypted statement files. Never exposed through a public path.
Future<Directory> appStatementsDirectory() async {
  final support = await _appSupportDirectory();
  final directory = Directory(p.join(support.path, 'statements'));
  await directory.create(recursive: true);
  return directory;
}

/// Temporary staging area for plaintext files. Callers must delete plaintext
/// files immediately after encryption.
Future<Directory> appTemporaryDirectory() async {
  final temporary = await getTemporaryDirectory();
  final directory = Directory(p.join(temporary.path, 'ccm_staging'));
  await directory.create(recursive: true);
  return directory;
}

/// User-exported backups and CSVs. The app itself always writes backups through
/// the platform picker; this directory is a fallback for share exports.
Future<Directory> appExportsDirectory() async {
  final documents = await getApplicationDocumentsDirectory();
  final directory = Directory(p.join(documents.path, 'credit_card_manager'));
  await directory.create(recursive: true);
  return directory;
}

Future<Directory> _appSupportDirectory() async {
  final supportDirectory = await getApplicationSupportDirectory();
  final directory = Directory(
    p.join(supportDirectory.path, 'credit_card_manager'),
  );
  await directory.create(recursive: true);
  return directory;
}
