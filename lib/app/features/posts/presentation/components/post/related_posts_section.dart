import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/arrow_link.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/related_post_card.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Leia também (spec 012): até três artigos da mesma categoria, com o link
/// "Mais em [categoria]". Sem artigos, a seção não aparece.
class RelatedPostsSection extends StatelessWidget {
  const RelatedPostsSection({
    super.key,
    required this.posts,
    required this.area,
    required this.category,
  });

  final List<PostModel> posts;
  final PostsAreas area;
  final CategoryModel category;

  static const maxColumns = 3;

  @override
  Widget build(BuildContext context) {
    final articles = [
      for (final post in posts)
        if (post.id != null && post.body is ArticleModel) (id: post.id!, article: post.body! as ArticleModel),
    ];
    if (articles.isEmpty) return const SizedBox.shrink();

    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final sectionPadding = components.sectionPaddingVertical(breakpoint);
    final categoryRoute = AppRoutes.category(area.key, category.key);

    final title = Semantics(
      header: true,
      headingLevel: 2,
      child: Text('Leia também', style: AppTheme.typography.of(context).h2.copyWith(color: colors.ink)),
    );
    final more = ArrowLink(
      text: 'Mais em ${category.title}',
      url: categoryRoute,
      onTap: () => GoRouter.of(context).go(categoryRoute),
    );

    return PageContent(
      child: Padding(
        // A coluna de leitura acima já deixa o seu respiro embaixo.
        padding: EdgeInsets.only(
          top: math.max(0, sectionPadding - components.readingPaddingBottom(breakpoint)),
          bottom: sectionPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (breakpoint == Breakpoint.mobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [title, SizedBox(height: components.postSubtitleGap), more],
              )
            else
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: components.postBylineGap,
                runSpacing: components.postSubtitleGap,
                children: [title, more],
              ),
            SizedBox(height: components.sectionHeadGap),
            LayoutBuilder(
              builder: (context, constraints) {
                final gap = components.relatedCardGapH;
                final columns = math.min(
                  maxColumns,
                  math.max(1, ((constraints.maxWidth + gap) / (components.relatedCardMinWidth + gap)).floor()),
                );
                final rows = (articles.length / columns).ceil();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var row = 0; row < rows; row++) ...[
                      if (row > 0) SizedBox(height: components.relatedCardGapV),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var column = 0; column < columns; column++) ...[
                            if (column > 0) SizedBox(width: gap),
                            Expanded(
                              child: row * columns + column < articles.length
                                  ? RelatedPostCard(
                                      article: articles[row * columns + column].article,
                                      route: AppRoutes.post(area.key, category.key, articles[row * columns + column].id),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
