import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelList extends StatelessWidget {
  const PanelList({
    required this.itemCount,
    required this.itemBuilder,
    this.footer,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final stroke = AppTheme.dimensions.stroke.small;
    final radius = AppTheme.dimensions.radii.r14;
    final innerRadius = Radius.circular(radius - stroke);
    final footer = this.footer;
    final count = itemCount + (footer == null ? 0 : 1);

    // Rows sit inside the border, so the hover background doesn't cover it.
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.line, width: stroke),
      ),
      sliver: SliverPadding(
        padding: EdgeInsets.all(stroke),
        sliver: SliverList.builder(
          itemCount: count,
          itemBuilder: (context, index) {
            Widget child = index < itemCount ? itemBuilder(context, index) : footer!;

            if (index > 0) {
              child = DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: colors.line, width: stroke)),
                ),
                child: child,
              );
            }

            final isFirst = index == 0;
            final isLast = index == count - 1;
            if (!isFirst && !isLast) return child;

            return ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: isFirst ? innerRadius : Radius.zero,
                bottom: isLast ? innerRadius : Radius.zero,
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
