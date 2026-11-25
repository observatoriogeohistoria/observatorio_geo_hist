import 'catalog_reader.dart';
import 'firestore_rest.dart';
import 'rest_fixtures.dart';

/// A catalog read through the fake REST, with [postCount] articles in category `9` and
/// [documentCount] history documents.
Future<SeoCatalog> fakeCatalog({
  int postCount = 3,
  int documentCount = 3,
  List<Map<String, dynamic>>? team,
  List<String> categoryAreas = const ['historia'],
}) {
  String day(int i) => '2026-01-${(i % 28 + 1).toString().padLeft(2, '0')}T00:00:00.000Z';
  final posts = [
    for (var i = 0; i < postCount; i++)
      rawDocument('posts/9/category_posts/p${i.toString().padLeft(3, '0')}', {
        ...articleFields(id: 'p${i.toString().padLeft(3, '0')}', title: 'Artigo $i'),
        'createdAt': day(i),
        'updatedAt': day(i + 1),
      }),
  ];
  final documents = [
    for (var i = 0; i < documentCount; i++)
      rawDocument('library/Doc$i', {
        ...libraryFields(title: 'Tese $i'),
        'createdAt': day(i),
      }),
  ];
  return CatalogReader(
    FirestoreRest(
      projectId: 'p',
      apiKey: 'k',
      retryDelay: Duration.zero,
      request: fakeFirestore(
        collections: {
          'posts': [rawDocument('posts/9', categoryFields(areas: categoryAreas))],
          'library': documents,
          'team': team ?? const [],
        },
        posts: {'9': posts},
      ),
    ),
  ).read();
}
