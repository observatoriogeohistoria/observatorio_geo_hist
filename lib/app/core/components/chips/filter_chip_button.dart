import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class FilterChipButton extends StatefulWidget {
  const FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    this.count,
  });

  final String label;
  final int? count;
  final bool selected;
  final VoidCallback onPressed;

  /// Largura que o chip vai ocupar, para decidir se cabe ao lado de outro elemento.
  static double measure(BuildContext context, String label, int? count) {
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).chip;
    final textScaler = MediaQuery.textScalerOf(context);

    double textWidth(String text, TextStyle style) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout();
      final width = painter.width;
      painter.dispose();
      return width;
    }

    return components.chipPaddingH * 2 +
        AppTheme.dimensions.stroke.small * 2 +
        textWidth(label, style) +
        (count == null
            ? 0
            : components.chipCountGap + textWidth('$count', _countStyle(style, selected: false)));
  }

  static TextStyle _countStyle(TextStyle style, {required bool selected}) => style.copyWith(
        fontWeight: FontWeight.w500,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: selected ? AppTheme.colors.white : AppTheme.colors.inkSecondary,
      );

  @override
  State<FilterChipButton> createState() => _FilterChipButtonState();
}

class _FilterChipButtonState extends State<FilterChipButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).chip;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.pill);
    final selected = widget.selected;
    final count = widget.count;

    final background = selected ? colors.ink : colors.page;
    final foreground = selected ? colors.white : colors.ink;
    final borderColor = selected || _hovered ? colors.ink : colors.line;
    final semanticLabel = count == null
        ? widget.label
        : '${widget.label}, $count ${count == 1 ? 'publicação' : 'publicações'}';

    return Semantics(
      button: true,
      toggled: selected,
      label: semanticLabel,
      onTap: widget.onPressed,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: background,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: borderColor,
              width: AppTheme.dimensions.stroke.small,
            ),
          ),
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: components.chipPaddingH,
                vertical: components.chipPaddingV,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.label, style: style.copyWith(color: foreground)),
                  if (count != null) ...[
                    SizedBox(width: components.chipCountGap),
                    Text(
                      '$count',
                      style: FilterChipButton._countStyle(style, selected: selected),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
