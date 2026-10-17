@Timeout.factor(2)
@Tags(['presubmit-only'])
library;

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

void main() {
  for (final package in ['build_version@2.2.0', 'build_cli@2.3.1']) {
    test('ensure_build ($package)', () async {
      final result = await Process.run(Platform.resolvedExecutable, [
        'run',
        package,
        '--check',
      ]);
      check(
        result.exitCode,
        because: 'stdout: ${result.stdout}\nstderr: ${result.stderr}',
      ).equals(0);
    });
  }
}
