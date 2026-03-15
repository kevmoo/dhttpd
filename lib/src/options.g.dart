// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

T _$badNumberFormat<T extends num>(
  String source,
  String type,
  String argName,
) => throw FormatException(
  'Cannot parse "$source" into `$type` for option "$argName".',
);

Options _$parseOptionsResult(ArgResults result) => Options(
  port:
      int.tryParse(result['port'] as String) ??
      _$badNumberFormat(result['port'] as String, 'int', 'port'),
  path: result['path'] as String?,
  headers: result['headers'] as List<String>,
  host: result['host'] as String,
  sslcert: result['sslcert'] as String?,
  sslkey: result['sslkey'] as String?,
  sslkeypassword: result['sslkeypassword'] as String?,
  help: result['help'] as bool,
  listFiles: result['list-files'] as bool,
  version: result['version'] as bool,
);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption(
    'port',
    abbr: 'p',
    help: 'The port to listen on. Provide `0` to use a random port.',
    valueHelp: 'port',
    defaultsTo: '8080',
  )
  ..addOption(
    'path',
    help: 'The path to serve. If not set, the current directory is used.',
    valueHelp: 'path',
  )
  ..addMultiOption(
    'headers',
    help:
        'HTTP headers to apply to each response. Can be used multiple times. Format: header=value;header2=value',
    valueHelp: 'headers',
  )
  ..addOption(
    'host',
    help: 'The hostname to listen on.',
    valueHelp: 'host',
    defaultsTo: 'localhost',
  )
  ..addOption(
    'sslcert',
    help: 'The SSL certificate to use. Also requires sslkey',
    valueHelp: 'sslcert',
  )
  ..addOption(
    'sslkey',
    help: 'The key of the SSL certificate to use. Also requires sslcert',
    valueHelp: 'sslkey',
  )
  ..addOption(
    'sslkeypassword',
    help: 'The password for the key of the SSL certificate to use.',
    valueHelp: 'sslkeypassword',
  )
  ..addFlag('help', abbr: 'h', help: 'Displays the help.', negatable: false)
  ..addFlag(
    'list-files',
    abbr: 'l',
    help: 'List the files in the directory if no index.html is present.',
    negatable: false,
  )
  ..addFlag('version', help: 'Prints the version of dhttpd.', negatable: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
