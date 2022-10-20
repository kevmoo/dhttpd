import 'dart:io';

import 'package:dhttpd/dhttpd.dart';
import 'package:dhttpd/src/options.dart';
import 'package:dhttpd/src/version.dart';

Future<void> main(List<String> args) async {
  Options options;
  try {
    options = parseOptions(args);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    print(usage);
    exitCode = 64;
    return;
  }

  if (options.help) {
    print(usage);
    return;
  }

  if (options.version) {
    print(packageVersion);
    return;
  }

  await Dhttpd.start(
    path: options.path,
    port: options.port,
    address: options.host,
  );

  print('Server started on port ${options.port}');
}
