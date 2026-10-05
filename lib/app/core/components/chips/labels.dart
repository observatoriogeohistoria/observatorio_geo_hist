import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CategoryTag extends StatelessWidget {
  const CategoryTag(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: components.tagPaddingH,
        vertical: components.tagPaddingV,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r6),
      ),
      child: Text(
        text,
        style: AppTheme.typography.of(context).tag.copyWith(color: colors.inkSecondary),
      ),
    );
  }
}

class TypeBadge extends StatelessWidget {
  const TypeBadge(this.text, {super.key, this.wrap = false});

  final String text;

  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: components.badgePaddingH,
        vertical: components.badgePaddingV,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.pill),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      child: Text(
        text,
        softWrap: wrap,
        style: AppTheme.typography
            .of(context)
            .tag
            .copyWith(color: colors.inkSecondary, fontWeight: FontWeight.w700),
      ),
    );
  }
}
