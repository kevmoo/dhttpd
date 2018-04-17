// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options.dart';

// **************************************************************************
// Generator: CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) {
  T badNumberFormat<T extends num>(
          String source, String type, String argName) =>
      throw new FormatException(
          'Cannot parse "$source" into `$type` for option "$argName".');

  return new Options(
      port: int.tryParse(result['port'] as String) ??
          badNumberFormat(result['port'] as String, 'int', 'port'),
      path: result['path'] as String,
      host: result['host'] as String,
      help: result['help'] as bool);
}

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addOption('port',
      abbr: 'p',
      help: 'The port to listen on.',
      valueHelp: 'port',
      defaultsTo: '8080')
  ..addOption('path',
      help: 'The path to serve (defaults to the cwd).', valueHelp: 'path')
  ..addOption('host',
      help: 'The hostname to listen on (defaults to "localhost").',
      valueHelp: 'host',
      defaultsTo: 'localhost')
  ..addFlag('help', abbr: 'h', help: 'Displays the help.', negatable: false);

final _$parserForOptions = _$populateOptionsParser(new ArgParser());

Options parseOptions(List<String> args) {
  var result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
