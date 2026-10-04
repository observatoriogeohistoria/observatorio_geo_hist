import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryCategoryTag extends StatelessWidget {
  const LibraryCategoryTag(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: components.libraryTagPaddingH,
        vertical: components.libraryTagPaddingV,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r6),
      ),
      child: Text(
        text,
        style: AppTheme.typography.of(context).libraryTag.copyWith(color: colors.inkSecondary),
      ),
    );
  }
}

class LibraryTypeBadge extends StatelessWidget {
  const LibraryTypeBadge(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: components.libraryBadgePaddingH,
        vertical: components.libraryBadgePaddingV,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.pill),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      child: Text(
        text,
        softWrap: false,
        style: AppTheme.typography
            .of(context)
            .libraryTag
            .copyWith(color: colors.inkSecondary, fontWeight: FontWeight.w700),
      ),
    );
  }
}
