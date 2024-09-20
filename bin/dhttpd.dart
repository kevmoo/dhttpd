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

  final httpd = await Dhttpd.start(
    path: options.path,
    port: options.port,
    headers:
        options.headers != null ? _parseKeyValuePairs(options.headers!) : null,
    address: options.host,
    sslCert: options.sslcert,
    sslKey: options.sslkey,
    sslPassword: options.sslkeypassword,
  );

  print('Server HTTP${httpd.isSSL ? 'S' : ''} started on port ${options.port}');
}

Map<String, String> _parseKeyValuePairs(String str) => <String, String>{
      for (var match in _regex.allMatches(str))
        match.group(1)!: match.group(2)!,
    };

final _regex = RegExp(r'([\w-]+)=(.|[^;]+)(;|$)');
