import 'dart:io';

import 'package:dhttpd/dhttpd.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http_io;
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  late Dhttpd server;

  tearDown(() async {
    await server.destroy();
  });

  test('serves static files', () async {
    await d.file('index.html', 'Hello World').create();

    server = await Dhttpd.start(path: d.sandbox, port: 0);

    final response = await http.get(Uri.parse(server.urlBase));

    expect(response.statusCode, HttpStatus.ok);
    expect(response.body, 'Hello World');
    expect(
      response.headers[HttpHeaders.contentTypeHeader],
      contains('text/html'),
    );
  });

  test('custom headers', () async {
    await d.file('index.html', 'Hello World').create();

    server = await Dhttpd.start(
      path: d.sandbox,
      port: 0,
      headers: {'X-Test-Header': 'TestValue'},
    );

    final response = await http.get(Uri.parse(server.urlBase));

    expect(response.statusCode, HttpStatus.ok);
    expect(response.headers['x-test-header'], 'TestValue');
  });

  test('404 handling', () async {
    server = await Dhttpd.start(path: d.sandbox, port: 0);

    final response = await http.get(
      Uri.parse('${server.urlBase}/notfound.html'),
    );

    expect(response.statusCode, HttpStatus.notFound);
  });

  test('SSL configuration', () async {
    await d.file('index.html', 'Hello SSL').create();

    final certPath = p.join(
      Directory.current.path,
      'example',
      'server_chain.pem',
    );
    final keyPath = p.join(Directory.current.path, 'example', 'server_key.pem');

    server = await Dhttpd.start(
      path: d.sandbox,
      port: 0,
      sslCert: certPath,
      sslKey: keyPath,
      sslPassword: 'dartdart',
    );

    expect(server.isSSL, isTrue);
    expect(server.urlBase, startsWith('https://'));

    // Create a client that ignores SSL errors for self-signed certificates
    final ioClient = HttpClient()
      ..badCertificateCallback = ((_, _, _) => true);
    final client = http_io.IOClient(ioClient);

    try {
      final response = await client.get(Uri.parse(server.urlBase));
      expect(response.statusCode, HttpStatus.ok);
      expect(response.body, 'Hello SSL');
    } finally {
      client.close();
    }
  });
}
