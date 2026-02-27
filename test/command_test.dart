import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:test_process/test_process.dart';

void main() {
  test('--help', () => _readmeCheck(['--help']));
  test('--port=8000', _outputCheck);
  test('custom headers', _headersCheck);
}

Future<void> _readmeCheck(List<String> args) async {
  final process = await _runApp(args);
  final output = (await process.stdoutStream().join('\n')).trim();
  await process.shouldExit(0);

  final readme = File('README.md');

  final command = ['dhttpd', ...args].join(' ');
  final expected = '```console\n\$ $command\n$output\n```';

  printOnFailure(expected);

  expect(expected, r'''```console
$ dhttpd --help
-p, --port=<port>                        The port to listen on.
                                         (defaults to "8080")
    --path=<path>                        The path to serve. If not set, the current directory is used.
    --headers=<headers>                  HTTP headers to apply to each response. Can be used multiple times. Format: header=value;header2=value
    --host=<host>                        The hostname to listen on.
                                         (defaults to "localhost")
    --sslcert=<sslcert>                  The SSL certificate to use. Also requires sslkey
    --sslkey=<sslkey>                    The key of the SSL certificate to use. Also requires sslcert
    --sslkeypassword=<sslkeypassword>    The password for the key of the SSL certificate to use.
-h, --help                               Displays the help.
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
  ]);
  final line = await process.stdout.next;
  expect(line, 'Server started at http://localhost:8001.');

  final response = await http.get(Uri.parse('http://localhost:8001'));
  expect(response.statusCode, 200);
  expect(response.headers['x-custom'], 'Value1');
  expect(response.headers['x-another'], 'Value 2');
  expect(response.headers['x-third'], 'Value3');

  await process.kill();
}

Future<void> _outputCheck() async {
  await d.file('index.html', 'Hello World').create();

  final process = await _runApp(['--port=8000', '--path', d.sandbox]);
  final line = await process.stdout.next;
  expect(line, 'Server started at http://localhost:8000.');

  final response = await http.get(Uri.parse('http://localhost:8000'));
  expect(response.statusCode, 200);
  expect(response.body, 'Hello World');

  await process.kill();
}

Future<TestProcess> _runApp(List<String> args, {String? workingDirectory}) =>
    TestProcess.start(Platform.resolvedExecutable, [
      'bin/dhttpd.dart',
      ...args,
    ], workingDirectory: workingDirectory);
