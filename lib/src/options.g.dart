// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

T _$badNumberFormat<T extends num>(
  String source,
  String type,
  String argName,
) =>
    throw FormatException(
      'Cannot parse "$source" into `$type` for option "$argName".',
    );

Options _$parseOptionsResult(ArgResults result) => Options(
      port: int.tryParse(result['port'] as String) ??
          _$badNumberFormat(
            result['port'] as String,
            'int',
            'port',
          ),
      path: result['path'] as String?,
      headers: result['headers'] as String?,
      host: result['host'] as String,
      sslcert: result['sslcert'] as String?,
      sslkey: result['sslkey'] as String?,
      sslkeypassword: result['sslkeypassword'] as String?,
      help: result['help'] as bool,
    );

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption(
    'port',
    abbr: 'p',
    help: 'The port to listen on.',
    valueHelp: 'port',
    defaultsTo: '8080',
  )
  ..addOption(
    'path',
    help: 'The path to serve. If not set, the current directory is used.',
    valueHelp: 'path',
  )
  ..addOption(
    'headers',
    help: 'HTTP headers to apply to each response. header=value;header2=value',
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
    help: 'The SSL certificate to use.\r\nIf set along with sslkey, '
        'https will be used.\r\nSee the dart documentation about '
        'SecurityContext.useCertificateChain for more.',
    valueHelp: 'sslcert',
  )
  ..addOption(
    'sslkey',
    help:
        'The key of the SSL certificate to use.\r\nIf set along with sslcert, '
        'https will be used.\r\nSee the dart documentation about '
        'SecurityContext.usePrivateKey for more.',
    valueHelp: 'sslkey',
  )
  ..addOption(
    'sslkeypassword',
    help: 'The password for the key of the SSL certificate to use.\r\nRequired '
        'if the ssl key being used has a password set.\r\nSee the dart '
        'documentation about SecurityContext.usePrivateKey for more.',
    valueHelp: 'sslkeypassword',
  )
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Displays the help.',
    negatable: false,
  );

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
