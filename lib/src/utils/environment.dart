import 'dart:io';

import 'package:path/path.dart' as path;

import 'assert.dart';

late final String platformName;

late final Directory rootDir;

Directory get binDir => Directory(path.join(
      rootDir.path,
      'bin',
    ));
Directory get compiledDir => Directory(path.join(
      rootDir.path,
      'bin',
      'compiled',
    ));
Directory get libDir => Directory(path.join(
      rootDir.path,
      'lib',
    ));
File xFile = File(path.join(
  rootDir.path,
  'bin',
  'x',
));

void setup() {
  _ensureRootDir();
  _ensurePlatformName();
}

void _ensureRootDir() {
  final maybeRootDirPath = Platform.environment['X_ROOT_DIR'];
  prodAssert(
    maybeRootDirPath != null,
    'Expected the `X_ROOT_DIR` environment variable to be set, but it was not',
  );

  final rootDirPath = maybeRootDirPath!;
  prodAssert(
    rootDirPath.isNotEmpty,
    'Expected the `X_ROOT_DIR` environment variable to be a valid, but it was an empty string',
  );
  prodAssert(
    path.isAbsolute(rootDirPath),
    'Expected the `X_ROOT_DIR` environment variable to be an absolute path, but found: `$rootDirPath`',
  );

  rootDir = Directory(rootDirPath);

  prodAssert(
    binDir.existsSync() && libDir.existsSync() && xFile.existsSync(),
    'Expected the `X_ROOT_DIR` environment variable to point to a valid x root directory, but found: `$rootDirPath`',
  );
}

void _ensurePlatformName() {
  final maybePlatformName = Platform.environment['X_PLATFORM_NAME'];
  prodAssert(
    maybePlatformName != null,
    'Expected the `X_PLATFORM_NAME` environment variable to be set, but it was not',
  );

  platformName = maybePlatformName!;
  prodAssert(
    platformName.isNotEmpty,
    'Expected the `X_PLATFORM_NAME` environment variable to be a valid, but it was an empty string',
  );

  prodAssert(
    platformName == 'macos' || platformName == 'linux',
    'Expected the `X_PLATFORM_NAME` environment variable to be either `macos` or `linux`, but found: `$platformName`',
  );
}
