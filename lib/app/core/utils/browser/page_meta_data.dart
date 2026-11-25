const String siteOrigin = 'https://observatoriogeohistoria.net.br';

const String siteName = 'Observatório do Ensino de História e Geografia';

class PageMeta {
  const PageMeta({
    required this.title,
    required this.description,
    required this.path,
    this.noIndex = false,
  });

  final String title;
  final String description;

  /// Route path, like `/contato` (the home is `/`).
  final String path;

  final bool noIndex;

  /// No trailing slash, so one page never has two canonical addresses.
  String canonicalUrl(String origin) {
    final clean = path.length > 1 && path.endsWith('/') ? path.substring(0, path.length - 1) : path;
    return clean == '/' ? '$origin/' : '$origin$clean';
  }
}

/// One line, cut at a whole word with an ellipsis; search engines show about 160 characters.
String summarize(String text, {int max = 155}) {
  final flat = text.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (flat.length <= max) return flat;
  final cut = flat.substring(0, max - 1);
  final space = cut.lastIndexOf(' ');
  final base = space > max ~/ 2 ? cut.substring(0, space) : cut;
  return '${base.replaceAll(RegExp(r'[\s.,;:]+$'), '')}…';
}
