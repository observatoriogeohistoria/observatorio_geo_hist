import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelSegment<T> {
  const PanelSegment(this.value, this.label);

  final T value;
  final String label;
}

/// Opções exclusivas lado a lado; o leitor de tela as trata como grupo de rádio.
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
              hoverColor: isSelected ? Colors.transparent : colors.page,
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
