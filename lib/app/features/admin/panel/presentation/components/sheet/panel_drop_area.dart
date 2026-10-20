import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelDropArea extends StatelessWidget {
  const PanelDropArea({
    required this.icon,
    required this.title,
    required this.semanticLabel,
    this.semanticHint,
    this.subtitle,
    this.previewBuilder,
    this.actionLabel,
    this.onTap,
    this.focusNode,
    this.square = false,
    this.hasError = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String semanticLabel;
  final String? semanticHint;
  final String? subtitle;

  /// Ocupa a área toda, como `cover`; recebe o placeholder para mostrar quando falhar.
  final Widget? Function(Widget placeholder)? previewBuilder;

  /// Etiqueta sobre a prévia, para lembrar que dá para trocar o arquivo.
  final String? actionLabel;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool square;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);
    final subtitle = this.subtitle;
    final actionLabel = this.actionLabel;

    final placeholder = Padding(
      padding: EdgeInsets.all(components.panelDropPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: components.panelDropIcon, color: colors.inkSecondary),
          SizedBox(height: components.panelDropGap),
          Text(
            title,
            textAlign: TextAlign.center,
            style: styles.panelChoiceTitle.copyWith(color: colors.ink),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: styles.small.copyWith(color: colors.inkSecondary),
            ),
        ],
      ),
    );
    final preview = previewBuilder?.call(placeholder);

    Widget area = CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: hasError ? colors.error : colors.fieldBorder,
        radius: AppTheme.dimensions.radii.r12,
        width: components.formFieldBorder,
        dash: components.panelDropDash,
        gap: components.panelDropDashGap,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: ColoredBox(
          color: colors.surface,
          child: preview == null
              ? placeholder
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    preview,
                    if (actionLabel != null)
                      Positioned(
                        right: components.panelDropPadding,
                        bottom: components.panelDropPadding,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.page,
                            borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.pill),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.dimensions.spacing.s12,
                              vertical: AppTheme.dimensions.spacing.s4,
                            ),
                            child: Text(
                              actionLabel,
                              style: styles.chip.copyWith(color: colors.ink),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );

    area = square
        ? SizedBox.square(dimension: components.panelDropSquare, child: area)
        : AspectRatio(aspectRatio: components.panelDropAspect, child: area);

    final tap = onTap;
    if (tap == null) {
      return Semantics(
        container: true,
        label: semanticLabel,
        hint: semanticHint,
        excludeSemantics: true,
        child: area,
      );
    }

    return Semantics(
      button: true,
      label: semanticLabel,
      hint: semanticHint,
      onTap: tap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            focusNode: focusNode,
            onTap: tap,
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            focusColor: Colors.transparent,
            child: area,
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.width,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final double radius;
  final double width;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = width / 2;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(inset, inset, size.width - width, size.height - width),
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    for (final PathMetric metric in (Path()..addRRect(rect)).computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += dash + gap) {
        canvas.drawPath(metric.extractPath(start, start + dash), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color || width != oldDelegate.width;
}
