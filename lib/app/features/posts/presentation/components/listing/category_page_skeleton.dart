import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card_skeleton.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CategoryPageSkeleton extends StatelessWidget {
  const CategoryPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radii = AppTheme.dimensions.radii;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final barHeight = components.postSkeletonBarHeight;

    Widget bar(double widthFactor, double height) => Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radii.r6),
              child: Skeleton(width: null, height: height),
            ),
          ),
        );

    return Semantics(
      label: 'Carregando',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(bottom: BorderSide(color: colors.line)),
            ),
            child: PageContent(
              child: Padding(
                padding: EdgeInsets.only(
                  top: components.pageHeadPaddingTop,
                  bottom: components.pageHeadPaddingBottom(breakpoint),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    bar(components.pageHeadSkeletonCrumbsWidth, barHeight),
                    SizedBox(height: components.pageHeadTitleGap),
                    bar(
                      components.pageHeadSkeletonTitleWidth,
                      components.postSkeletonTitleHeight,
                    ),
                    SizedBox(height: components.pageHeadLeadGap),
                    bar(1, barHeight),
                    SizedBox(height: components.postSubtitleGap),
                    bar(components.pageHeadSkeletonLastLineWidth, barHeight),
                  ],
                ),
              ),
            ),
          ),
          PageContent(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: components.listingStatePaddingBottom,
              ),
              child: const PostCardSkeletonRow(),
            ),
          ),
        ],
      ),
    );
  }
}
