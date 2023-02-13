import 'package:args/command_runner.dart';

import 'commands.dart';
import 'src/utils/environment.dart' as environment;

void main(List<String> args) {
  environment.setup();

  var runner = CommandRunner('x', 'The x productivity tool');
  for (var command in topLevelCommands) {
    runner.addCommand(command);
  }
  runner.run(args);
}
