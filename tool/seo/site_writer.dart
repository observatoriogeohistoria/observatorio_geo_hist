import 'dart:io';

import 'html_page.dart';
import 'seo_exception.dart';
import 'site_pages.dart';
import 'sitemap.dart';

// Firestore ids are mixed case, so upper case has to pass; dots and slashes never do.
final RegExp _segment = RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]*$');

/// The file for [route] under [outDir] (`/sobre` is `sobre.html`; the home is `index.html`).
///
/// Refuses anything that could land outside [outDir] or on top of a file of the build.
File fileForRoute(Directory outDir, String route) {
  if (route == '/') return File('${outDir.path}/index.html');

  final segments = route.startsWith('/') ? route.substring(1).split('/') : const <String>[];
  if (segments.isEmpty || !segments.every(_segment.hasMatch)) {
    throw SeoException('Endereço fora do padrão, não vou gravar a página: "$route"');
  }
  final file = File('${outDir.path}/${segments.join('/')}.html');
  if (file.existsSync()) {
    throw SeoException(
      'Já existe um arquivo do build em ${file.path}; não vou sobrescrevê-lo. '
      'Se é uma execução repetida, rode `flutter build web` de novo.',
    );
  }
  return file;
}

class SiteWriteResult {
  const SiteWriteResult({required this.pagesByKind, required this.sitemap});

  final Map<PageKind, int> pagesByKind;
  final bool sitemap;

  int get pages => pagesByKind.values.fold(0, (sum, count) => sum + count);
}

/// Writes one HTML file per page into [outDir] and, if asked, the `sitemap.xml`. Every page is
/// rendered and every path checked before the first file is written.
SiteWriteResult writeSite({
  required List<SitePage> pages,
  required String template,
  required Directory outDir,
  required String origin,
  required bool noIndex,
  required bool withSitemap,
}) {
  final files = [
    for (final page in pages)
      (
        file: fileForRoute(outDir, page.route),
        html: renderPage(page, template: template, origin: origin, noIndex: noIndex),
      ),
  ];

  for (final entry in files) {
    entry.file
      ..createSync(recursive: true)
      ..writeAsStringSync(entry.html);
  }

  if (withSitemap) {
    final sitemap = buildSitemap([
      for (final page in pages)
        SitemapEntry(url: page.meta.canonicalUrl(origin), lastModified: page.lastModified),
    ]);
    File('${outDir.path}/sitemap.xml').writeAsStringSync(sitemap);
  }

  final byKind = <PageKind, int>{};
  for (final page in pages) {
    byKind[page.kind] = (byKind[page.kind] ?? 0) + 1;
  }
  return SiteWriteResult(pagesByKind: byKind, sitemap: withSitemap);
}
