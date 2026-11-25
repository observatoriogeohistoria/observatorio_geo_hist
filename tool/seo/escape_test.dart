import 'package:flutter_test/flutter_test.dart';

import 'escape.dart';

void main() {
  test('escapeHtml escapes the five characters that break markup', () {
    expect(escapeHtml('<a href="x">Tom & \'Jerry\'</a>'),
        '&lt;a href=&quot;x&quot;&gt;Tom &amp; &#39;Jerry&#39;&lt;/a&gt;');
  });

  test('escapeHtml escapes the ampersand first, so nothing is escaped twice', () {
    expect(escapeHtml('&lt;'), '&amp;lt;');
  });

  test('escapeXml escapes the five characters that break XML', () {
    expect(escapeXml('a&b<c>"d\'e'), 'a&amp;b&lt;c&gt;&quot;d&apos;e');
  });

  test('plain text passes through, accents included', () {
    expect(escapeHtml('Ensino de História'), 'Ensino de História');
    expect(escapeXml('Ensino de História'), 'Ensino de História');
  });
}
