/// Parses string header segments like `Accept=text/html;X-Custom=Value` into a map.
Map<String, String> parseKeyValuePairs(List<String> headerStrings) {
  final headers = <String, String>{};
  for (var headerString in headerStrings) {
    for (var pair in headerString.split(';')) {
      final trimmedPair = pair.trim();
      if (trimmedPair.isEmpty) {
        continue;
      }

      final index = trimmedPair.indexOf('=');
      if (index == -1) {
        throw FormatException('''
Invalid header segment: "$trimmedPair". Expected "key=value".
For values with semicolons, use a separate --headers flag per header.''');
      }

      final key = trimmedPair.substring(0, index).trim();
      if (key.isEmpty) {
        throw FormatException(
          'Invalid header: "$trimmedPair". Key cannot be empty.',
        );
      }

      final value = trimmedPair.substring(index + 1).trim();
      headers[key] = value;
    }
  }
  return headers;
}
