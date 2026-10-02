import 'dart:convert';

/// Texto do editor rico (delta do Quill) em uma linha simples. O que não é delta volta como veio.
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
