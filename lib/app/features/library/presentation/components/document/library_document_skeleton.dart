import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryDocumentSkeleton extends StatelessWidget {
  const LibraryDocumentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radii = AppTheme.dimensions.radii;
    final line = BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small);

    Widget block(double width, double height, {double? radius}) => ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? radii.r6),
          child: Skeleton(width: width, height: height),
        );

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

    Widget fact() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            block(components.libraryDetailSkeletonLabelWidth,
                components.libraryDetailSkeletonLabelHeight),
            SizedBox(height: AppTheme.dimensions.spacing.s8),
            block(components.libraryDetailSkeletonValueWidth,
                components.libraryDetailSkeletonValueHeight),
          ],
        );

    return Semantics(
      label: 'Carregando',
      liveRegion: true,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: components.libraryDetailBadgeTop),
          Align(
            alignment: Alignment.centerLeft,
            child: block(components.libraryDetailSkeletonBadgeWidth,
                components.libraryDetailSkeletonBadgeHeight,
                radius: radii.pill),
          ),
          SizedBox(height: components.libraryDetailTitleTop),
          bar(1, components.libraryDetailSkeletonTitleHeight),
          SizedBox(height: components.libraryDetailSkeletonTitleGap),
          bar(components.libraryDetailSkeletonTitleLastWidth,
              components.libraryDetailSkeletonTitleHeight),
          Container(
            margin: EdgeInsets.only(top: components.libraryFactsTop),
            padding: EdgeInsets.symmetric(vertical: components.libraryFactsPaddingV),
            decoration: BoxDecoration(border: Border(top: line, bottom: line)),
            child: Wrap(
              spacing: components.libraryFactsGapH,
              runSpacing: components.libraryFactsGapV,
              children: [
                for (var index = 0; index < components.libraryFactsMaxColumns; index++) fact()
              ],
            ),
          ),
          SizedBox(height: components.libraryDetailActionTop),
          Align(
            alignment: Alignment.centerLeft,
            child: block(
                components.libraryDetailSkeletonButtonWidth, components.buttonMinHeightRegular,
                radius: radii.r10),
          ),
          Container(
            height: components.libraryDetailSkeletonViewerHeight,
            margin: EdgeInsets.only(top: components.libraryViewerMarginTop),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(radii.r16),
              border: Border.fromBorderSide(line),
            ),
          ),
        ],
      ),
    );
  }
}
