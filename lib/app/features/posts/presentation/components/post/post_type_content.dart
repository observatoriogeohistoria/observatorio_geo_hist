import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/article_body.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/work/work_body.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/work/work_info.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/event_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/music_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/podcast_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/search_content.dart';

/// Podcast, música, evento e pesquisa ainda mostram o conteúdo antigo.
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
      PostType.academicProduction =>
        WorkBody(post: post, info: workInfoOf(post), area: area, category: category),
      PostType.podcast => PodcastContent(post: post, podcast: post.body! as PodcastModel),
      PostType.music => MusicContent(post: post, music: post.body! as MusicModel),
      PostType.event => EventContent(post: post, event: post.body! as EventModel),
      PostType.search => SearchContent(post: post, search: post.body! as SearchModel),
    };
  }
}
