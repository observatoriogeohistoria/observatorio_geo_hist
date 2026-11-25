import 'escape.dart';
import 'json_ld.dart';
import 'seo_exception.dart';
import 'site_pages.dart';
import 'structured_data.dart';

/// [page] applied to the build's `index.html`: title, description, canonical, Open Graph and
/// Twitter swapped, plus the JSON-LD and a text block for crawlers.
///
/// Throws if the template loses one of those tags: better to stop the deploy than to publish
/// pages that still carry the home's text.
String renderPage(
  SitePage page, {
  required String template,
  required String origin,
  bool noIndex = false,
}) {
  final meta = page.meta;
  final url = meta.canonicalUrl(origin);

  var html = template;
  html = _replace(html, RegExp(r'<title>[\s\S]*?</title>'),
      '<title>${escapeHtml(meta.title)}</title>', 'title');
  html = _setMeta(html, 'name', 'description', meta.description);
  html = _setMeta(html, 'property', 'og:title', meta.title);
  html = _setMeta(html, 'property', 'og:description', meta.description);
  html = _setMeta(html, 'property', 'og:url', url);
  html = _setMeta(html, 'name', 'twitter:title', meta.title);
  html = _setMeta(html, 'name', 'twitter:description', meta.description);
  html = _replace(
    html,
    RegExp(r'<link\s[^>]*?rel="canonical"[^>]*>'),
    '<link rel="canonical" href="${escapeHtml(url)}" />',
    'canonical',
  );

  final head = [
    if (noIndex) '<meta name="robots" content="noindex, nofollow" />',
    jsonLdScript(structuredData(page, origin: origin)),
  ].join('\n    ');
  html = _replace(html, RegExp(r'</head>'), '    $head\n  </head>', 'fim do head');
  html =
      _replace(html, RegExp(r'<body[^>]*>'), '<body>\n    ${_textBlock(page)}', 'início do body');
  return html;
}

String _setMeta(String html, String attribute, String key, String content) => _replace(
      html,
      RegExp('<meta\\s[^>]*?$attribute="${RegExp.escape(key)}"[^>]*>', dotAll: true),
      '<meta $attribute="$key" content="${escapeHtml(content)}" />',
      '$attribute="$key"',
    );

String _replace(String html, RegExp pattern, String replacement, String what) {
  if (!pattern.hasMatch(html)) {
    throw SeoException('O index.html do build não tem a tag "$what"; não vou gerar as páginas.');
  }
  return html.replaceFirstMapped(pattern, (_) => replacement);
}

// Off screen and inert, not display:none, so crawlers read it while people and screen readers
// never meet it. The app removes it on its first frame.
const _hiddenStyle =
    'position:absolute;left:-10000px;top:auto;width:1px;height:1px;overflow:hidden';

String _textBlock(SitePage page) {
  String link(PageLink item) => '<a href="${escapeHtml(item.route)}">${escapeHtml(item.title)}</a>';

  final buffer = StringBuffer()
    ..write('<div id="seo-content" aria-hidden="true" inert style="$_hiddenStyle">');
  if (page.breadcrumbs.length > 1) {
    buffer
        .write('<nav><ol>${page.breadcrumbs.map((c) => '<li>${link(c)}</li>').join()}</ol></nav>');
  }
  buffer.write('<article><h1>${escapeHtml(page.heading)}</h1>');
  for (final paragraph in page.paragraphs) {
    buffer.write('<p>${escapeHtml(paragraph)}</p>');
  }
  if (page.facts.isNotEmpty) {
    buffer.write('<dl>');
    for (final fact in page.facts) {
      buffer.write('<dt>${escapeHtml(fact.label)}</dt><dd>${escapeHtml(fact.value)}</dd>');
    }
    buffer.write('</dl>');
  }
  if (page.links.isNotEmpty) {
    buffer.write('<ul>${page.links.map((l) => '<li>${link(l)}</li>').join()}</ul>');
  }
  buffer.write('</article>');
  if (page.previous != null || page.next != null) {
    buffer.write('<nav>');
    if (page.previous != null) {
      buffer.write(link(PageLink('Página anterior', page.previous!)));
    }
    if (page.next != null) buffer.write(link(PageLink('Próxima página', page.next!)));
    buffer.write('</nav>');
  }
  buffer.write(
    "</div><script>window.addEventListener('flutter-first-frame',function(){"
    "var e=document.getElementById('seo-content');if(e)e.remove()})</script>",
  );
  return buffer.toString();
}
