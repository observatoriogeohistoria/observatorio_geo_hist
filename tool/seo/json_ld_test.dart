import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'json_ld.dart';

const _open = '<script type="application/ld+json">';
const _close = '</script>';

// Built from code units because the escape sequences are what the test is about.
final String _backslash = String.fromCharCode(0x5c);
final String _lineSeparator = String.fromCharCode(0x2028);
final String _paragraphSeparator = String.fromCharCode(0x2029);

String _bodyOf(String script) {
  expect(script, startsWith(_open));
  expect(script, endsWith(_close));
  return script.substring(_open.length, script.length - _close.length);
}

void main() {
  test('a title with a closing script tag cannot close the tag', () {
    final body = _bodyOf(jsonLdScript({'name': '</script><script>alert(1)</script>'}));

    expect(body, isNot(contains('</script>')));
    expect(body, isNot(contains('<script>')));
    expect(body, contains('${_backslash}u003c/script${_backslash}u003e'));
  });

  test('escapes the angle brackets and the ampersand as unicode escapes', () {
    final body = _bodyOf(jsonLdScript({'a': '<>&'}));

    expect(body, '{"a":"${_backslash}u003c${_backslash}u003e${_backslash}u0026"}');
  });

  test('escapes the line and paragraph separators', () {
    final body = _bodyOf(jsonLdScript({'a': '$_lineSeparator$_paragraphSeparator'}));

    expect(body, isNot(contains(_lineSeparator)));
    expect(body, isNot(contains(_paragraphSeparator)));
    expect(body, contains('${_backslash}u2028${_backslash}u2029'));
  });

  test('escaped output reads back as the original text', () {
    final name = 'A & B <i>"aspas"</i> $_lineSeparator $_paragraphSeparator emoji 😀 ação';
    final data = jsonDecode(
      _bodyOf(
        jsonLdScript({
          'name': name,
          'nested': {
            'list': ['<x>', 'y&z'],
          },
        }),
      ),
    ) as Map<String, dynamic>;

    expect(data['name'], name);
    expect((data['nested'] as Map)['list'], ['<x>', 'y&z']);
  });

  test('no raw <, > or & is left in the JSON', () {
    final body = _bodyOf(jsonLdScript({'a': '<>&', '<k>': 'v'}));

    expect(body, isNot(contains('<')));
    expect(body, isNot(contains('>')));
    expect(body, isNot(contains('&')));
  });
}
