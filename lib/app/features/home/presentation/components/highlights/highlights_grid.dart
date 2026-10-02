import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class HighlightsGrid extends StatelessWidget {
  const HighlightsGrid({super.key, required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    assert(itemCount >= 1 && itemCount <= 3, 'A grade de destaques mostra de 1 a 3 itens.');

    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = components.featuredGap;

    if (breakpoint == Breakpoint.mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < itemCount; index++) ...[
            if (index > 0) SizedBox(height: gap),
            if (index == 0)
              SizedBox(
                  height: components.featuredMainHeightMobile, child: itemBuilder(context, index))
            else
              itemBuilder(context, index),
          ],
        ],
      );
    }

    final main = itemBuilder(context, 0);

    return SizedBox(
      height: components.featuredGridHeight(breakpoint),
      child: itemCount == 1
          ? main
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: components.featuredMainFlex, child: main),
                SizedBox(width: gap),
                Expanded(
                  flex: components.featuredSideFlex,
                  child: itemCount == 2
                      ? itemBuilder(context, 1)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: itemBuilder(context, 1)),
                            SizedBox(height: gap),
                            Expanded(child: itemBuilder(context, 2)),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
