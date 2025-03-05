class Validators {
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

  static String? isValidRole(String? role) {
    if (role == null || role.isEmpty) return 'Por favor, selecione um papel';
    return null;
  }
}
