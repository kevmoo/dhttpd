import 'dart:io';

import 'package:dhttpd/dhttpd.dart';
import 'package:dhttpd/src/options.dart';

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

  await Dhttpd.start(
    path: options.path,
    port: options.port,
    headers:
        options.headers != null ? parseKeyValuePairs(options.headers!) : null,
    address: options.host,
  );

  print('Server started on port ${options.port}');
}

Map<String, String> parseKeyValuePairs(String str) {
  final regex = RegExp(r'([\w-]+)=([\w-]+)(;|$)');
  final map = <String, String>{};
  for (final match in regex.allMatches(str)) {
    final key = match.group(1)!;
    final value = match.group(2)!;
    map[key] = value;
  }
  return map;
}
