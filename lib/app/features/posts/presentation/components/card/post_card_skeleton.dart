import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card_grid.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostCardSkeletonRow extends StatelessWidget {
  const PostCardSkeletonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Carregando',
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, constraints) => PostCardGrid(
          children: [
            for (var index = 0; index < PostCardGrid.columnsFor(constraints.maxWidth); index++)
              const _PostCardSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _PostCardSkeleton extends StatelessWidget {
  const _PostCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final radii = AppTheme.dimensions.radii;

    Widget bar(double widthFactor, double height) => Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radii.r8),
              child: Skeleton(width: null, height: height),
            ),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: components.postCardThumbAspect,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radii.r14),
            child: const Skeleton(width: null, height: null),
          ),
        ),
        SizedBox(height: components.postCardInnerGap),
        bar(
          components.postCardSkeletonLabelWidth,
          components.postCardSkeletonLabelHeight,
        ),
        SizedBox(height: components.postCardInnerGap),
        bar(
          components.postCardSkeletonTitleWidth,
          components.postCardSkeletonTitleHeight,
        ),
        SizedBox(height: components.postCardInnerGap),
        bar(
          components.postCardSkeletonMetaWidth,
          components.postCardSkeletonLabelHeight,
        ),
      ],
    );
  }
}
