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

  /// Data curta, como "12 mar 2026" (mês abreviado em minúsculas).
  String get shortDate {
    const months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];

    return '$day ${months[month - 1]} $year';
  }
}
