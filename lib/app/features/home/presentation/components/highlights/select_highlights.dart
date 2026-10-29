import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

const int maxHighlights = 3;

/// Drops incomplete posts and keeps the three most recent. The first is the main one.
List<PostModel> selectHighlights(List<PostModel> posts) {
  final complete = posts.where((post) {
    final id = post.id;
    return post.body != null && id != null && id.isNotEmpty && highlightArea(post) != null;
  }).toList();

  // `sort` isn't stable: the original index breaks ties between equal or null dates.
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

/// The area of the post's category or, if the category wasn't found, the post's first one.
PostsAreas? highlightArea(PostModel post) {
  final categoryAreas = post.category?.areas ?? const <PostsAreas>[];
  if (categoryAreas.isNotEmpty) return categoryAreas.first;
  if (post.areas.isNotEmpty) return post.areas.first;
  return null;
}

String highlightPath(PostModel post) {
  return AppRoutes.post(highlightArea(post)!.key, post.categoryId, post.id!);
}
