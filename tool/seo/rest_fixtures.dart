import 'firestore_rest.dart';

/// Plain JSON as a Firestore REST value, the reverse of `decodeValue`.
Map<String, dynamic> toValue(Object? value) {
  if (value == null) return {'nullValue': null};
  if (value is bool) return {'booleanValue': value};
  if (value is int) return {'integerValue': '$value'};
  if (value is double) return {'doubleValue': value};
  if (value is String) return {'stringValue': value};
  if (value is List) {
    return {
      'arrayValue': {'values': value.map(toValue).toList()},
    };
  }
  final map = value as Map<String, dynamic>;
  return {
    'mapValue': {
      'fields': {for (final e in map.entries) e.key: toValue(e.value)},
    },
  };
}

Map<String, dynamic> rawDocument(String path, Map<String, dynamic> fields) => {
      'name': 'projects/p/databases/(default)/documents/$path',
      'fields': {for (final e in fields.entries) e.key: toValue(e.value)},
    };

Map<String, dynamic> categoryFields({List<String> areas = const ['historia']}) => {
      'title': 'Livros',
      'description': 'Sobre livros',
      'areas': areas,
      'backgroundImgUrl': 'https://x.test/bg.png',
      'hasCollaborateOption': false,
    };

Map<String, dynamic> articleFields({
  required String id,
  List<String> areas = const ['historia'],
  String title = 'Um artigo',
  String? updatedAt,
}) =>
    {
      'id': id,
      'type': 'article',
      'areas': areas,
      'isPublished': true,
      'isHighlighted': false,
      'createdAt': '2026-01-02T03:04:05.000Z',
      if (updatedAt != null) 'updatedAt': updatedAt,
      'body': {
        'title': title,
        'image': 'https://x.test/a.png',
        'subtitle': 'Subtítulo',
        'authors': ['Ana'],
        'date': '2026',
        'imageCaption': '',
        'content': 'Texto do artigo',
        'observation': '',
      },
    };

Map<String, dynamic> libraryFields({String title = 'Uma tese'}) => {
      'area': 'História',
      'title': title,
      'author': 'Ana',
      'type': 'Tese',
      'category': ['Avaliação'],
      'institution': 'UFU',
      'year': 2020,
      'createdAt': '2026-03-04T00:00:00.000Z',
      'status': null,
    };

/// Answers REST calls from [documents] keyed by collection path, paging like Firestore does.
JsonRequest fakeFirestore({
  required Map<String, List<Map<String, dynamic>>> collections,
  required Map<String, List<Map<String, dynamic>>> posts,
  int pageSize = 300,
  List<Uri>? log,
}) {
  return (Uri uri, {Object? body}) async {
    log?.add(uri);
    final path = uri.path.split('/documents/').last;
    if (body != null) {
      final category = path.replaceAll(':runQuery', '').split('/').last;
      final all = posts[category] ?? const [];
      final start = (body as Map)['structuredQuery']['startAt'];
      final after = start == null ? null : start['values'][0]['referenceValue'] as String;
      final rest = after == null
          ? all
          : all.where((d) => (d['name'] as String).compareTo(after) > 0).toList();
      final page = rest.take(pageSize).toList();
      return page.isEmpty
          ? [<String, dynamic>{}]
          : [
              for (final d in page) {'document': d}
            ];
    }
    final all = collections[path] ?? const [];
    final from = int.tryParse(uri.queryParameters['pageToken'] ?? '') ?? 0;
    final page = all.skip(from).take(pageSize).toList();
    final next = from + page.length;
    return {
      if (page.isNotEmpty) 'documents': page,
      if (next < all.length) 'nextPageToken': '$next',
    };
  };
}
