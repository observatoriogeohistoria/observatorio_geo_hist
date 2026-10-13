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

enum StatusTone { success, error, accent, neutral }

class StatusBadge extends StatelessWidget {
  const StatusBadge(this.text, {required this.tone, this.icon, super.key});

  final String text;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    final (foreground, background) = switch (tone) {
      StatusTone.success => (colors.success, colors.successSurface),
      StatusTone.error => (colors.error, colors.errorSurface),
      StatusTone.accent => (colors.accentStrong, colors.accentSoft),
      StatusTone.neutral => (colors.inkSecondary, colors.surface),
    };
    final style = AppTheme.typography
        .of(context)
        .tag
        .copyWith(color: foreground, fontWeight: FontWeight.w700);

    // Borda transparente nos tons coloridos, para todos os selos terem a mesma altura.
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: components.badgePaddingH,
        vertical: components.badgePaddingV,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.pill),
        border: Border.all(
          color: tone == StatusTone.neutral ? colors.line : Colors.transparent,
          width: AppTheme.dimensions.stroke.small,
        ),
      ),
      child: icon == null
          ? Text(text, style: style)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: components.badgeIcon, color: foreground),
                SizedBox(width: components.badgeIconGap),
                Text(text, style: style),
              ],
            ),
    );
  }
}
