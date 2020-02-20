import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import 'src/options.dart';

class Dhttpd {
  final HttpServer _server;
  final String path;

  Dhttpd._(this._server, this.path);

  String get host => _server.address.host;

  int get port => _server.port;

  String get urlBase => 'http://$host:$port/';

  static Future<Dhttpd> start({
    String path,
    int port = defaultPort,
    address = defaultHost,
  }) async {
    path ??= Directory.current.path;

    final pipeline = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(createStaticHandler(path, defaultDocument: 'index.html'));

    final server = await io.serve(pipeline, address, port);
    return Dhttpd._(server, path);
  }

  Future destroy() => _server.close();
}
