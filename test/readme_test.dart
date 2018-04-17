import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  test('--help', () => _readmeCheck(['--help']));
}

Future _readmeCheck(List<String> args) async {
  var process = await _runApp(args);
  var output = (await process.stdoutStream().join('\n')).trim();
  await process.shouldExit(0);

  var readme = new File('README.md');

  var command = (['dhttpd']..addAll(args)).join(' ');
  var expected = '```console\n\$ $command\n$output\n```';

  printOnFailure(expected);

  expect(expected, r'''```console
$ dhttpd --help
-p, --port=<port>    The port to listen on.
                     (defaults to "8080")

    --path=<path>    The path to serve. If not set, the curret directory is used.
    --host=<host>    The hostname to listen on.
                     (defaults to "localhost")

-h, --help           Displays the help.
```''');

  expect(readme.readAsStringSync(), contains(expected));
}

Future<TestProcess> _runApp(List<String> args, {String workingDirectory}) {
  var fullArgs = ['bin/dhttpd.dart']..addAll(args);
  return TestProcess.start(_dartPath, fullArgs,
      workingDirectory: workingDirectory);
}

/// The path to the root directory of the SDK.
final String _sdkDir = (() {
  // The Dart executable is in "/path/to/sdk/bin/dart", so two levels up is
  // "/path/to/sdk".
  var aboveExecutable = p.dirname(p.dirname(Platform.resolvedExecutable));
  assert(FileSystemEntity.isFileSync(p.join(aboveExecutable, 'version')));
  return aboveExecutable;
})();

final String _dartPath =
    p.join(_sdkDir, 'bin', Platform.isWindows ? 'dart.exe' : 'dart');
