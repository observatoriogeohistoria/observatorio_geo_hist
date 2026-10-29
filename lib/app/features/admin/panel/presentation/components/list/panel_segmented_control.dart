import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelSegment<T> {
  const PanelSegment(this.value, this.label);

  final T value;
  final String label;
}

/// Exclusive options side by side; screen readers treat them as a radio group.
class PanelSegmentedControl<T> extends StatelessWidget {
  const PanelSegmentedControl({
    required this.semanticLabel,
    required this.segments,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String semanticLabel;
  final List<PanelSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_naturalWidth(context) <= constraints.maxWidth) return _segments();

        // With no room for the options side by side (on phones), it becomes a dropdown.
        return LibraryFilterSelect<T>(
          semanticLabel: semanticLabel,
          height: AppTheme.dimensions.components.panelControlHeight,
          options: [
            for (final segment in segments) LibraryFilterOption(segment.value, segment.label)
          ],
          labelBuilder: (option) => '$semanticLabel: ${option.label}',
          value: value,
          onSelected: (selected) {
            if (selected != value) onChanged(selected);
          },
        );
      },
    );
  }

  double _naturalWidth(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).panelSegment;
    final textScaler = MediaQuery.textScalerOf(context);
    var width =
        2 * components.panelSegmentPadding + (segments.length - 1) * components.panelSegmentGap;
    for (final segment in segments) {
      final painter = TextPainter(
        text: TextSpan(text: segment.label, style: style),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();
      width += painter.width + 2 * components.panelSegmentButtonPaddingH;
      painter.dispose();
    }
    return width;
  }

  Widget _segments() {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: Container(
        height: components.panelControlHeight,
        padding: EdgeInsets.all(components.panelSegmentPadding),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: components.panelSegmentGap,
          children: [
            for (final segment in segments)
              _SegmentButton(
                label: segment.label,
                isSelected: segment.value == value,
                onPressed: () {
                  if (segment.value != value) onChanged(segment.value);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({required this.label, required this.isSelected, required this.onPressed});

  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);

    return Semantics(
      container: true,
      inMutuallyExclusiveGroup: true,
      checked: isSelected,
      label: label,
      onTap: onPressed,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        fit: StackFit.passthrough,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? colors.page : Colors.transparent,
            borderRadius: radius,
            boxShadow: isSelected ? AppTheme.dimensions.shadows.segment : null,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onPressed,
              borderRadius: radius,
              splashFactory: NoSplash.splashFactory,
              focusColor: Colors.transparent,
              // Same color in both states: changing color on hover painted the
              // highlight black (Flutter reuses the previous color's opacity).
              hoverColor: colors.page,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: components.panelSegmentButtonPaddingH),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    label,
                    style: AppTheme.typography.of(context).panelSegment.copyWith(
                          color: isSelected ? colors.ink : colors.inkSecondary,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
