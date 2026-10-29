import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Columns of at least [ComponentSizes.postCardMinWidth], up to three.
class PostCardGrid extends StatelessWidget {
  const PostCardGrid({super.key, required this.children});

  final List<Widget> children;

  static int columnsFor(double width) {
    final components = AppTheme.dimensions.components;
    final gap = components.postCardGapH;
    return math.min(
      components.postCardMaxColumns,
      math.max(
        1,
        ((width + gap) / (components.postCardMinWidth + gap)).floor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsFor(constraints.maxWidth);
        final rows = (children.length / columns).ceil();

        // Rows with Row and Expanded, not GridView: each card takes its own text's height.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var row = 0; row < rows; row++) ...[
              if (row > 0) SizedBox(height: components.postCardGapV),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) SizedBox(width: components.postCardGapH),
                    Expanded(
                      child: row * columns + column < children.length
                          ? children[row * columns + column]
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
