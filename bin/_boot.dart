library _boot;

import 'dart:io';
import 'package:args/args.dart';
import 'package:dhttpd/dhttpd.dart';

bootServer(List<String> args) async {
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
    ..addOption('allow-origin',
        valueHelp: 'allow-origin',
        help: "The value for the 'Access-Control-Allow-Origin' header.")
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

  var hostname = results['host'];

  String path =
      results['path'] != null ? results['path'] : Directory.current.path;

  await Dhttpd.start(
      path: path,
      port: port,
      allowOrigin: results['allow-origin'],
      address: hostname);

  print('Server started on port $port');
}
