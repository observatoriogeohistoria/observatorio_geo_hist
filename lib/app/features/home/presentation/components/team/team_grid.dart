import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Grade da equipe (spec 008): colunas de mesma largura, com no mínimo
/// `teamColumnMinWidth` × ampliação do texto, alinhadas à esquerda e pelo topo.
/// No celular, duas colunas fixas.
///
/// Recebe um construtor de item para servir também ao esqueleto.
class TeamGrid extends StatelessWidget {
  const TeamGrid({super.key, required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Quantas colunas cabem em [width] (`repeat(auto-fill, minmax(190px, 1fr))`).
  static int columnsFor(BuildContext context, double width) {
    final components = AppTheme.dimensions.components;
    final textScaler = MediaQuery.textScalerOf(context);
    if (ScreenUtils.breakpointOf(context) == Breakpoint.mobile) {
      return textScaler.scale(1) < components.teamStackTextScale ? components.teamColumnsMobile : 1;
    }
    final minWidth = textScaler.scale(components.teamColumnMinWidth);
    final gap = components.teamColumnGap;
    return math.max(1, ((width + gap) / (minWidth + gap)).floor());
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsFor(context, constraints.maxWidth);
        final rows = (itemCount / columns).ceil();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var row = 0; row < rows; row++) ...[
              if (row > 0) SizedBox(height: components.teamRowGap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) SizedBox(width: components.teamColumnGap),
                    Expanded(
                      child: row * columns + column < itemCount
                          ? itemBuilder(context, row * columns + column)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
