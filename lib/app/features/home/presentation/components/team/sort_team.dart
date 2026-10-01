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

/// Membro com página própria (`/membro/:id`): tem id e descrição não vazia.
/// A mesma regra decide quem é link na grade da Home.
bool memberHasPage(TeamMemberModel member) {
  return member.id != null && (member.description?.trim().isNotEmpty ?? false);
}
