import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Grade de blocos com largura mínima fixa, quantos couberem (dois no celular). É um sliver.
class PanelGrid extends StatelessWidget {
  const PanelGrid({required this.itemCount, required this.itemBuilder, super.key});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final gap = components.panelTileGap;
    final isMobile = ScreenUtils.isMobile(context);

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final columns = isMobile
            ? components.panelGridColumnsMobile
            : math.max(1, ((width + gap) / (components.panelTileMinWidth + gap)).floor());
        final rows = (itemCount / columns).ceil();

        // Linhas de blocos em vez de SliverGrid: o bloco tem a altura do conteúdo, sem
        // precisar fixar a proporção da célula.
        return SliverList.builder(
          itemCount: rows,
          itemBuilder: (context, row) => Padding(
            padding: EdgeInsets.only(top: row == 0 ? 0 : gap),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var column = 0; column < columns; column++) ...[
                  if (column > 0) SizedBox(width: gap),
                  Expanded(
                    child: row * columns + column < itemCount
                        ? itemBuilder(context, row * columns + column)
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
