import 'dart:io';
import 'package:args/args.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

const int DEFAULT_PORT = 8080;

void main(List args) {
  var port = DEFAULT_PORT;

  var argParser = new ArgParser();
  argParser.addOption('port', abbr: 'p', defaultsTo: DEFAULT_PORT.toString(),
                      help: 'The port to listen on.', valueHelp: 'port', callback: (_port) {
    port = int.parse(_port, onError: (source) {
      stderr.writeln('ERROR: Port must be a number.');
      exit(1);
    });
  });
  argParser.addFlag('help', negatable: false, help: 'Displays the help.', callback: (help) {
    if (help) {
      print(argParser.getUsage());
      exit(1);
    }
  });

  argParser.parse(args);

  var handler = createStaticHandler(Directory.current.path,
                                    defaultDocument: 'index.html');

  io.serve(handler, 'localhost', port).then((_) => print('Server started on port $port'));
}