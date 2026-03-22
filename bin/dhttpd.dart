import 'dart:io';

import 'package:dhttpd/dhttpd.dart';
import 'package:dhttpd/src/options.dart';
import 'package:dhttpd/src/utils.dart';
import 'package:dhttpd/src/version.dart';

Future<void> main(List<String> args) async {
  final Options options;
  final Map<String, String> headers;
  try {
    options = parseOptions(args);
    headers = parseKeyValuePairs(options.headers);
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

  final httpd = await Dhttpd.start(
    path: options.path,
    port: options.port,
    headers: headers,
    address: options.host,
    sslCert: options.sslcert,
    sslKey: options.sslkey,
    sslPassword: options.sslkeypassword,
    listFiles: options.listFiles,
    quiet: options.quiet,
  );

  print('Serving ${httpd.path} at ${httpd.urlBase}');
}
