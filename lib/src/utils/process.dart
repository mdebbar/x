import 'dart:convert';
import 'dart:io';

class ProcessOutput {
  ProcessOutput({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  final int exitCode;
  final String stdout;
  final String stderr;
}

class ProcessException implements Exception {
  ProcessException.fromProcessOutput(this._processOutput);

  final ProcessOutput _processOutput;

  String get _stdOutAndErr {
    if (_processOutput.stdout.isEmpty && _processOutput.stderr.isEmpty) {
      return '';
    }

    final StringBuffer buffer = StringBuffer();
    if (_processOutput.stdout.isNotEmpty) {
      buffer.writeln('--- stdout ---');
      buffer.writeln(_processOutput.stdout);
    }
    if (_processOutput.stderr.isNotEmpty) {
      buffer.writeln('--- stderr ---');
      buffer.writeln(_processOutput.stderr);
    }
    buffer.writeln('--------------');

    return buffer.toString();
  }

  @override
  String toString() {
    return 'ProcessException: exitCode=${_processOutput.exitCode}\n$_stdOutAndErr';
  }
}

Future<Process> startProcess(
  String executable,
  List<String> arguments, {
  required bool captureOutput,
}) async {
  return await Process.start(
    executable,
    arguments,
    mode:
        captureOutput ? ProcessStartMode.normal : ProcessStartMode.inheritStdio,
  );
}

Future<ProcessOutput> runProcess(
  String executable,
  List<String> arguments, {
  bool captureOutput = false,
}) async {
  final process =
      await startProcess(executable, arguments, captureOutput: captureOutput);

  final Future<String> stdoutFuture;
  final Future<String> stderrFuture;
  if (captureOutput) {
    stdoutFuture = process.stdout.transform(utf8.decoder).join();
    stderrFuture = process.stderr.transform(utf8.decoder).join();
  } else {
    stdoutFuture = Future.value('');
    stderrFuture = Future.value('');
  }

  final exitCode = await process.exitCode;
  final processOutput = ProcessOutput(
    exitCode: exitCode,
    stdout: await stdoutFuture,
    stderr: await stderrFuture,
  );

  if (exitCode != 0) {
    throw ProcessException.fromProcessOutput(processOutput);
  }
  return processOutput;
}
