import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

const int DEFAULT_PORT = 8080;

class SimpleHttpServer {
  static Future<SimpleHttpServer> start({String path, int port: DEFAULT_PORT}) {
    if (path == null) path = Directory.current.path;

    var handler = createStaticHandler(Directory.current.path,
        defaultDocument: 'index.html');

    var pipeline = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(handler);

    return io.serve(pipeline, 'localhost', port).then((HttpServer server) {
      return new SimpleHttpServer._(server, path);
    });
  }

  final HttpServer _server;
  final String _path;

  SimpleHttpServer._(this._server, this._path);

  String get host => _server.address.host;

  String get path => _path;

  int get port => _server.port;

  String get urlBase => 'http://${host}:${port}/';

  Future destroy() => _server.close();
}
