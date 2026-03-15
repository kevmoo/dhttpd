import 'package:build_cli_annotations/build_cli_annotations.dart';

part 'options.g.dart';

String get usage => _$parserForOptions.usage;

const int defaultPort = 8080;
const String defaultHost = 'localhost';

@CliOptions()
class Options {
  @CliOption(
    valueHelp: 'headers',
    help:
        'HTTP headers to apply to each response. '
        'Can be used multiple times. '
        'Format: header=value;header2=value',
  )
  final List<String> headers;

  @CliOption(
    defaultsTo: defaultHost,
    valueHelp: 'host',
    help: 'The hostname to listen on.',
  )
  final String host;

  @CliOption(
    abbr: 'l',
    negatable: false,
    help: 'List the files in the directory if no index.html is present.',
  )
  final bool listFiles;

  @CliOption(
    valueHelp: 'path',
    help:
        'The path to serve.'
        ' If not set, the current directory is used.',
  )
  final String? path;

  @CliOption(
    abbr: 'p',
    valueHelp: 'port',
    defaultsTo: defaultPort,
    help: 'The port to listen on. Provide `0` to use a random port.',
  )
  final int port;

  @CliOption(
    valueHelp: 'sslcert',
    help: 'The SSL certificate to use. Also requires sslkey',
  )
  final String? sslcert;

  @CliOption(
    valueHelp: 'sslkey',
    help: 'The key of the SSL certificate to use. Also requires sslcert',
  )
  final String? sslkey;

  @CliOption(
    valueHelp: 'sslkeypassword',
    help: 'The password for the key of the SSL certificate to use.',
  )
  final String? sslkeypassword;

  @CliOption(abbr: 'h', negatable: false, help: 'Displays the help.')
  final bool help;

  @CliOption(negatable: false, help: 'Prints the version of dhttpd.')
  final bool version;

  Options({
    required this.headers,
    required this.host,
    this.listFiles = false,
    this.path,
    required this.port,
    this.sslcert,
    this.sslkey,
    this.sslkeypassword,
    required this.help,
    this.version = false,
  });
}
