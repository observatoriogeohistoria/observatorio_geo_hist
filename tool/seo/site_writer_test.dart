import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'catalog_fixtures.dart';
import 'seo_exception.dart';
import 'site_pages.dart';
import 'site_writer.dart';

void main() {
  late Directory out;

  setUp(() => out = Directory.systemTemp.createTempSync('seo_writer_'));
  tearDown(() => out.deleteSync(recursive: true));

  test('maps a route to its html file', () {
    expect(fileForRoute(out, '/contato').path, '${out.path}/contato.html');
    expect(
      fileForRoute(out, '/publicacoes/historia/livros/abc').path,
      '${out.path}/publicacoes/historia/livros/abc.html',
    );
  });

  test('the home is index.html and may replace the build copy', () {
    File('${out.path}/index.html').writeAsStringSync('build');

    expect(fileForRoute(out, '/').path, '${out.path}/index.html');
  });

  test('accepts mixed case ids and underscores', () {
    expect(
      fileForRoute(out, '/biblioteca/historia/documento/01fHxrdfgypsoKmIy79T').path,
      endsWith('/documento/01fHxrdfgypsoKmIy79T.html'),
    );
    expect(fileForRoute(out, '/a/b_c-d').path, endsWith('/a/b_c-d.html'));
  });

  for (final route in [
    '',
    'contato',
    '/contato/',
    '/a//b',
    '/../fora',
    '/a/../b',
    '/a/./b',
    '/a b',
    '/a.html',
    '/.htaccess',
    '/-a',
    '/_a',
    r'/a\b',
    '/a?x=1',
    '/ação',
  ]) {
    test('refuses "$route"', () {
      expect(() => fileForRoute(out, route), throwsA(isA<SeoException>()));
    });
  }

  test('refuses to overwrite a file of the build', () {
    File('${out.path}/manifest.html').writeAsStringSync('build');

    expect(() => fileForRoute(out, '/manifest'), throwsA(isA<SeoException>()));
  });

  group('writeSite', () {
    final template = File('web/index.html').readAsStringSync();

    Future<SiteWriteResult> write({required bool prod}) async => writeSite(
          pages: buildSitePages(await fakeCatalog(postCount: 2, documentCount: 2)),
          template: template,
          outDir: out,
          origin: 'https://x.test',
          noIndex: !prod,
          withSitemap: prod,
        );

    test('production writes every page and a sitemap, without noindex', () async {
      File('${out.path}/index.html').writeAsStringSync(template);

      final result = await write(prod: true);

      expect(result.sitemap, isTrue);
      expect(result.pages, greaterThan(10));
      expect(File('${out.path}/contato.html').existsSync(), isTrue);
      expect(File('${out.path}/publicacoes/historia/9/p000.html').existsSync(), isTrue);
      expect(File('${out.path}/sitemap.xml').readAsStringSync(),
          contains('<loc>https://x.test/contato</loc>'));
      expect(File('${out.path}/contato.html').readAsStringSync(), isNot(contains('noindex')));
      expect(File('${out.path}/index.html').readAsStringSync(), contains('id="seo-content"'));
    });

    test('dev writes noindex and no sitemap', () async {
      File('${out.path}/index.html').writeAsStringSync(template);

      final result = await write(prod: false);

      expect(result.sitemap, isFalse);
      expect(File('${out.path}/sitemap.xml').existsSync(), isFalse);
      expect(File('${out.path}/contato.html').readAsStringSync(), contains('noindex, nofollow'));
    });

    test('the sitemap lastmod comes from updatedAt for posts and createdAt for documents',
        () async {
      await write(prod: true);
      final sitemap = File('${out.path}/sitemap.xml').readAsStringSync();

      String lastmodOf(String path) =>
          RegExp('<loc>https://x.test$path</loc>\\s*<lastmod>([^<]*)</lastmod>')
              .firstMatch(sitemap)!
              .group(1)!;

      expect(lastmodOf('/publicacoes/historia/9/p000'), '2026-01-02');
      expect(lastmodOf('/biblioteca/historia/documento/Doc0'), '2026-01-01');
      expect(sitemap, isNot(contains('<loc>https://x.test/contato</loc>\n    <lastmod>')));
    });

    test('nothing is written when one path is refused', () async {
      File('${out.path}/publicacoes.html').writeAsStringSync('build');

      await expectLater(write(prod: true), throwsA(isA<SeoException>()));

      expect(File('${out.path}/contato.html').existsSync(), isFalse);
    });
  });
}
