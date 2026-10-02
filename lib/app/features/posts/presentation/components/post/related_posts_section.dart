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
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card_grid.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final articles = [
      for (final post in posts)
        if (post.id != null && post.body is ArticleModel) post,
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
      child: Text(
        'Leia também',
        style: AppTheme.typography.of(context).h2.copyWith(color: colors.ink),
      ),
    );
    final more = ArrowLink(
      text: 'Mais em ${category.title}',
      url: categoryRoute,
      onTap: () => GoRouter.of(context).go(categoryRoute),
    );

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(
          top: math.max(
            0,
            sectionPadding - components.readingPaddingBottom(breakpoint),
          ),
          bottom: sectionPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (breakpoint == Breakpoint.mobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  SizedBox(height: components.postSubtitleGap),
                  more,
                ],
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
            PostCardGrid(
              children: [
                for (final post in articles)
                  PostCard(
                    post: post,
                    route: AppRoutes.post(area.key, category.key, post.id!),
                    showSummary: false,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
