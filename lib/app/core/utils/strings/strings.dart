String convertToSnakeCase(String input) {
  return input.replaceAllMapped(RegExp('(?<!^)([A-Z])'), (Match match) {
    return '_${match.group(0)!.toLowerCase()}';
  });
}

String joinNames(List<String> names) {
  final list = [
    for (final name in names)
      if (name.trim().isNotEmpty) name.trim()
  ];
  if (list.length < 2) return list.join();
  return '${list.sublist(0, list.length - 1).join(', ')} e ${list.last}';
}

String initialsOf(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
  if (words.isEmpty) return '';
  final first = String.fromCharCode(words.first.runes.first);
  if (words.length == 1) return first.toUpperCase();
  return '$first${String.fromCharCode(words.last.runes.first)}'.toUpperCase();
}

const _accents = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', //
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', //
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', //
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ç': 'c', //
};

/// Para comparar buscas feitas na tela sem ligar para maiúsculas e acentos.
String foldForSearch(String text) {
  final lower = text.trim().toLowerCase();
  final buffer = StringBuffer();
  for (final char in lower.split('')) {
    buffer.write(_accents[char] ?? char);
  }
  return buffer.toString();
}
