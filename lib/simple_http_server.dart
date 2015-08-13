library simple_http_server;

import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_cors/shelf_cors.dart' as shelf_cors;

const int DEFAULT_PORT = 8080;
const String DEFAULT_HOST = 'localhost';

class SimpleHttpServer {
  static Future<SimpleHttpServer> start(
      {String path, int port: DEFAULT_PORT, String allowOrigin, address: DEFAULT_HOST}) async {
    if (path == null) path = Directory.current.path;

    final handler = createStaticHandler(path,
        defaultDocument: 'index.html');

    final pipeline =
        const Pipeline().addMiddleware(logRequests());

    if (allowOrigin != null) {
      final corsHeaders = {
        'Access-Control-Allow-Origin': allowOrigin,
      };
      pipeline.addMiddleware(shelf_cors.createCorsHeadersMiddleware(corsHeaders: corsHeaders));
    }

    HttpServer server = await io.serve(pipeline.addHandler(handler), address, port);
    return new SimpleHttpServer._(server, path);
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
