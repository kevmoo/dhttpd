import 'dart:io';

import 'package:args/args.dart';
import 'package:dhttpd/dhttpd.dart';

main(List<String> args) async {
  var argParser = new ArgParser()
    ..addOption('port',
        abbr: 'p',
        defaultsTo: DEFAULT_PORT.toString(),
        valueHelp: 'port',
        help: 'The port to listen on.')
    ..addOption('path',
        valueHelp: 'path', help: 'The path to serve (defaults to the cwd).')
    ..addOption('host',
        defaultsTo: DEFAULT_HOST.toString(),
        valueHelp: 'host',
        help: 'The hostname to listen on (defaults to "localhost").')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Displays the help.');

  var results = argParser.parse(args);

  if (results['help']) {
    print(argParser.usage);
    return;
  }

  var port = int.parse(results['port'], onError: (source) => null);

  if (port == null) {
    stderr.writeln('`port` must be a number.\n');
    print(argParser.usage);
    exitCode = 64; // bad usage
    return;
  }

  var hostname = results['host'];

  var path = results['path'] as String ?? Directory.current.path;

  await Dhttpd.start(path: path, port: port, address: hostname);

  print('Server started on port $port');
}
