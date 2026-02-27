import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

import 'src/options.dart';

class Dhttpd {
  final HttpServer _server;
  final String path;
  final SecurityContext? _securityContext;

  Dhttpd._(this._server, this.path, this._securityContext);

  String get host => _server.address.host;

  int get port => _server.port;

  String get urlBase =>
      Uri(scheme: isSSL ? 'https' : 'http', host: host, port: port).toString();

  bool get isSSL => _securityContext != null;

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
    String? sslCert,
    String? sslKey,
    String? sslPassword,
  }) async {
    path ??= Directory.current.path;

    SecurityContext? securityContext;
    if (sslCert != null && sslKey != null) {
      securityContext = SecurityContext()
        ..useCertificateChain(sslCert)
        ..usePrivateKey(sslKey, password: sslPassword);
    }

    final pipeline = const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(_headersMiddleware(headers))
        .addHandler(createStaticHandler(path, defaultDocument: 'index.html'));

    final server = await io.serve(
      pipeline,
      address,
      port,
      securityContext: securityContext,
    );
    return Dhttpd._(server, path, securityContext);
  }

  Future<void> destroy() => _server.close();
}

Middleware _headersMiddleware(Map<String, String>? headers) {
  if (headers == null || headers.isEmpty) return (handler) => handler;

  return (handler) => (request) async {
    final response = await handler(request);
    return response.change(headers: headers);
  };
}
