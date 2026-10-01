/// Helper method to convert CamelCase to snake_case
String convertToSnakeCase(String input) {
  return input.replaceAllMapped(RegExp('(?<!^)([A-Z])'), (Match match) {
    return '_${match.group(0)!.toLowerCase()}';
  });
}

/// Nomes numa frase: ["A"] → "A", ["A", "B"] → "A e B", ["A", "B", "C"] →
/// "A, B e C". Ignora nomes vazios.
String joinNames(List<String> names) {
  final list = [for (final name in names) if (name.trim().isNotEmpty) name.trim()];
  if (list.length < 2) return list.join();
  return '${list.sublist(0, list.length - 1).join(', ')} e ${list.last}';
}

/// Iniciais para um círculo sem foto: primeira letra do primeiro e do último
/// nome, em maiúsculas; uma letra se o nome tiver uma palavra só; vazio se não
/// houver nome.
String initialsOf(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
  if (words.isEmpty) return '';
  final first = String.fromCharCode(words.first.runes.first);
  if (words.length == 1) return first.toUpperCase();
  return '$first${String.fromCharCode(words.last.runes.first)}'.toUpperCase();
}
