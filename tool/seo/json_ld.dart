import 'dart:convert';

// Code points that `jsonEncode` leaves raw: markup characters that could close the script tag, and
// the two line separators that older parsers read as line breaks inside strings.
const List<int> _unsafe = [0x3c, 0x3e, 0x26, 0x2028, 0x2029];

String _escapeCodeUnit(int unit) =>
    '${String.fromCharCode(0x5c)}u${unit.toRadixString(16).padLeft(4, '0')}';

/// A title with `</script>` would close the tag, so unsafe characters leave as `\uXXXX`. The
/// result is still valid JSON and reads back as the original text.
String jsonLdScript(Map<String, dynamic> data) {
  var json = jsonEncode(data);
  for (final unit in _unsafe) {
    json = json.replaceAll(String.fromCharCode(unit), _escapeCodeUnit(unit));
  }
  return '<script type="application/ld+json">$json</script>';
}
