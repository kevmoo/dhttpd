// ignore_for_file: lines_longer_than_80_chars

import 'package:build_cli_annotations/build_cli_annotations.dart';

part 'options.g.dart';

String get usage => _$parserForOptions.usage;

const int defaultPort = 8080;
const String defaultHost = 'localhost';

@CliOptions()
class Options {
  @CliOption(
      abbr: 'p',
      valueHelp: 'port',
      defaultsTo: defaultPort,
      help: 'The port to listen on.')
  final int port;

  @CliOption(
      valueHelp: 'path',
      help: 'The path to serve.'
          ' If not set, the current directory is used.')
  final String? path;

  @CliOption(
      valueHelp: 'cert',
      help: 'The certificate to use.'
          '\r\nIf not set, https will not be used.'
          '\r\nSee the dart documentation about SecurityContext.useCertificateChain for more.')
  final String? cert;

  @CliOption(
      valueHelp: 'key',
      help: 'The key of the certificate to use.'
          '\r\nIf not set, https will not be used.'
          '\r\nSee the dart documentation about SecurityContext.usePrivateKey for more.')
  final String? key;

  @CliOption(
      defaultsTo: defaultHost,
      valueHelp: 'host',
      help: 'The hostname to listen on.')
  final String host;

  @CliOption(abbr: 'h', negatable: false, help: 'Displays the help.')
  final bool help;

  Options({
    required this.port,
    this.path,
    this.cert,
    this.key,
    required this.host,
    required this.help,
  });
}
