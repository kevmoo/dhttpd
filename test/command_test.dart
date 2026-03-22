// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:io';

import 'package:dhttpd/src/version.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:test_process/test_process.dart';

void main() {
  test('prints version', _versionCheck);
  test('prints help', () => _readmeCheck(['--help']));
  test('serves on specified port', _outputCheck);
  test('handles custom headers', _headersCheck);
  test('rejects invalid headers', _invalidHeadersCheck);
  test('does not log requests when quiet', _quietCheck);
}

Future<void> _versionCheck() async {
  final process = await _runApp(['--version']);
  final output = (await process.stdoutStream().join('\n')).trim();
  await process.shouldExit(0);
  expect(output, packageVersion);
}

Future<void> _readmeCheck(List<String> args) async {
  final process = await _runApp(args);
  final output = (await process.stdoutStream().join('\n')).trimRight();
  await process.shouldExit(0);

  final readme = File('README.md');

  final command = ['dhttpd', ...args].join(' ');
  final expected =
      '''
```console
\$ $command
$output
```''';

  printOnFailure(expected);

  expect(expected, r'''```console
$ dhttpd --help
    --headers=<headers>                  HTTP headers to apply to each response. Can be used multiple times. Format: header=value;header2=value
    --host=<host>                        The hostname to listen on.
                                         (defaults to "localhost")
-l, --list-files                         List the files in the directory if no index.html is present.
    --path=<path>                        The path to serve. If not set, the current directory is used.
-p, --port=<port>                        The port to listen on. Provide `0` to use a random port.
                                         (defaults to "8080")
-q, --quiet                              Disable logging.
    --sslcert=<sslcert>                  The SSL certificate to use. Also requires sslkey
    --sslkey=<sslkey>                    The key of the SSL certificate to use. Also requires sslcert
    --sslkeypassword=<sslkeypassword>    The password for the key of the SSL certificate to use.
-h, --help                               Displays the help.
    --version                            Prints the version of dhttpd.
```''');

  expect(readme.readAsStringSync(), contains(expected));
}

Future<void> _headersCheck() async {
  await d.file('index.html', 'Hello World').create();

  final process = await _runApp([
    '--port=8001',
    '--path',
    d.sandbox,
    '--headers',
    'X-Custom=Value1; X-Another = Value 2',
    '--headers',
    'X-Third=Value3',
    '--headers',
    'X-Empty-Val=;X-With-Equals=foo=bar',
    '--headers',
    ' X-Spaced-Key = spaced-value ',
  ]);
  final line = await process.stdout.next;
  expect(line, 'Serving ${d.sandbox} at http://localhost:8001');

  final response = await http.get(Uri.parse('http://localhost:8001'));
  expect(response.statusCode, 200);
  expect(response.headers['x-custom'], 'Value1');
  expect(response.headers['x-another'], 'Value 2');
  expect(response.headers['x-third'], 'Value3');
  expect(response.headers['x-empty-val'], '');
  expect(response.headers['x-with-equals'], 'foo=bar');
  expect(response.headers['x-spaced-key'], 'spaced-value');

  await process.kill();
}

Future<void> _invalidHeadersCheck() async {
  final process = await _runApp(['--headers', 'invalid-format']);
  expect(
    await process.stderr.next,
    contains('Invalid header segment: "invalid-format". Expected "key=value".'),
  );
  expect(
    await process.stderr.next,
    contains(
      'For values with semicolons, use a separate --headers flag '
      'per header.',
    ),
  );
  await process.shouldExit(64);
}

Future<void> _outputCheck() async {
  await d.file('index.html', 'Hello World').create();

  final process = await _runApp(['--port=8000', '--path', d.sandbox]);
  final line = await process.stdout.next;
  expect(line, 'Serving ${d.sandbox} at http://localhost:8000');

  final response = await http.get(Uri.parse('http://localhost:8000'));
  expect(response.statusCode, 200);
  expect(response.body, 'Hello World');

  await process.kill();
}

Future<void> _quietCheck() async {
  await d.file('index.html', 'Hello World').create();

  final process = await _runApp([
    '--port=8002',
    '--path',
    d.sandbox,
    '--quiet',
  ]);
  final line = await process.stdout.next;
  expect(line, 'Serving ${d.sandbox} at http://localhost:8002');

  final response = await http.get(Uri.parse('http://localhost:8002'));
  expect(response.statusCode, 200);
  expect(response.body, 'Hello World');

  await process.kill();
  expect(await process.stdout.rest.toList(), isEmpty);
}

Future<TestProcess> _runApp(List<String> args, {String? workingDirectory}) =>
    TestProcess.start(Platform.resolvedExecutable, [
      'bin/dhttpd.dart',
      ...args,
    ], workingDirectory: workingDirectory);
