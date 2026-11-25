import 'package:flutter_test/flutter_test.dart';

import 'firestore_rest.dart';
import 'rest_fixtures.dart';
import 'seo_exception.dart';

FirestoreRest _rest(JsonRequest request, {int pageSize = 300, int attempts = 3}) => FirestoreRest(
      projectId: 'p',
      apiKey: 'k',
      request: request,
      pageSize: pageSize,
      attempts: attempts,
      retryDelay: Duration.zero,
    );

void main() {
  test('decodeValue unwraps every Firestore type', () {
    expect(decodeValue({'stringValue': 'a'}), 'a');
    expect(decodeValue({'integerValue': '7'}), 7);
    expect(decodeValue({'doubleValue': 1.5}), 1.5);
    expect(decodeValue({'booleanValue': true}), true);
    expect(decodeValue({'nullValue': null}), isNull);
    expect(decodeValue({'timestampValue': '2026-01-01T00:00:00Z'}), '2026-01-01T00:00:00Z');
    expect(
        decodeValue(toValue([
          'a',
          1,
          {'k': 'v'}
        ])),
        [
          'a',
          1,
          {'k': 'v'}
        ]);
    expect(decodeValue({'arrayValue': <String, dynamic>{}}), isEmpty);
    expect(decodeValue({'mapValue': <String, dynamic>{}}), isEmpty);
  });

  test('listDocuments follows the page token and decodes the fields', () async {
    final docs = [
      for (var i = 0; i < 5; i++) rawDocument('library/d$i', {'n': i})
    ];
    final log = <Uri>[];
    final rest = _rest(
      fakeFirestore(collections: {'library': docs}, posts: {}, pageSize: 2, log: log),
      pageSize: 2,
    );

    final result = await rest.listDocuments('library');

    expect(result.map((d) => d.id), ['d0', 'd1', 'd2', 'd3', 'd4']);
    expect(result.last.fields['n'], 4);
    expect(result.first.path, 'library/d0');
    expect(log, hasLength(3));
  });

  test('publishedPosts pages by document name until a short page', () async {
    final docs = [
      for (var i = 0; i < 5; i++) rawDocument('posts/9/category_posts/p$i', {'n': i}),
    ];
    final log = <Uri>[];
    final rest = _rest(
      fakeFirestore(collections: {}, posts: {'9': docs}, pageSize: 2, log: log),
      pageSize: 2,
    );

    final result = await rest.publishedPosts('9');

    expect(result.map((d) => d.id), ['p0', 'p1', 'p2', 'p3', 'p4']);
    expect(log.every((u) => u.path.endsWith('posts/9:runQuery')), isTrue);
  });

  test('publishedPosts with no results is an empty list', () async {
    final rest = _rest(fakeFirestore(collections: {}, posts: {}));

    expect(await rest.publishedPosts('9'), isEmpty);
  });

  test('retries and then succeeds', () async {
    var calls = 0;
    final rest = _rest((uri, {body}) async {
      if (++calls < 3) throw Exception('rede');
      return <String, dynamic>{};
    });

    expect(await rest.listDocuments('team'), isEmpty);
    expect(calls, 3);
  });

  test('fails with a message in Portuguese after the last attempt', () async {
    var calls = 0;
    final rest = _rest((uri, {body}) async {
      calls++;
      throw Exception('sem rede');
    });

    await expectLater(
      rest.listDocuments('library'),
      throwsA(
        isA<SeoException>()
            .having((e) => e.message, 'message', contains('Não foi possível ler "library"')),
      ),
    );
    expect(calls, 3);
  });
}
