import 'dart:convert';

/// Rich editor text (Quill delta) as a single plain line. Anything that isn't a delta comes back as is.
String plainTextFromRich(String content) {
  final text = content.trim();
  if (text.isEmpty) return '';

  try {
    final decoded = jsonDecode(text);
    final ops = decoded is Map ? decoded['ops'] : decoded;
    if (ops is! List) return _compact(text);

    final buffer = StringBuffer();
    for (final op in ops) {
      if (op is Map && op['insert'] is String) buffer.write(op['insert']);
    }
    return _compact(buffer.toString());
  } on FormatException {
    return _compact(text);
  }
}

String _compact(String text) => text.replaceAll(RegExp(r'\s+'), ' ').trim();
