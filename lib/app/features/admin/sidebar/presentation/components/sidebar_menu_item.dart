import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SidebarMenuItem extends StatefulWidget {
  const SidebarMenuItem({
    required this.title,
    required this.onTap,
    this.icon,
    this.count,
    this.isCurrent = false,
    this.isParentOfCurrent = false,
    this.isSubItem = false,
    this.isMuted = false,
    this.autofocus = false,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  /// Hidden while loading or when the count failed.
  final int? count;

  final bool isCurrent;
  final bool isParentOfCurrent;
  final bool isSubItem;
  final bool isMuted;
  final bool autofocus;

  @override
  State<SidebarMenuItem> createState() => _SidebarMenuItemState();
}

class _SidebarMenuItemState extends State<SidebarMenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);

    final foreground = widget.isCurrent || widget.isParentOfCurrent
        ? colors.accentStrong
        : widget.isMuted
            ? colors.inkSecondary
            : colors.ink;
    final background = widget.isCurrent
        ? colors.accentSoft
        : _hovered
            ? colors.surface
            : Colors.transparent;

    final baseStyle = widget.isSubItem ? styles.panelNavSubItem : styles.panelNavItem;
    final textStyle = baseStyle.copyWith(
      color: foreground,
      fontWeight: widget.isSubItem && widget.isCurrent ? FontWeight.w700 : null,
    );

    final count = widget.count;
    final semanticLabel = [
      widget.title,
      if (count != null) '$count',
      if (widget.isCurrent) 'atual',
    ].join(', ');

    return Semantics(
      button: true,
      selected: widget.isCurrent,
      label: semanticLabel,
      onTap: widget.onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: background,
          borderRadius: radius,
          child: InkWell(
            autofocus: widget.autofocus,
            borderRadius: radius,
            onTap: widget.onTap,
            onHover: (value) => setState(() => _hovered = value),
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.click,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget.isSubItem
                    ? components.panelNavSubItemPaddingV
                    : components.panelNavItemPaddingV,
                horizontal: widget.isSubItem
                    ? components.panelNavSubItemPaddingH
                    : components.panelNavItemPaddingH,
              ),
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: components.panelNavIcon, color: foreground),
                    SizedBox(width: components.panelNavItemGap),
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ),
                  if (count != null) ...[
                    SizedBox(width: components.panelNavCountGap),
                    Text(
                      '$count',
                      maxLines: 1,
                      style: styles.panelCount.copyWith(color: colors.inkSecondary),
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
