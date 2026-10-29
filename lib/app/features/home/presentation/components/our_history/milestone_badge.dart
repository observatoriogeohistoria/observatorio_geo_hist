import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MilestoneBadge extends StatelessWidget {
  const MilestoneBadge({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).badge.copyWith(color: colors.accentStrong);
    final lineHeight = MediaQuery.textScalerOf(context).scale(style.fontSize!) * style.height!;
    final iconTopOffset = math.max(0.0, (lineHeight - components.milestoneBadgeIcon) / 2);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: components.milestoneBadgePaddingVertical,
          horizontal: components.milestoneBadgePaddingHorizontal,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Padding(
                padding: EdgeInsets.only(top: iconTopOffset),
                child: Icon(
                  Icons.schedule_outlined,
                  size: components.milestoneBadgeIcon,
                  color: colors.accentStrong,
                ),
              ),
            ),
            SizedBox(width: components.milestoneBadgeIconGap),
            Flexible(child: Text(text, style: style)),
          ],
        ),
      ),
    );
  }
}
