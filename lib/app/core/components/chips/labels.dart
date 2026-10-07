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

enum StatusTone { success, error, accent }

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.text, {required this.tone, super.key});

  final String text;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    final (foreground, background) = switch (tone) {
      StatusTone.success => (colors.success, colors.successSurface),
      StatusTone.error => (colors.error, colors.errorSurface),
      StatusTone.accent => (colors.accentStrong, colors.accentSoft),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: components.badgePaddingH,
        vertical: components.badgePaddingV,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.pill),
      ),
      child: Text(
        text,
        style: AppTheme.typography
            .of(context)
            .tag
            .copyWith(color: foreground, fontWeight: FontWeight.w700),
      ),
    );
  }
}
