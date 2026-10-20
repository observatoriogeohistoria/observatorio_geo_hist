import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_grid.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// É um sliver.
class PanelListSkeleton extends StatelessWidget {
  const PanelListSkeleton({this.isGrid = false, super.key});

  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final colors = AppTheme.colors;
    final stroke = AppTheme.dimensions.stroke.small;

    final Widget sliver;
    if (isGrid) {
      sliver = PanelGrid(
        itemCount: components.panelSkeletonRows * 2,
        itemBuilder: (_, __) => const _SkeletonTile(),
      );
    } else {
      sliver = DecoratedSliver(
        decoration: BoxDecoration(
          color: colors.page,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
          border: Border.all(color: colors.line, width: stroke),
        ),
        sliver: SliverPadding(
          padding: EdgeInsets.all(stroke),
          sliver: SliverList.builder(
            itemCount: components.panelSkeletonRows,
            itemBuilder: (_, index) => DecoratedBox(
              decoration: BoxDecoration(
                border:
                    index == 0 ? null : Border(top: BorderSide(color: colors.line, width: stroke)),
              ),
              child: _SkeletonRow(index: index),
            ),
          ),
        ),
      );
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Semantics(liveRegion: true, label: 'Carregando', child: const SizedBox.shrink()),
        ),
        SliverSemantics(excludeSemantics: true, sliver: sliver),
      ],
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);
    final titleWidth =
        components.panelSkeletonTitleWidth - components.panelSkeletonTitleStep * index;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: components.panelRowPaddingH,
        vertical: components.panelRowPaddingV,
      ),
      child: Row(
        children: [
          SizedBox(
            width: components.panelThumbWidth(ScreenUtils.breakpointOf(context)),
            child: AspectRatio(
              aspectRatio: components.panelThumbAspect,
              child: ClipRRect(
                borderRadius: radius,
                child: const Skeleton(width: null, height: null),
              ),
            ),
          ),
          SizedBox(width: components.panelRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: titleWidth,
                  child: ClipRRect(
                    borderRadius: radius,
                    child: Skeleton(width: null, height: components.panelSkeletonTitleHeight),
                  ),
                ),
                SizedBox(height: components.panelSkeletonGap),
                FractionallySizedBox(
                  widthFactor: components.panelSkeletonMetaWidth,
                  child: ClipRRect(
                    borderRadius: radius,
                    child: Skeleton(width: null, height: components.panelSkeletonMetaHeight),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = AppTheme.dimensions.radii.r14;

    return Container(
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: components.panelTileAspect,
            child: const Skeleton(width: null, height: null),
          ),
          Padding(
            padding: EdgeInsets.all(components.panelTilePaddingH),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: components.panelSkeletonTitleWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8),
                child: Skeleton(width: null, height: components.panelSkeletonMetaHeight),
              ),
            ),
          ),
          SizedBox(height: components.minTapTarget),
        ],
      ),
    );
  }
}
