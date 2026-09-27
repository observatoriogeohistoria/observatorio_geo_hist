import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';

const _accented = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
const _plain = 'aaaaaeeeeiiiiooooouuuucn';

/// Chave de ordenação: minúsculas e sem acentos ("Álvaro" → "alvaro").
String _sortKey(String name) {
  final lower = name.trim().toLowerCase();
  final buffer = StringBuffer();
  for (final char in lower.split('')) {
    final index = _accented.indexOf(char);
    buffer.write(index < 0 ? char : _plain[index]);
  }
  return buffer.toString();
}

/// Membros em ordem alfabética do nome, sem diferenciar maiúsculas nem acentos
/// (spec 008). Nomes iguais mantêm a ordem recebida.
List<TeamMemberModel> sortTeamByName(List<TeamMemberModel> team) {
  final indexed = [
    for (final (index, member) in team.indexed) (index: index, key: _sortKey(member.name), member: member),
  ];
  indexed.sort((a, b) {
    final byName = a.key.compareTo(b.key);
    return byName != 0 ? byName : a.index.compareTo(b.index);
  });
  return [for (final item in indexed) item.member];
}

/// Iniciais para o círculo sem foto: primeira letra do primeiro e do último
/// nome, em maiúsculas; uma letra se o nome tiver uma palavra só; vazio se não
/// houver nome.
String memberInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();
  if (words.isEmpty) return '';
  final first = String.fromCharCode(words.first.runes.first);
  if (words.length == 1) return first.toUpperCase();
  return '$first${String.fromCharCode(words.last.runes.first)}'.toUpperCase();
}
