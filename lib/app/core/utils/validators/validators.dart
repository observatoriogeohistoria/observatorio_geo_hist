class Validators {
  static String? isNotEmpty(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, o campo não pode ser vazio';
    return null;
  }

  static String? isValidEmail(String? email) {
    if (email == null || email.isEmpty) return 'Por favor, insira um e-mail';

    final hasMatch = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
    return hasMatch ? null : 'E-mail inválido';
  }

  static String? isValidPassword(String? password) {
    if (password == null || password.isEmpty) return 'Por favor, insira uma senha';

    final hasMatch =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(password);
    return hasMatch ? null : 'Senha inválida';
  }

  static String? isValidMonthAndYear(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira um mês e um ano';

    final hasMatch = RegExp(r'^\d{2}/\d{4}$').hasMatch(value);
    if (!hasMatch) return 'Formato inválido (MM/yyyy)';

    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) return 'Mês inválido';
    if (year == null) return 'Ano inválido';

    return null;
  }
}
