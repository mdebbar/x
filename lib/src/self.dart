import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

import 'dart.dart';
import 'fs.dart';
import 'utils/command.dart';
import 'utils/environment.dart' as environment;

class SelfCommand extends Command {
  @override
  final name = 'self';

  @override
  final description = 'Run commands on the x tool itself.';

  SelfCommand() {
    addSubcommand(SelfSymlinkCommand());
    addSubcommand(SelfCompileCommand());
    // addSubcommand(SelfUpdateCommand());
  }
}

class SelfCompileCommand extends Command {
  @override
  final name = 'compile';

  @override
  final description = 'Compile the x tool to a standalone executable.';

  SelfCompileCommand() {
    argParser.addOption(
      'executable-filename',
      abbr: 'f',
      help: 'Name of the executable file.',
      mandatory: true,
    );
  }

  String get argExecutableFilename => stringArg('executable-filename');

  @override
  Future<void> run() async {
    if (path.basename(argExecutableFilename) != argExecutableFilename) {
      throw wrongArg(
        'executable-filename',
        'must be a filename only with no path.',
      );
    }
    final executableFile =
        File(path.join(environment.compiledDir.path, argExecutableFilename));
    final mainDartFile = File(path.join(environment.libDir.path, 'main.dart'));

    print('Compiling the x tool to `${executableFile.path}`...');
    await dartCompileToExecutable(
      dartFile: mainDartFile,
      outFile: executableFile,
    );
  }
}

class SelfSymlinkCommand extends Command {
  @override
  final name = 'symlink';

  @override
  final description = 'Create a symlink to the x tool in the given location.';

  SelfSymlinkCommand() {
    argParser.addOption(
      'link-location',
      abbr: 'l',
      help: 'Path to the location where the x tool should be symlinked.',
      defaultsTo: '/usr/local/bin',
    );
  }

  String get argLocation => stringArg('link-location');

  @override
  Future<void> run() async {
    final linkDir = Directory(argLocation).absolute;
    if (!(await linkDir.exists())) {
      throw wrongArg('link-location', 'must point to an existing directory.');
    }

    final linkFile = File(path.join(linkDir.path, 'x'));
    final originalFile = environment.xFile;

    print('Creating a symlink to the x tool in `${linkFile.path}`...');
    await symlink(
      originalFile: originalFile,
      linkFile: linkFile,
      overwrite: true,
    );
  }
}
