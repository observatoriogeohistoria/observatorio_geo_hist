typedef FormValidator = String? Function(String? value);

/// Rules for the site's forms. Leading and trailing spaces don't count.
class FormValidators {
  const FormValidators._();

  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static FormValidator required(String message) {
    return (value) => (value ?? '').trim().isEmpty ? message : null;
  }

  static FormValidator email(String message) {
    return (value) => _email.hasMatch((value ?? '').trim()) ? null : message;
  }

  static FormValidator minLength(int length, String message) {
    return (value) => (value ?? '').trim().length < length ? message : null;
  }
}
