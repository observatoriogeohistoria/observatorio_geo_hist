extension DateTimeFormatting on DateTime {
  String get monthName {
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    return months[month - 1];
  }

  String get shortDate {
    const months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];

    return '$day ${months[month - 1]} $year';
  }
}

const _monthNamesLower = [
  'janeiro',
  'fevereiro',
  'março',
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

String formatMonthYear(String value) {
  final text = value.trim();
  final match = RegExp(r'^(\d{1,2})/(\d{4})$').firstMatch(text);
  if (match == null) return text;
  final month = int.parse(match.group(1)!);
  if (month < 1 || month > 12) return text;
  return '${_monthNamesLower[month - 1]} de ${match.group(2)}';
}
