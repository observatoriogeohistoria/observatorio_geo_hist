import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_column.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/article_body.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostPageSkeleton extends StatelessWidget {
  const PostPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final radii = AppTheme.dimensions.radii;
    final barHeight = components.postSkeletonBarHeight;
    final avatar = components.postAuthorAvatar;

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
          PostHeadFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                bar(components.postSkeletonCrumbsWidth, barHeight),
                SizedBox(height: components.postTitleGap),
                bar(1, components.postSkeletonTitleHeight),
                SizedBox(height: components.postSubtitleGap),
                bar(components.postSkeletonTitleLastWidth, components.postSkeletonTitleHeight),
                SizedBox(height: components.postSubtitleGap),
                bar(components.postSkeletonSubtitleWidth, barHeight),
                SizedBox(
                    height: components.postBylineMarginTop + components.postBylinePaddingVertical),
                Row(
                  children: [
                    ClipOval(child: Skeleton(width: avatar, height: avatar)),
                    SizedBox(width: components.postAuthorGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          bar(components.postSkeletonNameWidth, barHeight),
                          SizedBox(height: components.postNoteLabelGap),
                          bar(components.postSkeletonDateWidth, barHeight),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height: components.postBylinePaddingVertical + components.postCoverMarginTop),
                AspectRatio(
                  aspectRatio: components.postCoverAspect,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radii.r16),
                    child: const Skeleton(width: null, height: null),
                  ),
                ),
              ],
            ),
          ),
          ReadingColumn(
            paddingTop: components.postBodyPaddingTop,
            children: [
              for (var line = 0; line < components.postSkeletonLines; line++) ...[
                if (line > 0) SizedBox(height: components.postSubtitleGap),
                bar(
                    line == components.postSkeletonLines - 1
                        ? components.postSkeletonLastLineWidth
                        : 1,
                    barHeight),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
