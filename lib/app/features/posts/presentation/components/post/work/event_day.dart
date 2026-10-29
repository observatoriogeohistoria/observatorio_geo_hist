class EventDay {
  const EventDay({required this.day, required this.month});

  final int day;

  /// Abbreviated and lowercase ("nov").
  final String month;
}

const _months = [
  'janeiro',
  'fevereiro',
  'marco',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

const _daysInMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

final _numeric = RegExp(r'^(\d{1,2})\s*[º°ªo]?\s*/\s*(\d{1,2})(?!\d)');
final _written = RegExp(
  r'^(\d{1,2})\s*[º°ªo]?(?:(?:\s*[,–-]\s*|\s+(?:e|a|até)\s+)\d{1,2}\s*[º°ªo]?)*\s+de\s+([a-z]+)',
);

/// The event date is free text in the panel; only the start is read ("14/11[/2026]",
/// "14 de novembro", "06 a 10 de julho" by its first day), and anything else gets no box.
EventDay? eventDayOf(String date) {
  final text = date.trim().toLowerCase().replaceAll('ç', 'c');

  final numeric = _numeric.firstMatch(text);
  final written = numeric == null ? _written.firstMatch(text) : null;
  final day = int.tryParse((numeric ?? written)?.group(1) ?? '');
  final month = switch ((numeric, written)) {
    (final match?, _) => int.tryParse(match.group(2)!),
    (_, final match?) => _months.indexOf(match.group(2)!) + 1,
    _ => null,
  };

  if (day == null || month == null || month < 1 || month > 12) return null;
  if (day < 1 || day > _daysInMonth[month - 1]) return null;

  return EventDay(day: day, month: _months[month - 1].substring(0, 3));
}
