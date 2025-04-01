import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PagesCircles extends StatelessWidget {
  const PagesCircles({
    required this.count,
    required this.currentPage,
    super.key,
  });

  final int count;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Container(
            margin: EdgeInsets.only(
              left: i == 0 ? AppTheme.dimensions.space.small.horizontalSpacing : 0,
              right: AppTheme.dimensions.space.small.horizontalSpacing,
            ),
            child: circle(i == currentPage),
          ),
      ],
    );
  }

  Widget circle(bool active) {
    final color = active ? AppTheme.colors.orange : AppTheme.colors.gray.withValues(alpha: 0.6);

    return Container(
      height: 12.scale,
      width: 12.scale,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
