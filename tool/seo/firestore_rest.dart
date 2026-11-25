import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'seo_exception.dart';

/// Sends a GET (no [body]) or a POST with a JSON [body] and returns the decoded response.
typedef JsonRequest = Future<Object?> Function(Uri uri, {Object? body});

class RestDocument {
  const RestDocument({required this.id, required this.path, required this.fields});

  final String id;

  /// Relative to the database root, like `posts/123/category_posts/abc`.
  final String path;

  /// Plain JSON, with the Firestore value wrappers already removed.
  final Map<String, dynamic> fields;
}

/// Reads Firestore through the public REST API, with no credential beyond the web API key.
class FirestoreRest {
  FirestoreRest({
    required this.projectId,
    required this.apiKey,
    JsonRequest? request,
    this.attempts = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.pageSize = 300,
  }) : _request = request ?? _httpRequest;

  final String projectId;
  final String apiKey;
  final int attempts;
  final Duration retryDelay;
  final int pageSize;
  final JsonRequest _request;

  String get _root => '/v1/projects/$projectId/databases/(default)/documents';

  Future<List<RestDocument>> listDocuments(String collection) async {
    final documents = <RestDocument>[];
    String? token;
    do {
      final uri = Uri.https('firestore.googleapis.com', '$_root/$collection', {
        'pageSize': '$pageSize',
        'key': apiKey,
        if (token != null) 'pageToken': token,
      });
      final page = await _withRetries(() => _request(uri), collection);
      if (page is! Map<String, dynamic>) {
        throw SeoException('Resposta inesperada ao listar "$collection" em $projectId.');
      }
      for (final raw in (page['documents'] as List?) ?? const []) {
        documents.add(_documentFrom(raw as Map<String, dynamic>));
      }
      token = page['nextPageToken'] as String?;
    } while (token != null && token.isNotEmpty);
    return documents;
  }

  /// The published posts of one category. Filters on `isPublished` only and pages by document
  /// name: adding an order on another field would ask for a composite index.
  Future<List<RestDocument>> publishedPosts(String categoryId) async {
    final uri = Uri.https('firestore.googleapis.com', '$_root/posts/$categoryId:runQuery', {
      'key': apiKey,
    });
    final documents = <RestDocument>[];
    String? after;
    while (true) {
      final query = {
        'structuredQuery': {
          'from': [
            {'collectionId': 'category_posts'},
          ],
          'where': {
            'fieldFilter': {
              'field': {'fieldPath': 'isPublished'},
              'op': 'EQUAL',
              'value': {'booleanValue': true},
            },
          },
          'orderBy': [
            {
              'field': {'fieldPath': '__name__'},
              'direction': 'ASCENDING',
            },
          ],
          'limit': pageSize,
          if (after != null)
            'startAt': {
              'values': [
                {'referenceValue': after},
              ],
              'before': false,
            },
        },
      };
      final response = await _withRetries(
        () => _request(uri, body: query),
        'posts/$categoryId',
      );
      if (response is! List) {
        throw SeoException('Resposta inesperada à consulta de posts de "$categoryId".');
      }
      final page = [
        for (final item in response)
          if (item is Map<String, dynamic> && item['document'] != null)
            item['document'] as Map<String, dynamic>,
      ];
      documents.addAll(page.map(_documentFrom));
      if (page.length < pageSize) return documents;
      after = page.last['name'] as String;
    }
  }

  RestDocument _documentFrom(Map<String, dynamic> raw) {
    final name = raw['name'] as String;
    const marker = '/documents/';
    final path = name.substring(name.indexOf(marker) + marker.length);
    final fields = (raw['fields'] as Map<String, dynamic>?) ?? const {};
    return RestDocument(
      id: path.split('/').last,
      path: path,
      fields: {for (final entry in fields.entries) entry.key: decodeValue(entry.value)},
    );
  }

  Future<T> _withRetries<T>(Future<T> Function() action, String what) async {
    Object? last;
    for (var attempt = 1; attempt <= attempts; attempt++) {
      try {
        return await action();
      } catch (error) {
        last = error;
        if (attempt < attempts) await Future<void>.delayed(retryDelay);
      }
    }
    throw SeoException('Não foi possível ler "$what" do Firestore de $projectId: $last');
  }

  static Future<Object?> _httpRequest(Uri uri, {Object? body}) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 20);
    try {
      final request = body == null ? await client.getUrl(uri) : await client.postUrl(uri);
      if (body != null) {
        request.headers.contentType = ContentType.json;
        request.add(utf8.encode(jsonEncode(body)));
      }
      final response = await request.close().timeout(const Duration(seconds: 60));
      final text = await utf8.decodeStream(response);
      if (response.statusCode != 200) {
        throw HttpException('HTTP ${response.statusCode}', uri: uri.replace(query: ''));
      }
      return jsonDecode(text);
    } finally {
      client.close(force: true);
    }
  }
}

/// A Firestore REST value (`{"stringValue": "x"}`) as plain JSON.
Object? decodeValue(Object? value) {
  if (value is! Map<String, dynamic> || value.isEmpty) return null;
  final entry = value.entries.first;
  switch (entry.key) {
    case 'nullValue':
      return null;
    case 'integerValue':
      return int.parse(entry.value as String);
    case 'arrayValue':
      final values = (entry.value as Map<String, dynamic>)['values'] as List? ?? const [];
      return [for (final item in values) decodeValue(item)];
    case 'mapValue':
      final fields = (entry.value as Map<String, dynamic>)['fields'] as Map<String, dynamic>?;
      return {for (final e in (fields ?? const {}).entries) e.key: decodeValue(e.value)};
    default:
      // string, boolean, double, timestamp, reference and geo point already come as JSON.
      return entry.value;
  }
}
