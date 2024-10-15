import 'package:dhttpd/src/headers.dart';
import 'package:dhttpd/src/headers_parser.dart';
import 'package:test/test.dart';

void main() {
  const examplePath = '/public/page.html';
  const exampleTextFile = 'sample/_headers';
  const exampleJsonFile = 'sample/headers.json';

  group('Parsing headers passed as a string', () {
    test('(empty)', () {
      final headerRule = HeadersParser.parseString('');
      final headers = HeaderRuleSet([headerRule]);
      expect(
        headers.forFile(examplePath).asMap(),
        isEmpty,
      );
    });

    test('(one header)', () {
      final headerRule = HeadersParser.parseString('Content-Type=text/plain');
      final headers = HeaderRuleSet([headerRule]);
      expect(
        headers.forFile(examplePath).asMap(),
        {'content-type': 'text/plain'},
      );
    });

    test('(two headers)', () {
      final headerRule = HeadersParser.parseString(
          'Content-Type=text/plain;content-length=42');
      final headers = HeaderRuleSet([headerRule]);
      expect(
        headers.forFile(examplePath).asMap(),
        {
          'content-type': 'text/plain',
          'content-length': '42',
        },
      );
    });

    test('(with bad formatting)', () {
      final headerRule = HeadersParser.parseString(
          'Content-Type=text/plain;Content-Length: 42');
      final headers = HeaderRuleSet([headerRule]);
      expect(
        headers.forFile(examplePath).asMap(),
        {'content-type': 'text/plain'},
      );
    });
  });

  test('Parsing headers from a plain/text file', () {
    final headerRules = HeadersParser.parseFile(exampleTextFile);
    final headers = HeaderRuleSet(headerRules);
    expect(
      headers.forFile(examplePath).asMap(),
      {
        'cross-origin-embedder-policy': 'credentialless',
        'cross-origin-opener-policy': 'same-origin',
        'access-control-allow-origin': '*',
        'cache-control': 'max-age=0, must-revalidate',
      },
    );
  });

  test('Parsing headers from a JSON file', () {
    final headerRules = HeadersParser.parseFile(exampleJsonFile);
    final headers = HeaderRuleSet(headerRules);
    expect(
      headers.forFile(examplePath).asMap(),
      {
        'cross-origin-embedder-policy': 'credentialless',
        'cross-origin-opener-policy': 'same-origin',
        'access-control-allow-origin': '*',
        'cache-control': 'max-age=0, must-revalidate',
      },
    );
  });
}
