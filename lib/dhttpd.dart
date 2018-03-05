import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

const int DEFAULT_PORT = 8080;
const String DEFAULT_HOST = 'localhost';

class Dhttpd {
  static Future<Dhttpd> start(
      {String path, int port: DEFAULT_PORT, address: DEFAULT_HOST}) async {
    if (path == null) path = Directory.current.path;

    final handler = createStaticHandler(path, defaultDocument: 'index.html');

    final pipeline = const Pipeline().addMiddleware(logRequests());

    HttpServer server =
        await io.serve(pipeline.addHandler(handler), address, port);
    return new Dhttpd._(server, path);
  }

  final HttpServer _server;
  final String _path;

  Dhttpd._(this._server, this._path);

  String get host => _server.address.host;

  String get path => _path;

  int get port => _server.port;

  String get urlBase => 'http://${host}:${port}/';

  Future destroy() => _server.close();
}
