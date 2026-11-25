import 'escape.dart';

class SitemapEntry {
  const SitemapEntry({required this.url, this.lastModified});

  final String url;
  final DateTime? lastModified;
}

String buildSitemap(List<SitemapEntry> entries) {
  final buffer = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8"?>')
    ..writeln('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');
  for (final entry in entries) {
    buffer.writeln('  <url>');
    buffer.writeln('    <loc>${escapeXml(entry.url)}</loc>');
    final modified = entry.lastModified;
    if (modified != null) buffer.writeln('    <lastmod>${_isoDay(modified)}</lastmod>');
    buffer.writeln('  </url>');
  }
  buffer.writeln('</urlset>');
  return buffer.toString();
}

String _isoDay(DateTime date) {
  final utc = date.toUtc();
  final month = utc.month.toString().padLeft(2, '0');
  final day = utc.day.toString().padLeft(2, '0');
  return '${utc.year.toString().padLeft(4, '0')}-$month-$day';
}
