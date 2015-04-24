import 'dart:io';

import 'package:args/args.dart';
import 'package:simple_http_server/simple_http_server.dart';

const int _DEFAULT_PORT = 8080;

main(List<String> args) async {
  var argParser = new ArgParser()
    ..addOption('port',
        abbr: 'p',
        defaultsTo: _DEFAULT_PORT.toString(),
        help: 'The port to listen on.',
        valueHelp: 'port')
    ..addOption('path', help: 'The path to serve (defaults to the cwd).')
    ..addFlag('help', negatable: false, help: 'Displays the help.');

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
      results.wasParsed('path') ? results['path'] : Directory.current.path;

  await SimpleHttpServer.start(path: path, port: port);

  print('Server started on port $port');
}
