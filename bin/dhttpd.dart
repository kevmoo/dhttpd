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

  SecurityContext? securityContext;
  final cert = options.cert;
  final key = options.key;
  if (cert != null && key != null) {
    print('Using certificate ${options.cert} with key ${options.key} for ssl');
    securityContext = SecurityContext()
      ..useCertificateChain(cert)
      ..usePrivateKey(key);
  } else {
    print('Parameter cert/key not set, not using ssl');
  }

  await Dhttpd.start(
      path: options.path,
      port: options.port,
      address: options.host,
      securityContext: securityContext);

  print('Server started on port ${options.port}');
}
