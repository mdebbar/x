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

  @override
  Future<void> run() async {
    final executableFile =
        File(path.join(environment.compiledDir.path, environment.platformName));
    final mainDartFile = File(path.join(environment.libDir.path, 'main.dart'));

    print('Compiling the x tool to `${executableFile.path}`...');
    await executableFile.parent.ensureExists();
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

  String get argLinkLocation => stringArg('link-location');

  @override
  Future<void> run() async {
    final linkPath = path.absolute(argLinkLocation, 'x');

    print('Creating a symlink to the x tool in `$linkPath`...');
    await environment.xFile.symlinkFrom(linkPath, overwrite: true);
  }
}
