import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'headers.dart';

class HeadersParser {
  static HeaderRule parseString(String str) {
    final headers = HttpHeaders();
    for (final match in _regex.allMatches(str)) {
      headers.add(name: match.group(1)!, value: match.group(2)!);
    }
    return HeaderRule(headers: headers);
  }

  static List<HeaderRule> parseFile(String file) {
    if (!_isFile(file)) throw ArgumentError('$file is not a file');

    final ext = p.extension(file);
    if (ext == '.json') return _JsonHeadersParser.parse(file);
    if (ext == '.txt' || ext == '') return _TxtHeaderParser.parse(file);
    throw ArgumentError('Invalid headers file: $file');
  }

  static bool _isFile(String str) => FileSystemEntity.isFileSync(str);

  static final _regex = RegExp(r'([\w-]+)=([^\s;]+)(;|$)');
}

/// Parses headers in JSON format. Each rule is a JSON object with a `source`
/// pattern and a list of `headers`. For example:
/// ```json
/// "headers": [ {
///   "source": "/**",
///   "headers": [ {
///     "key": "Access-Control-Allow-Origin",
///     "value": "*"
///   } ]
/// } ]
/// ```
class _JsonHeadersParser {
  static List<HeaderRule> parse(String file) {
    final json = jsonDecode(File(file).readAsStringSync());
    final jsonHeaders = switch (json) {
      {'hosting': {'headers': final List<dynamic> headers}} => headers,
      {'headers': final List<dynamic> headers} => headers,
      _ => throw FormatException('Invalid JSON headers file: $file')
    };

    return <HeaderRule>[
      for (final jsonRule in jsonHeaders) _parseRule(jsonRule)
    ];
  }

  static HeaderRule _parseRule(dynamic jsonRule) => switch (jsonRule) {
        {
          'source': final String source,
          'headers': final List<dynamic> headers,
        } =>
          HeaderRule(
            headers: _parseHeaders(headers),
            urlPattern: _processUrlPattern(source),
          ),
        _ => throw FormatException('Invalid headers rule:\n$jsonRule')
      };

  static HttpHeaders _parseHeaders(List<dynamic> jsonHeaders) {
    final headers = HttpHeaders();
    for (final header in jsonHeaders) {
      switch (header) {
        case {'key': final String key, 'value': final String value}:
          headers.add(name: key, value: value);
        default:
          throw FormatException('Invalid header:\n$header');
      }
    }
    return headers;
  }

  /// Replaces @(option1|option2|...|optionN) constructs with the corresponding
  /// syntax of the Glob package: {option1,option2,...,optionN}.
  static String _processUrlPattern(String urlPattern) {
    final regex = RegExp(r'@\(([^)]+)\)');
    return urlPattern.replaceAllMapped(
      regex,
      (match) => '{${match.group(1)!.split('|').join(',')}}',
    );
  }
}

/// Parses headers in plain text format. Headers must be specified in blocks,
/// with each block starting with a URL pattern followed by an indented list
/// of headers. For example:
/// ```
/// # This is a comment
/// /secure/page
///   X-Frame-Options: DENY
///   X-Content-Type-Options: nosniff
///   Referrer-Policy: no-referrer
///
/// /static/*
///   Access-Control-Allow-Origin: *
///   X-Robots-Tag: nosnippet
/// ```
class _TxtHeaderParser {
  static final _ruleRegex = RegExp(
    r'^([^\s#]+)$(?:\r\n|\r|\n)((?:[ \t]+.+$(?:\r\n|\r|\n)?)+)',
    multiLine: true,
  );
  static final _headerRegex = RegExp(
    r'^[ \t]+([^#\s][\w-]+): (.+)$',
    multiLine: true,
  );

  static List<HeaderRule> parse(String file) {
    final content = File(file).readAsStringSync();
    return _parseRules(content);
  }

  static List<HeaderRule> _parseRules(String str) => [
        for (final match in _ruleRegex.allMatches(str))
          HeaderRule(
            headers: _parseHeaders(match.group(2)!),
            urlPattern: _processPattern(match.group(1)!),
          ),
      ];

  static HttpHeaders _parseHeaders(String str) {
    final headers = HttpHeaders();
    for (final match in _headerRegex.allMatches(str)) {
      headers.add(name: match.group(1)!, value: match.group(2)!);
    }
    return headers;
  }

  /// Replaces the wildcard character `*` with `**` to match any number of
  /// characters, including '/'. This is the behavior of Cloudflare Pages
  /// and Netlify.
  static String _processPattern(String pattern) =>
      pattern.replaceAll('*', '**');
}
