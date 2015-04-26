import 'dart:io';

import 'package:args/args.dart';
import 'package:simple_http_server/simple_http_server.dart';

main(List<String> args) async {
  var argParser = new ArgParser()
    ..addOption('port',
        abbr: 'p',
        defaultsTo: DEFAULT_PORT.toString(),
        valueHelp: 'port',
        help: 'The port to listen on.')
    ..addOption('path',
        valueHelp: 'path', help: 'The path to serve (defaults to the cwd).')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Displays the help.');

  var results = argParser.parse(args);

  if (results['help']) {
    print(argParser.usage);
    exit(1);
  }

  var port = int.parse(results['port'], onError: (source) {
    stderr.writeln('port must be a number');
    exit(1);
  });

  String path =
      results['path'] != null ? results['path'] : Directory.current.path;

  await SimpleHttpServer.start(path: path, port: port);

  print('Server started on port $port');
}
