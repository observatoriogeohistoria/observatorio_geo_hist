import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:observatorio_geo_hist/app/core/utils/browser/page_meta_data.dart';

import 'html_page.dart';
import 'seo_exception.dart';
import 'site_pages.dart';

const _origin = 'https://x.test';

// The real template, so a tag removed from web/index.html fails here before it fails a deploy.
final String _template = File('web/index.html').readAsStringSync();

SitePage _page({
  String title = 'Livros | Observatório',
  String description = 'Descrição',
  String path = '/contato',
  String heading = 'Livros',
  List<String> paragraphs = const ['Texto'],
  List<PageLink> links = const [],
  String? next,
}) =>
    SitePage(
      kind: PageKind.fixed,
      meta: PageMeta(title: title, description: description, path: path),
      heading: heading,
      paragraphs: paragraphs,
      links: links,
      next: next,
    );

void main() {
  test('swaps the title, description, canonical, Open Graph and Twitter tags', () {
    final html = renderPage(_page(), template: _template, origin: _origin);

    expect(html, contains('<title>Livros | Observatório</title>'));
    expect(html, contains('<meta name="description" content="Descrição" />'));
    expect(html, contains('<meta property="og:title" content="Livros | Observatório" />'));
    expect(html, contains('<meta property="og:description" content="Descrição" />'));
    expect(html, contains('<meta property="og:url" content="https://x.test/contato" />'));
    expect(html, contains('<meta name="twitter:title" content="Livros | Observatório" />'));
    expect(html, contains('<meta name="twitter:description" content="Descrição" />'));
    expect(html, contains('<link rel="canonical" href="https://x.test/contato" />'));
    expect(html, isNot(contains('Faculdade de Educação da UFU.')));
    expect(RegExp('<link rel="canonical"').allMatches(html), hasLength(1));
  });

  test('escapes the text that goes into attributes and tags, and keeps dollar signs', () {
    final html = renderPage(
      _page(title: r'A & <b>"B"</b> $1 \1', description: 'x"><script>alert(1)</script>'),
      template: _template,
      origin: _origin,
    );

    expect(html, contains(r'<title>A &amp; &lt;b&gt;&quot;B&quot;&lt;/b&gt; $1 \1</title>'));
    expect(html, isNot(contains('<script>alert(1)')));
    expect(html, contains('x&quot;&gt;&lt;script&gt;alert(1)&lt;/script&gt;'));
  });

  test('puts valid JSON-LD that cannot close its tag in the head', () {
    final html = renderPage(
      _page(heading: '</script><script>alert(1)</script>'),
      template: _template,
      origin: _origin,
    );

    final match = RegExp(
      r'<script type="application/ld\+json">(.*?)</script>',
      dotAll: true,
    ).firstMatch(html)!;
    final data = jsonDecode(match.group(1)!) as Map<String, dynamic>;

    expect(data['@context'], 'https://schema.org');
    expect(jsonEncode(data), contains('</script><script>alert(1)</script>'));
    expect(match.group(1), isNot(contains('<')));
    expect(html.indexOf('application/ld+json'), lessThan(html.indexOf('</head>')));
  });

  test('adds noindex only when asked', () {
    expect(renderPage(_page(), template: _template, origin: _origin), isNot(contains('noindex')));
    expect(
      renderPage(_page(), template: _template, origin: _origin, noIndex: true),
      contains('<meta name="robots" content="noindex, nofollow" />'),
    );
  });

  test('the text block is hidden from people and escaped, and the app removes it', () {
    final html = renderPage(
      _page(
        paragraphs: ['Um <b>parágrafo</b> & mais'],
        links: [const PageLink('Item <1>', '/publicacoes/historia/9/p1')],
        next: '/contato/pagina/2',
      ),
      template: _template,
      origin: _origin,
    );

    expect(html, contains('id="seo-content" aria-hidden="true" inert'));
    expect(html, contains('left:-10000px'));
    expect(html, isNot(contains('display:none')));
    expect(html, contains('<p>Um &lt;b&gt;parágrafo&lt;/b&gt; &amp; mais</p>'));
    expect(html, contains('<a href="/publicacoes/historia/9/p1">Item &lt;1&gt;</a>'));
    expect(html, contains('<a href="/contato/pagina/2">Próxima página</a>'));
    expect(html, contains('flutter-first-frame'));
    expect(html.indexOf('seo-content'), greaterThan(html.indexOf('<body>')));
  });

  for (final tag in [
    '<title>',
    'name="description"',
    'property="og:title"',
    'property="og:url"',
    'rel="canonical"',
    '</head>',
    '<body>',
  ]) {
    test('fails when the template has no $tag', () {
      final broken = _template.replaceAll(tag, 'REMOVED');

      expect(
        () => renderPage(_page(), template: broken, origin: _origin),
        throwsA(isA<SeoException>()),
      );
    });
  }
}
