import 'dart:io';

import 'package:dhttpd/dhttpd.dart';
import 'package:dhttpd/src/headers.dart';
import 'package:dhttpd/src/headers_parser.dart';
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
    headers: _parseHeaders(options.headers, options.headersfile),
    address: options.host,
    sslCert: options.sslcert,
    sslKey: options.sslkey,
    sslPassword: options.sslkeypassword,
  );

  print('Server HTTP${httpd.isSSL ? 'S' : ''} started on port ${options.port}');
}

HeaderRuleSet _parseHeaders(String? headers, String? headersfile) {
  final rules = <HeaderRule>[];
  if (headers != null) rules.add(HeadersParser.parseString(headers));
  if (headersfile != null) rules.addAll(HeadersParser.parseFile(headersfile));
  return HeaderRuleSet(rules);
}
