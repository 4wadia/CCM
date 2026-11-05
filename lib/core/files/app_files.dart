import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Location of the encrypted database inside app-private storage.
///
/// The directory is intentionally app-private. Statement files will live in a
/// sibling directory with opaque names.
Future<File> appDatabaseFile() async {
  final supportDirectory = await getApplicationSupportDirectory();
  final directory = Directory(
    p.join(supportDirectory.path, 'credit_card_manager'),
  );
  await directory.create(recursive: true);
  return File(p.join(directory.path, 'ccm.sqlite'));
}
