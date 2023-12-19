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

  /// [address] can either be a [String] or an
  /// [InternetAddress]. If [address] is a [String], [start] will
  /// perform a [InternetAddress.lookup] and use the first value in the
  /// list. To listen on the loopback adapter, which will allow only
  /// incoming connections from the local host, use the value
  /// [InternetAddress.loopbackIPv4] or
  /// [InternetAddress.loopbackIPv6]. To allow for incoming
  /// connection from the network use either one of the values
  /// [InternetAddress.anyIPv4] or [InternetAddress.anyIPv6] to
  /// bind to all interfaces or the IP address of a specific interface.
  static Future<Dhttpd> start({
    String? path,
    int port = defaultPort,
    Object address = defaultHost,
    Map<String, String>? headers,
  }) async {
    path ??= Directory.current.path;

    final pipeline = const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(headersMiddleware(headers))
        .addHandler(createStaticHandler(path, defaultDocument: 'index.html'));

    final server = await io.serve(pipeline, address, port);
    return Dhttpd._(server, path);
  }

  Future<void> destroy() => _server.close();
}

Middleware headersMiddleware(Map<String, String>? headers) =>
    (Handler innerHandler) => (Request request) async {
          final response = await innerHandler(request);
          final responseHeaders = Map<String, String>.from(response.headers);
          if (headers != null) {
            for (var entry in headers.entries) {
              responseHeaders[entry.key] = entry.value;
            }
          }
          final newResponse = response.change(headers: responseHeaders);
          return newResponse;
        };
