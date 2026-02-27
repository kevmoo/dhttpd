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
    headers: _parseKeyValuePairs(options.headers),
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
      final trimmedPair = pair.trim();
      if (trimmedPair.isEmpty) {
        continue;
      }

      final index = trimmedPair.indexOf('=');
      if (index == -1) {
        throw FormatException(
          'Invalid header segment: "$trimmedPair". Expected "key=value".\n'
          'For values with semicolons, use a separate --headers flag '
          'per header.',
        );
      }

      final key = trimmedPair.substring(0, index).trim();
      if (key.isEmpty) {
        throw FormatException(
          'Invalid header: "$trimmedPair". Key cannot be empty.',
        );
      }

      final value = trimmedPair.substring(index + 1).trim();
      headers[key] = value;
    }
  }
  return headers;
}
