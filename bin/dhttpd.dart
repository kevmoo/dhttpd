import 'dart:io';

import 'package:dhttpd/dhttpd.dart';
import 'package:dhttpd/src/options.dart';

Future<void> main(List<String> args) async {
  final Options options;
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

  final httpd = await Dhttpd.start(
    path: options.path,
    port: options.port,
    headers: _parseKeyValuePairs(options.headers ?? []),
    address: options.host,
    sslCert: options.sslcert,
    sslKey: options.sslkey,
    sslPassword: options.sslkeypassword,
  );

  print('Server started at ${httpd.urlBase}.');
}

Map<String, String> _parseKeyValuePairs(List<String> headerStrings) {
  final headers = <String, String>{};
  for (var headerString in headerStrings) {
    for (var pair in headerString.split(';')) {
      final index = pair.indexOf('=');
      if (index == -1) continue;
      final key = pair.substring(0, index).trim();
      final value = pair.substring(index + 1).trim();
      if (key.isNotEmpty) {
        headers[key] = value;
      }
    }
  }
  return headers;
}
