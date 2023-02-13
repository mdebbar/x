import 'dart:io';

import 'utils/assert.dart';
import 'utils/process.dart';

Future<void> symlink({
  required File originalFile,
  required File linkFile,
  bool overwrite = false,
}) async {
  prodAssert(
    originalFile.isAbsolute,
    '`original` must be an absolute path to the original file.',
  );
  prodAssert(
    linkFile.isAbsolute,
    '`link` must be an absolute path to the link file.',
  );
  prodAssert(
    await originalFile.exists(),
    '`original` must point to an existing file.',
  );

  // TODO: This doesn't work on Windows.
  await runProcess('ln', [
    if (overwrite) '-f',
    '-s',
    originalFile.path,
    linkFile.path,
  ]);
}
