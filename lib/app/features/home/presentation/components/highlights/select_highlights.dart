import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

const int maxHighlights = 3;

/// Descarta posts incompletos e fica com os três mais recentes. O primeiro é o principal.
List<PostModel> selectHighlights(List<PostModel> posts) {
  final complete = posts.where((post) {
    final id = post.id;
    return post.body != null && id != null && id.isNotEmpty && highlightArea(post) != null;
  }).toList();

  // `sort` não é estável: o índice original desempata datas iguais ou nulas.
  final indexed = complete.indexed.toList()
    ..sort((a, b) {
      final dateA = a.$2.createdAt;
      final dateB = b.$2.createdAt;
      if (dateA == null && dateB == null) return a.$1.compareTo(b.$1);
      if (dateA == null) return 1;
      if (dateB == null) return -1;
      final byDate = dateB.compareTo(dateA);
      return byDate != 0 ? byDate : a.$1.compareTo(b.$1);
    });

  return indexed.map((entry) => entry.$2).take(maxHighlights).toList();
}

/// A área da categoria do post ou, se a categoria não foi encontrada, a primeira do post.
PostsAreas? highlightArea(PostModel post) {
  final categoryAreas = post.category?.areas ?? const <PostsAreas>[];
  if (categoryAreas.isNotEmpty) return categoryAreas.first;
  if (post.areas.isNotEmpty) return post.areas.first;
  return null;
}

String highlightPath(PostModel post) {
  return AppRoutes.post(highlightArea(post)!.key, post.categoryId, post.id!);
}
