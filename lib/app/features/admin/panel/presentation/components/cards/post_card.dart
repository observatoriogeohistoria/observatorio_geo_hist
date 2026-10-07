import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/academic_production_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/posts_cards/article_card.dart';
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
    required this.onHighlight,
    required this.onEdit,
    required this.onDelete,
    required this.canEdit,
    super.key,
  });

  final PostModel post;
  final int index;
  final void Function() onPublish;
  final void Function() onHighlight;
  final void Function() onEdit;
  final void Function() onDelete;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;

    return AppCard(
      padding: EdgeInsets.symmetric(
        horizontal: components.panelCardPaddingH,
        vertical: components.panelCardPaddingV,
      ),
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
                  _buildInfo(
                    context,
                    'Área(s)',
                    post.areas.map((area) => area.portuguese).join(' e '),
                  ),
                  if (post.category != null) ...[
                    SizedBox(height: components.panelCardTextGap),
                    _buildInfo(context, 'Categoria', post.category!.title),
                  ],
                  SizedBox(height: dimensions.spacing.s12),
                  Wrap(
                    spacing: dimensions.spacing.s8,
                    runSpacing: dimensions.spacing.s8,
                    children: [
                      post.isPublished
                          ? const StatusBadge('Publicado', tone: StatusTone.success)
                          : const StatusBadge('Não publicado', tone: StatusTone.error),
                      if (post.isHighlighted)
                        const StatusBadge('Destaque', tone: StatusTone.accent),
                    ],
                  ),
                ],
              ),
            ),
            if (canEdit) ...[
              SizedBox(width: dimensions.spacing.s16),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppIconButton(
                    tooltip: post.isPublished ? 'Despublicar post' : 'Publicar post',
                    icon: post.isPublished ? Icons.public_off : Icons.public,
                    color: colors.accent,
                    onPressed: onPublish,
                  ),
                  SizedBox(height: components.panelCardActionsGap),
                  AppIconButton(
                    tooltip: post.isHighlighted ? 'Remover dos destaques' : 'Destacar post',
                    icon: post.isHighlighted
                        ? Icons.bookmark_remove_outlined
                        : Icons.bookmark_add_outlined,
                    color: colors.accent,
                    onPressed: onHighlight,
                  ),
                  SizedBox(height: components.panelCardActionsGap),
                  AppIconButton(
                    tooltip: 'Editar post',
                    icon: Icons.edit,
                    color: colors.accent,
                    onPressed: onEdit,
                  ),
                  SizedBox(height: components.panelCardActionsGap),
                  AppIconButton(
                    tooltip: 'Excluir post',
                    icon: Icons.delete,
                    color: colors.error,
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

  Widget _buildInfo(BuildContext context, String title, String text) {
    final colors = AppTheme.colors;
    final typography = AppTheme.typography.of(context);

    return Text.rich(
      TextSpan(
        text: '$title: ',
        style: typography.formLabel.copyWith(color: colors.accent),
        children: [
          TextSpan(
            text: text,
            style: typography.regular.copyWith(color: colors.ink),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(PostModel post) {
    if (post.body == null) return const SizedBox.shrink();

    if (post.type == PostType.article) {
      return ArticleCard(body: (post.body! as ArticleModel), index: index);
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
