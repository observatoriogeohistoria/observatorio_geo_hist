class MailDraft {
  const MailDraft({required this.to, required this.subject, required this.body});

  final String to;
  final String subject;
  final String body;

  // Built by hand: `Uri(queryParameters:)` turns spaces into `+`, which some mail apps show literally.
  String get mailtoUrl =>
      'mailto:$to?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

  String get copyText => 'Para: $to\nAssunto: $subject\n\n$body';
}
