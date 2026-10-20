import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelToggleChip extends StatefulWidget {
  const PanelToggleChip({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.selectedIcon,
    super.key,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<PanelToggleChip> createState() => _PanelToggleChipState();
}

class _PanelToggleChipState extends State<PanelToggleChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final on = widget.value;
    final foreground = on ? colors.white : colors.ink;

    void toggle() => widget.onChanged(!on);

    return Semantics(
      container: true,
      button: true,
      toggled: on,
      label: widget.label,
      onTap: toggle,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: on ? colors.ink : colors.page,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: on ? colors.ink : (_hovered ? colors.ink : colors.line),
              width: components.libraryFilterBorder,
            ),
          ),
          child: InkWell(
            onTap: toggle,
            onHover: (value) => setState(() => _hovered = value),
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: SizedBox(
              height: components.panelControlHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: components.chipPaddingH),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      on ? (widget.selectedIcon ?? widget.icon) : widget.icon,
                      size: components.panelToggleIcon,
                      color: foreground,
                    ),
                    SizedBox(width: components.panelToggleGap),
                    Text(
                      widget.label,
                      style: AppTheme.typography.of(context).chip.copyWith(color: foreground),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
