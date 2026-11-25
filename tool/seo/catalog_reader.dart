import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';

import 'firestore_rest.dart';
import 'seo_exception.dart';

class SeoCatalog {
  const SeoCatalog({
    required this.categories,
    required this.posts,
    required this.documents,
    required this.members,
    this.warnings = const [],
  });

  final List<CategoryModel> categories;
  final List<PostModel> posts;
  final List<LibraryDocumentModel> documents;
  final List<TeamMemberModel> members;

  /// Items left out on purpose; the run prints them so nobody wonders where a page went.
  final List<String> warnings;

  SeoCatalog copyWithPosts(List<PostModel> posts) => SeoCatalog(
        categories: categories,
        posts: posts,
        documents: documents,
        members: members,
        warnings: warnings,
      );
}

/// Reads everything the public pages need. Fails instead of returning a thinner site: an empty
/// collection or an item that does not convert would otherwise ship as missing pages.
class CatalogReader {
  CatalogReader(this._rest);

  final FirestoreRest _rest;

  Future<SeoCatalog> read() async {
    final warnings = <String>[];

    final categoryDocs = await _rest.listDocuments('posts');
    if (categoryDocs.isEmpty) throw const SeoException('O Firestore não tem nenhuma categoria.');
    final categories = [
      for (final doc in categoryDocs)
        _convert('categoria', doc, () => CategoryModel.fromJson({...doc.fields, 'key': doc.id})),
    ];

    final posts = <PostModel>[];
    for (final category in categories) {
      for (final doc in await _rest.publishedPosts(category.key)) {
        final post = _convert(
          'post',
          doc,
          () => PostModel.fromJson({
            ...doc.fields,
            'id': doc.fields['id'] ?? doc.id,
            'categoryId': doc.fields['categoryId'] ?? category.key,
          }),
        );
        final area = post.areas.isEmpty ? null : post.areas.first;
        if (area == null || !category.areas.contains(area)) {
          warnings.add('Post ${category.key}/${post.id} sem página: área fora da categoria.');
          continue;
        }
        posts.add(post);
      }
    }
    if (posts.isEmpty) throw const SeoException('O Firestore não tem nenhum post publicado.');

    final documents = [
      for (final doc in await _rest.listDocuments('library'))
        _convert(
          'documento da biblioteca',
          doc,
          () => LibraryDocumentModel.fromJson({...doc.fields, 'id': doc.id}),
        ),
    ];
    if (documents.isEmpty) throw const SeoException('A biblioteca do Firestore está vazia.');

    final members = <TeamMemberModel>[];
    for (final doc in await _rest.listDocuments('team')) {
      try {
        members.add(TeamMemberModel.fromJson({...doc.fields, 'id': doc.id}));
      } catch (_) {
        // The Home can't show this member either, so it has no page to publish.
        warnings.add('Membro ${doc.id} ignorado: dados incompletos.');
      }
    }

    return SeoCatalog(
      categories: categories,
      posts: posts,
      documents: documents,
      members: members,
      warnings: warnings,
    );
  }

  T _convert<T>(String kind, RestDocument doc, T Function() convert) {
    try {
      return convert();
    } catch (error) {
      throw SeoException('Não consegui ler $kind "${doc.path}": $error');
    }
  }
}
