import 'package:flutter_test/flutter_test.dart';

import 'catalog_reader.dart';
import 'firestore_rest.dart';
import 'rest_fixtures.dart';
import 'seo_exception.dart';

CatalogReader _reader({
  List<Map<String, dynamic>>? categories,
  Map<String, List<Map<String, dynamic>>>? posts,
  List<Map<String, dynamic>>? library,
  List<Map<String, dynamic>>? team,
}) {
  return CatalogReader(
    FirestoreRest(
      projectId: 'p',
      apiKey: 'k',
      retryDelay: Duration.zero,
      request: fakeFirestore(
        collections: {
          'posts': categories ?? [rawDocument('posts/9', categoryFields())],
          'library': library ?? [rawDocument('library/Ab1', libraryFields())],
          'team': team ?? const [],
        },
        posts: posts ??
            {
              '9': [rawDocument('posts/9/category_posts/p1', articleFields(id: 'p1'))],
            },
      ),
    ),
  );
}

void main() {
  test('reads categories, posts, library and team into the app models', () async {
    final catalog = await _reader(
      team: [
        rawDocument('team/m1', {
          'name': 'Bia',
          'role': 'Bolsista',
          'description': 'Texto',
          'lattesUrl': 'https://x.test/l',
          'image': 'https://x.test/i.png',
        }),
      ],
    ).read();

    expect(catalog.categories.single.key, '9');
    expect(catalog.posts.single.id, 'p1');
    expect(catalog.posts.single.categoryId, '9');
    expect(catalog.documents.single.id, 'Ab1');
    expect(catalog.members.single.id, 'm1');
    expect(catalog.warnings, isEmpty);
  });

  test('the library document id is the Firestore document id', () async {
    final catalog = await _reader(
      library: [
        rawDocument('library/Real', {...libraryFields(), 'id': 'outro'})
      ],
    ).read();

    expect(catalog.documents.single.id, 'Real');
  });

  test('a post whose first area is not in the category is left out and reported', () async {
    final catalog = await _reader(
      posts: {
        '9': [
          rawDocument('posts/9/category_posts/p1', articleFields(id: 'p1')),
          rawDocument('posts/9/category_posts/p2', articleFields(id: 'p2', areas: ['geografia'])),
        ],
      },
    ).read();

    expect(catalog.posts.map((p) => p.id), ['p1']);
    expect(catalog.warnings.single, contains('p2'));
  });

  test('a member with incomplete data is left out and reported', () async {
    final catalog = await _reader(team: [
      rawDocument('team/m1', {'name': 'Bia'})
    ]).read();

    expect(catalog.members, isEmpty);
    expect(catalog.warnings.single, contains('m1'));
  });

  test('fails without categories', () {
    expect(_reader(categories: []).read(), throwsA(isA<SeoException>()));
  });

  test('fails without published posts', () {
    expect(_reader(posts: {}).read(), throwsA(isA<SeoException>()));
  });

  test('fails with an empty library', () {
    final reader = CatalogReader(
      FirestoreRest(
        projectId: 'p',
        apiKey: 'k',
        retryDelay: Duration.zero,
        request: fakeFirestore(
          collections: {
            'posts': [rawDocument('posts/9', categoryFields())],
          },
          posts: {
            '9': [rawDocument('posts/9/category_posts/p1', articleFields(id: 'p1'))],
          },
        ),
      ),
    );

    expect(reader.read(), throwsA(isA<SeoException>()));
  });

  test('a post that does not convert stops the run and names the document', () async {
    final reader = _reader(
      posts: {
        '9': [
          rawDocument('posts/9/category_posts/bad', {'type': 'article'})
        ],
      },
    );

    await expectLater(
      reader.read(),
      throwsA(isA<SeoException>()
          .having((e) => e.message, 'message', contains('posts/9/category_posts/bad'))),
    );
  });
}
