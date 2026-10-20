/// Mesmas regras de `Validators`, que não ignoram espaços nas pontas como as do site; só as
/// mensagens são outras.
class PanelValidators {
  const PanelValidators._();

  static const requiredMessage = 'Preencha este campo.';

  static final _email = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  static final _password = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static final _url = RegExp(r'^https?://');

  static String? required(String? value) => value == null || value.isEmpty ? requiredMessage : null;

  static String? email(String? value) {
    if (value == null || value.isEmpty) return requiredMessage;
    return _email.hasMatch(value) ? null : 'Informe um e-mail válido.';
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return requiredMessage;
    return _password.hasMatch(value) ? null : 'Senha inválida';
  }

  static String? urlOrEmpty(String? value) {
    if (value == null || value.isEmpty) return null;
    return _url.hasMatch(value) ? null : 'URL inválida';
  }

  /// Para escolhas obrigatórias (tipo, papel, categorias), que não têm texto a validar.
  static String? Function(T?) choice<T>(String message) {
    return (value) {
      if (value == null) return message;
      if (value is Iterable && value.isEmpty) return message;
      return null;
    };
  }
}
