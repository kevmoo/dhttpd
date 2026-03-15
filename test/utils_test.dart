import 'package:dhttpd/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('parseKeyValuePairs', () {
    test('parses a single key-value pair', () {
      expect(parseKeyValuePairs(['Key=Value']), equals({'Key': 'Value'}));
    });

    test('parses multiple pairs separated by semicolons', () {
      expect(
        parseKeyValuePairs(['Key1=Value1;Key2=Value2']),
        equals({'Key1': 'Value1', 'Key2': 'Value2'}),
      );
    });

    test('parses multiple header strings', () {
      expect(
        parseKeyValuePairs(['Key1=Value1', 'Key2=Value2']),
        equals({'Key1': 'Value1', 'Key2': 'Value2'}),
      );
    });

    test('trims whitespace around keys and values', () {
      expect(
        parseKeyValuePairs(['  Key1 =  Value1  ;  Key2=Value2   ']),
        equals({'Key1': 'Value1', 'Key2': 'Value2'}),
      );
    });

    test('ignores empty segments', () {
      expect(
        parseKeyValuePairs(['Key=Value;;;Key2=Value2']),
        equals({'Key': 'Value', 'Key2': 'Value2'}),
      );
    });

    test('allows empty values', () {
      expect(parseKeyValuePairs(['Key=']), equals({'Key': ''}));
      expect(
        parseKeyValuePairs(['Key= ; Key2=Value']),
        equals({'Key': '', 'Key2': 'Value'}),
      );
    });

    test('handles values with equals signs', () {
      expect(
        parseKeyValuePairs(['Key=Value=With=Equals']),
        equals({'Key': 'Value=With=Equals'}),
      );
    });

    test('throws FormatException if a segment lacks an equals sign', () {
      expect(
        () => parseKeyValuePairs(['KeyOnly']),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Expected "key=value"'),
          ),
        ),
      );
    });

    test('throws FormatException if key is empty', () {
      expect(
        () => parseKeyValuePairs(['=Value']),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('Key cannot be empty'),
          ),
        ),
      );
    });
  });
}
