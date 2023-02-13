import 'dart:io';

import 'utils/assert.dart';
import 'utils/process.dart';

Future<void> dartCompileToExecutable({
  required File dartFile,
  required File outFile,
}) async {
  prodAssert(
    dartFile.isAbsolute,
    '`dartFile` must be an absolute path to the Dart file to compile.',
  );
  prodAssert(
    outFile.isAbsolute,
    '`outFile` must be an absolute path to the output file.',
  );
  prodAssert(
    await dartFile.exists(),
    '`dartFile` must point to an existing file.',
  );

  await runProcess('dart', [
    'compile',
    'exe',
    dartFile.path,
    '-o',
    outFile.path,
  ]);
}
