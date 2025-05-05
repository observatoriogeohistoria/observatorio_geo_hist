import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/artist_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/academic_production_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/article_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/artist_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/book_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/document_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/event_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/film_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/magazine_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/music_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/podcast_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/search_card.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.index,
    required this.onPublish,
    required this.onEdit,
    required this.onDelete,
    required this.canEdit,
    super.key,
  });

  final PostModel post;
  final int index;
  final void Function() onPublish;
  final void Function() onEdit;
  final void Function() onDelete;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBody(post),
                  const AppDivider(),
                  AppBody.big(
                    text:
                        '${post.areas.map((area) => area.portuguese).join(' - ')} | ${post.category?.title}',
                    color: AppTheme.colors.gray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                  AppLabel.medium(
                    text: post.isPublished ? 'Publicado' : 'Não Publicado',
                    color: post.isPublished ? AppTheme.colors.green : AppTheme.colors.red,
                  ),
                ],
              ),
            ),
            if (canEdit) ...[
              SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Tooltip(
                    message: post.isPublished ? 'Despublicar post' : 'Publicar post',
                    child: AppIconButton(
                      icon: post.isPublished ? Icons.public_off : Icons.public,
                      color: AppTheme.colors.orange,
                      onPressed: onPublish,
                    ),
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppIconButton(
                    icon: Icons.edit,
                    color: AppTheme.colors.gray,
                    onPressed: onEdit,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppIconButton(
                    icon: Icons.delete,
                    color: AppTheme.colors.red,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBody(PostModel post) {
    if (post.body == null) return const SizedBox.shrink();

    if (post.type == PostType.article) {
      return ArticleCard(body: (post.body! as ArticleModel), index: index);
    }

    if (post.type == PostType.artist) {
      return ArtistCard(body: (post.body! as ArtistModel), index: index);
    }

    if (post.type == PostType.document) {
      return DocumentCard(body: (post.body! as DocumentModel), index: index);
    }

    if (post.type == PostType.event) {
      return EventCard(body: (post.body! as EventModel), index: index);
    }

    if (post.type == PostType.film) {
      return FilmCard(body: (post.body! as FilmModel), index: index);
    }

    if (post.type == PostType.book) {
      return BookCard(body: (post.body! as BookModel), index: index);
    }

    if (post.type == PostType.music) {
      return MusicCard(body: (post.body! as MusicModel), index: index);
    }

    if (post.type == PostType.search) {
      return SearchCard(body: (post.body! as SearchModel), index: index);
    }

    if (post.type == PostType.podcast) {
      return PodcastCard(body: (post.body! as PodcastModel), index: index);
    }

    if (post.type == PostType.academicProduction) {
      return AcademicProductionCard(body: (post.body! as AcademicProductionModel), index: index);
    }

    if (post.type == PostType.magazine) {
      return MagazineCard(body: (post.body! as MagazineModel), index: index);
    }

    return const SizedBox.shrink();
  }
}
