import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PasswordVisibilityButton extends StatefulWidget {
  const PasswordVisibilityButton({super.key, required this.visible, required this.onPressed});

  final bool visible;
  final VoidCallback onPressed;

  @override
  State<PasswordVisibilityButton> createState() => _PasswordVisibilityButtonState();
}

class _PasswordVisibilityButtonState extends State<PasswordVisibilityButton> {
  final _tooltipKey = GlobalKey<TooltipState>();

  // O Tooltip do Flutter só abre com mouse ou toque; pelo teclado a dica precisa ser chamada.
  void _handleFocus(bool hasFocus) {
    if (!hasFocus) {
      Tooltip.dismissAllToolTips();
    } else if (FocusManager.instance.highlightMode == FocusHighlightMode.traditional) {
      _tooltipKey.currentState?.ensureTooltipVisible();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final label = widget.visible ? 'Ocultar senha' : 'Mostrar senha';

    return Tooltip(
      key: _tooltipKey,
      message: widget.visible ? 'Ocultar a senha' : 'Mostrar a senha digitada',
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        toggled: widget.visible,
        label: label,
        onTap: widget.onPressed,
        excludeSemantics: true,
        child: AppFocusRing(
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: widget.onPressed,
            onFocusChange: _handleFocus,
            mouseCursor: SystemMouseCursors.click,
            child: SizedBox.square(
              dimension: components.minTapTarget,
              child: Icon(
                widget.visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: components.menuIconSize,
                color: colors.inkSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
