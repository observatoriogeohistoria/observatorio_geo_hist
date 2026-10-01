import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/article_body.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/academic_production_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/book_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/document_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/event_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/film_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/magazine_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/music_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/podcast_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/search_content.dart';

/// Ponto único que escolhe o conteúdo do post pelo tipo. O artigo usa o
/// layout-base (spec 012); os outros tipos, o bloco antigo, até a Fase 5
/// trocar cada um pelo layout-base com o bloco do tipo.
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
      PostType.article =>
        ArticleBody(post: post, article: post.body! as ArticleModel, area: area, category: category),
      PostType.document => DocumentContent(post: post, document: post.body! as DocumentModel),
      PostType.book => BookContent(post: post, book: post.body! as BookModel),
      PostType.film => FilmContent(post: post, film: post.body! as FilmModel),
      PostType.magazine => MagazineContent(post: post, magazine: post.body! as MagazineModel),
      PostType.podcast => PodcastContent(post: post, podcast: post.body! as PodcastModel),
      PostType.music => MusicContent(post: post, music: post.body! as MusicModel),
      PostType.academicProduction =>
        AcademicProductionContent(post: post, academicProduction: post.body! as AcademicProductionModel),
      PostType.event => EventContent(post: post, event: post.body! as EventModel),
      PostType.search => SearchContent(post: post, search: post.body! as SearchModel),
    };
  }
}
