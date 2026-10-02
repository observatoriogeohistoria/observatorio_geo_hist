import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';

const _accented = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
const _plain = 'aaaaaeeeeiiiiooooouuuucn';

String _sortKey(String name) {
  final lower = name.trim().toLowerCase();
  final buffer = StringBuffer();
  for (final char in lower.split('')) {
    final index = _accented.indexOf(char);
    buffer.write(index < 0 ? char : _plain[index]);
  }
  return buffer.toString();
}

/// Ordem alfabética sem diferenciar maiúsculas nem acentos. Nomes iguais mantêm a ordem recebida.
List<TeamMemberModel> sortTeamByName(List<TeamMemberModel> team) {
  final indexed = [
    for (final (index, member) in team.indexed)
      (index: index, key: _sortKey(member.name), member: member),
  ];
  indexed.sort((a, b) {
    final byName = a.key.compareTo(b.key);
    return byName != 0 ? byName : a.index.compareTo(b.index);
  });
  return [for (final item in indexed) item.member];
}

/// Só quem tem descrição ganha página própria.
bool memberHasPage(TeamMemberModel member) {
  return member.id != null && (member.description?.trim().isNotEmpty ?? false);
}
