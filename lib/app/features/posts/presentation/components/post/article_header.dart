import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/date/date.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/post_cover.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/social_icons.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Cabeçalho do artigo (`.article-head`): migalhas, título, subtítulo, linha
/// de autoria com compartilhar e capa.
class ArticleHeader extends StatelessWidget {
  const ArticleHeader({
    super.key,
    required this.post,
    required this.article,
    required this.area,
    required this.category,
  });

  final PostModel post;
  final ArticleModel article;
  final PostsAreas area;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final subtitle = article.subtitle.trim();
    final imageUrl = article.image.url?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Breadcrumbs(
            items: [
              const BreadcrumbItem('Início', route: AppRoutes.root),
              BreadcrumbItem(area.portuguese),
              BreadcrumbItem(category.title, route: AppRoutes.category(area.key, category.key)),
              const BreadcrumbItem('Artigo'),
            ],
          ),
        ),
        SizedBox(height: components.postTitleGap),
        Semantics(
          header: true,
          headingLevel: 1,
          child: Text(article.title.trim(), style: styles.postTitle.copyWith(color: colors.ink)),
        ),
        if (subtitle.isNotEmpty) ...[
          SizedBox(height: components.postSubtitleGap),
          Text(subtitle, style: styles.postSubtitle.copyWith(color: colors.inkSecondary)),
        ],
        SizedBox(height: components.postBylineMarginTop),
        _Byline(post: post, article: article),
        if (imageUrl.isNotEmpty) ...[
          SizedBox(height: components.postCoverMarginTop),
          PostCover(imageUrl: imageUrl, caption: article.imageCaption),
        ],
      ],
    );
  }
}

class _Byline extends StatelessWidget {
  const _Byline({required this.post, required this.article});

  final PostModel post;
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final author = _Author(authors: article.authors, date: article.date);
    final share = SocialIcons(post: post);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: colors.line)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: components.postBylinePaddingVertical),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [author, SizedBox(height: components.postBylineGap), share],
              )
            : Row(
                children: [
                  Expanded(child: author),
                  SizedBox(width: components.postBylineGap),
                  share,
                ],
              ),
      ),
    );
  }
}

/// Autoria: com um autor, círculo de iniciais e nome; com vários, os nomes
/// juntos ("A, B e C"); a data abaixo do nome, como "março de 2026".
class _Author extends StatelessWidget {
  const _Author({required this.authors, required this.date});

  final List<String> authors;
  final String date;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final names = [for (final name in authors) if (name.trim().isNotEmpty) name.trim()];
    final formattedDate = formatMonthYear(date);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (names.isNotEmpty)
          Text(joinNames(names), style: styles.regular.copyWith(color: colors.ink, fontWeight: FontWeight.w700)),
        if (formattedDate.isNotEmpty) Text(formattedDate, style: styles.small.copyWith(color: colors.inkSecondary)),
      ],
    );

    if (names.length != 1) return text;

    final diameter = components.postAuthorAvatar * MediaQuery.textScalerOf(context).scale(1);

    return Row(
      children: [
        ExcludeSemantics(
          child: Container(
            width: diameter,
            height: diameter,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: colors.accentSoft, shape: BoxShape.circle),
            child: Text(initialsOf(names.first), style: styles.postAuthorInitials.copyWith(color: colors.accentStrong)),
          ),
        ),
        SizedBox(width: components.postAuthorGap),
        Expanded(child: text),
      ],
    );
  }
}
