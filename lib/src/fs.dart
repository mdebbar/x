import 'dart:io';

import 'package:path/path.dart' as path;

import 'utils/assert.dart';

extension FileSystemEntityExtension on FileSystemEntity {
  Future<void> symlinkFrom(String linkPath, {bool overwrite = false}) async {
    prodAssert(isAbsolute, 'must be an absolute path.');
    prodAssert(await exists(), 'must point to an existing file or directory.');
    prodAssert(
      path.isAbsolute(linkPath),
      '`linkPath` must be an absolute path.',
    );

    final link = Link(linkPath);
    if (await link.exists()) {
      if (overwrite) {
        await link.update(this.path);
      } else {
        throw Exception(
          'Cannot create symlink at `$linkPath` because it already exists. Did you mean to use `overwrite: true`?',
        );
      }
    } else {
      await link.create(this.path);
    }
  }
}

extension DirectoryExtension on Directory {
  Future<void> ensureExists() async {
    prodAssert(isAbsolute, 'must be an absolute path.');

    if (!(await exists())) {
      await create(recursive: true);
    }
  }
}
