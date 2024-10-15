import 'package:glob/glob.dart';

class HttpHeaders {
  final Map<String, String> _headers = {};

  /// Stores a new header with the given [name] and [value]. If a header with
  /// the same [name] already exists (case-insensitive), the new [value] is
  /// concatenated with a comma to the existing header.
  void add({required String name, required String value}) {
    _headers.update(
      name.toLowerCase(),
      (existing) => '$existing, $value',
      ifAbsent: () => value,
    );
  }

  void addAll(HttpHeaders other) {
    for (final entry in other._headers.entries) {
      add(name: entry.key, value: entry.value);
    }
  }

  Map<String, String> asMap() => _headers;
}

/// A set of [headers] associated to a URL pattern.
class HeaderRule {
  final HttpHeaders headers;
  final Glob urlPattern;

  HeaderRule({
    required this.headers,
    String urlPattern = '/**', // Match all URLs by default.
  }) : urlPattern = Glob(urlPattern);

  /// Checks if a URL request [path] matches the URL pattern.
  bool matches(String path) => urlPattern.matches(path);
}

/// A set of [HeaderRule] with different URL patterns and headers.
class HeaderRuleSet {
  final List<HeaderRule> rules;

  HeaderRuleSet(this.rules);

  /// Returns the headers of url patterns that match the [requestUrl]
  HttpHeaders forFile(String requestUrl) {
    final headers = HttpHeaders();
    final matchingRules = rules.where((rule) => rule.matches(requestUrl));
    for (final rule in matchingRules) {
      headers.addAll(rule.headers);
    }
    return headers;
  }
}
