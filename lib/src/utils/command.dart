import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'assert.dart';

extension CommandArgsExtension on Command {
  ArgResults get args {
    prodAssert(
      argResults != null,
      'Trying to access args before they are parsed.',
    );

    return argResults!;
  }

  bool boolArg(String name) => args[name] as bool;
  int intArg(String name) => args[name] as int;
  String stringArg(String name) => args[name] as String;
  List<String> stringsArg(String name) => args[name] as List<String>;

  UsageException wrongArg(String name, String message) {
    prodAssert(
      argParser.options.containsKey(name),
      'Trying to throw an exception about a wrong argument, but the argument "$name" does not exist.',
    );

    return UsageException(
      'Wrong value for argument "$name": $message',
      usage,
    );
  }
}
