import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

/// Quantos destaques aparecem na Home (spec 005).
const int maxHighlights = 3;

/// Escolhe os destaques mostrados na Home: descarta posts incompletos, ordena
/// do mais recente para o mais antigo (sem data no fim) e fica com os três
/// primeiros. O primeiro da lista é o destaque principal.
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

/// Área usada no rótulo e no endereço do destaque: a da categoria do post ou,
/// se a categoria não foi encontrada, a primeira área do próprio post.
PostsAreas? highlightArea(PostModel post) {
  final categoryAreas = post.category?.areas ?? const <PostsAreas>[];
  if (categoryAreas.isNotEmpty) return categoryAreas.first;
  if (post.areas.isNotEmpty) return post.areas.first;
  return null;
}

/// Endereço da página do post (`/publicacoes/:area/:categoria/:id`).
String highlightPath(PostModel post) {
  return AppRoutes.post(highlightArea(post)!.key, post.categoryId, post.id!);
}
