import 'package:checks/checks.dart';
import 'package:dhttpd/src/utils.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('parseKeyValuePairs', () {
    test('parses a single key-value pair', () {
      check(parseKeyValuePairs(['Key=Value'])).deepEquals({'Key': 'Value'});
    });

    test('parses multiple pairs separated by semicolons', () {
      check(
        parseKeyValuePairs(['Key1=Value1;Key2=Value2']),
      ).deepEquals({'Key1': 'Value1', 'Key2': 'Value2'});
    });

    test('parses multiple header strings', () {
      check(
        parseKeyValuePairs(['Key1=Value1', 'Key2=Value2']),
      ).deepEquals({'Key1': 'Value1', 'Key2': 'Value2'});
    });

    test('trims whitespace around keys and values', () {
      check(
        parseKeyValuePairs(['  Key1 =  Value1  ;  Key2=Value2   ']),
      ).deepEquals({'Key1': 'Value1', 'Key2': 'Value2'});
    });

    test('ignores empty segments', () {
      check(
        parseKeyValuePairs(['Key=Value;;;Key2=Value2']),
      ).deepEquals({'Key': 'Value', 'Key2': 'Value2'});
    });

    test('allows empty values', () {
      check(parseKeyValuePairs(['Key='])).deepEquals({'Key': ''});
      check(
        parseKeyValuePairs(['Key= ; Key2=Value']),
      ).deepEquals({'Key': '', 'Key2': 'Value'});
    });

    test('handles values with equals signs', () {
      check(
        parseKeyValuePairs(['Key=Value=With=Equals']),
      ).deepEquals({'Key': 'Value=With=Equals'});
    });

    test('throws FormatException if a segment lacks an equals sign', () {
      check(() => parseKeyValuePairs(['KeyOnly']))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .contains('Expected "key=value"');
    });

    test('throws FormatException if key is empty', () {
      check(() => parseKeyValuePairs(['=Value']))
          .throws<FormatException>()
          .has((e) => e.message, 'message')
          .contains('Key cannot be empty');
    });
  });
}
