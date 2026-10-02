import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryListingSkeleton extends StatelessWidget {
  const LibraryListingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Semantics(
      liveRegion: true,
      label: 'Carregando',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < components.librarySkeletonRows; index++) const _RowSkeleton(),
        ],
      ),
    );
  }
}

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton();

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    Widget bar(double widthFactor, double height) => FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: widthFactor,
          child: ClipRRect(borderRadius: radius, child: Skeleton(width: null, height: height)),
        );

    Widget tag() => ClipRRect(
          borderRadius: radius,
          child: Skeleton(
            width: components.librarySkeletonTagWidth,
            height: components.librarySkeletonTagHeight,
          ),
        );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: components.libraryDocPaddingV,
        horizontal: components.libraryDocPaddingH,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          bar(components.librarySkeletonTitleWidth, components.librarySkeletonTitleHeight),
          SizedBox(height: components.libraryDocGapV),
          bar(components.librarySkeletonMetaWidth, components.librarySkeletonMetaHeight),
          SizedBox(height: components.libraryDocGapV),
          Row(children: [tag(), SizedBox(width: components.libraryTagGap), tag()]),
        ],
      ),
    );
  }
}
