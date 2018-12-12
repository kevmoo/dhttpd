// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

T _$badNumberFormat<T extends num>(
        String source, String type, String argName) =>
    throw FormatException(
        'Cannot parse "$source" into `$type` for option "$argName".');

Options _$parseOptionsResult(ArgResults result) => Options(
    port: int.tryParse(result['port'] as String) ??
        _$badNumberFormat(result['port'] as String, 'int', 'port'),
    path: result['path'] as String,
    host: result['host'] as String,
    help: result['help'] as bool);

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('port',
      abbr: 'p',
      help: 'The port to listen on.',
      valueHelp: 'port',
      defaultsTo: '8080')
  ..addOption('path',
      help: 'The path to serve. If not set, the curret directory is used.',
      valueHelp: 'path')
  ..addOption('host',
      help: 'The hostname to listen on.',
      valueHelp: 'host',
      defaultsTo: 'localhost')
  ..addFlag('help', abbr: 'h', help: 'Displays the help.', negatable: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
