import 'package:flutter_test/flutter_test.dart';

import 'sitemap.dart';

void main() {
  test('writes loc and lastmod as a day, in UTC', () {
    final xml = buildSitemap([
      SitemapEntry(url: 'https://x.test/a', lastModified: DateTime.utc(2026, 3, 5, 23, 59)),
    ]);

    expect(xml, startsWith('<?xml version="1.0" encoding="UTF-8"?>'));
    expect(xml, contains('<loc>https://x.test/a</loc>'));
    expect(xml, contains('<lastmod>2026-03-05</lastmod>'));
  });

  test('an entry without date has no lastmod', () {
    final xml = buildSitemap([const SitemapEntry(url: 'https://x.test/b')]);

    expect(xml, contains('<loc>https://x.test/b</loc>'));
    expect(xml, isNot(contains('lastmod')));
  });

  test('escapes the url', () {
    final xml = buildSitemap([const SitemapEntry(url: 'https://x.test/?a=1&b=<2>')]);

    expect(xml, contains('<loc>https://x.test/?a=1&amp;b=&lt;2&gt;</loc>'));
  });
}
