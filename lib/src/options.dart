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
      valueHelp: 'headers',
      help:
          'HTTP headers to apply to each response. header=value;header2=value')
  final String? headers;

  @CliOption(
      valueHelp: 'headersfile',
      help:
          'File with HTTP header rules to apply to each response.')
  final String? headersfile;

  @CliOption(
      defaultsTo: defaultHost,
      valueHelp: 'host',
      help: 'The hostname to listen on.')
  final String host;

  @CliOption(
      valueHelp: 'sslcert',
      help: 'The SSL certificate to use. Also requires sslkey')
  final String? sslcert;

  @CliOption(
      valueHelp: 'sslkey',
      help: 'The key of the SSL certificate to use. Also requires sslcert')
  final String? sslkey;

  @CliOption(
      valueHelp: 'sslkeypassword',
      help: 'The password for the key of the SSL certificate to use.')
  final String? sslkeypassword;

  @CliOption(abbr: 'h', negatable: false, help: 'Displays the help.')
  final bool help;

  Options({
    required this.port,
    this.path,
    this.headers,
    this.headersfile,
    required this.host,
    this.sslcert,
    this.sslkey,
    this.sslkeypassword,
    required this.help,
  });
}
