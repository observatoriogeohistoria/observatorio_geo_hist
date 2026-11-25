/// Failure that must stop the deploy; the message is shown as is in the workflow log.
class SeoException implements Exception {
  const SeoException(this.message);

  final String message;

  @override
  String toString() => message;
}
