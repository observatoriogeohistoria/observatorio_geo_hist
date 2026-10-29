import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppIconButton extends StatefulWidget {
  const AppIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
    this.label,
    this.size = 24,
    this.focusNode,
    this.focusRingColor,
    this.isDisabled = false,
    this.isToggled,
    super.key,
  });

  final IconData icon;
  final Color color;
  final void Function() onPressed;

  /// What happens, shown on hover and on keyboard focus.
  final String tooltip;

  /// Short name for screen readers ("Delete"); without it, [tooltip] is used.
  final String? label;

  final double size;

  final FocusNode? focusNode;

  /// On an accent background the default ring disappears; use a color that contrasts with it.
  final Color? focusRingColor;

  /// Stays focusable so people can Tab to it and read in the tooltip why it's unavailable.
  final bool isDisabled;

  /// For toggle buttons (highlight): the screen reader announces whether it's on.
  final bool? isToggled;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  final _tooltipKey = GlobalKey<TooltipState>();
  FocusNode? _ownFocusNode;
  bool _focused = false;

  FocusNode get _focusNode => widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange(bool hasFocus) {
    setState(() => _focused = hasFocus);
    if (!hasFocus) {
      Tooltip.dismissAllToolTips();
      return;
    }
    if (FocusManager.instance.highlightMode != FocusHighlightMode.traditional) return;
    // With a screen reader the tooltip is already in the button's name, and opening its overlay takes
    // the browser's focus off the button.
    if (SemanticsBinding.instance.semanticsEnabled) return;

    // After the frame, so it isn't closed by the button that just lost focus.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _tooltipKey.currentState?.ensureTooltipVisible();
    });
  }

  // Esc is only consumed when a tooltip was open; otherwise it goes on to the drawer or dialog.
  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    return Tooltip.dismissAllToolTips() ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final minTarget = components.minTapTarget;
    final disabled = widget.isDisabled;
    final label = widget.label ?? widget.tooltip;

    return Semantics(
      button: true,
      enabled: !disabled,
      toggled: widget.isToggled,
      label: label,
      tooltip: label == widget.tooltip ? null : widget.tooltip,
      onTap: disabled ? null : widget.onPressed,
      // Without the IconButton's node, focus must sit on this one; otherwise, with a screen reader on,
      // the browser loses focus when it reaches the button.
      focusable: true,
      focused: _focused,
      onFocus: _focusNode.requestFocus,
      excludeSemantics: true,
      child: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onFocusChange: _handleFocusChange,
        onKeyEvent: _handleKey,
        child: Tooltip(
          key: _tooltipKey,
          message: widget.tooltip,
          excludeFromSemantics: true,
          constraints: BoxConstraints(maxWidth: components.tooltipMaxWidth),
          padding: EdgeInsets.symmetric(
            horizontal: components.tooltipPaddingH,
            vertical: components.tooltipPaddingV,
          ),
          verticalOffset: minTarget / 2 + components.tooltipOffset,
          decoration: BoxDecoration(
            color: colors.ink,
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8),
          ),
          textStyle: AppTheme.typography.of(context).tooltip.copyWith(color: colors.white),
          child: AppFocusRing(
            borderRadius: BorderRadius.circular(minTarget),
            color: widget.focusRingColor,
            child: Opacity(
              opacity: disabled ? components.disabledOpacity : 1,
              child: IconButton(
                focusNode: _focusNode,
                padding: EdgeInsets.all(AppTheme.dimensions.spacing.s8),
                constraints: BoxConstraints(minWidth: minTarget, minHeight: minTarget),
                iconSize: widget.size,
                mouseCursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
                hoverColor: disabled ? Colors.transparent : null,
                highlightColor: disabled ? Colors.transparent : null,
                splashColor: disabled ? Colors.transparent : null,
                icon: Icon(widget.icon, color: widget.color, size: widget.size),
                onPressed: () {
                  if (!disabled) widget.onPressed();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
