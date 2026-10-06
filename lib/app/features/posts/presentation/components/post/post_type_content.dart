import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/article_body.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/work/work_body.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/work/work_info.dart';

class PostTypeContent extends StatelessWidget {
  const PostTypeContent({
    super.key,
    required this.post,
    required this.area,
    required this.category,
  });

  final PostModel post;
  final PostsAreas area;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return switch (post.type) {
      PostType.article => ArticleBody(
          post: post, article: post.body! as ArticleModel, area: area, category: category),
      PostType.book ||
      PostType.film ||
      PostType.magazine ||
      PostType.document ||
      PostType.academicProduction ||
      PostType.podcast ||
      PostType.music ||
      PostType.event ||
      PostType.search =>
        WorkBody(post: post, info: workInfoOf(post), area: area, category: category),
    };
  }
}
