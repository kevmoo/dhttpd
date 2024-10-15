import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  test('--help', () => _readmeCheck(['--help']));
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
    --headers=<headers>                  HTTP headers to apply to each response. header=value;header2=value
    --headersfile=<headersfile>          File with HTTP header rules to apply to each response.
    --host=<host>                        The hostname to listen on.
                                         (defaults to "localhost")
    --sslcert=<sslcert>                  The SSL certificate to use. Also requires sslkey
    --sslkey=<sslkey>                    The key of the SSL certificate to use. Also requires sslcert
    --sslkeypassword=<sslkeypassword>    The password for the key of the SSL certificate to use.
-h, --help                               Displays the help.
```''');

  expect(readme.readAsStringSync(), contains(expected));
}

Future<TestProcess> _runApp(List<String> args, {String? workingDirectory}) {
  final fullArgs = ['bin/dhttpd.dart', ...args];
  return TestProcess.start(_dartPath, fullArgs,
      workingDirectory: workingDirectory);
}

/// The path to the root directory of the SDK.
final String _sdkDir = (() {
  // The Dart executable is in "/path/to/sdk/bin/dart", so two levels up is
  // "/path/to/sdk".
  final aboveExecutable = p.dirname(p.dirname(Platform.resolvedExecutable));
  assert(FileSystemEntity.isFileSync(p.join(aboveExecutable, 'version')));
  return aboveExecutable;
})();

final String _dartPath =
    p.join(_sdkDir, 'bin', Platform.isWindows ? 'dart.exe' : 'dart');
