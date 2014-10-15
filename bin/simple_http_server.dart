import 'dart:io';
import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

const int _DEFAULT_PORT = 8080;

void main(List<String> args) {
  var argParser = new ArgParser()
      ..addOption('port', abbr: 'p', defaultsTo: _DEFAULT_PORT.toString(),
                      help: 'The port to listen on.', valueHelp: 'port')
      ..addFlag('help', negatable: false, help: 'Displays the help.');

  var results = argParser.parse(args);

  if (results['help']) {
    print(argParser.getUsage());
    exit(1);
  }

  var port = int.parse(results['port'], onError: (source) {
    stderr.writeln('port must be a number');
    exit(1);
  });

  var handler = createStaticHandler(Directory.current.path,
      defaultDocument: 'index.html');

  var pipeline = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(handler);

  io.serve(pipeline, 'localhost', port).then((_) {
    print('Server started on port $port');
  });
}
