import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class NavbarDropdownEntry {
  const NavbarDropdownEntry({
    required this.title,
    required this.onTap,
    this.isDisabled = false,
    this.isSelected = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool isDisabled;
  final bool isSelected;
}

/// Navbar item that reveals its sub options in a floating panel on hover
/// (mouse) or on tap (touch devices).
class NavbarDropdown extends StatefulWidget {
  const NavbarDropdown({
    required this.title,
    required this.entries,
    this.backgroundColor,
    super.key,
  });

  final String title;
  final List<NavbarDropdownEntry> entries;
  final Color? backgroundColor;

  @override
  State<NavbarDropdown> createState() => _NavbarDropdownState();
}

class _NavbarDropdownState extends State<NavbarDropdown> {
  static const _closeDelay = Duration(milliseconds: 150);
  static const _panelMaxWidth = 300.0;

  final _overlayController = OverlayPortalController();
  final _link = LayerLink();

  Timer? _closeTimer;
  bool _isOpen = false;
  bool _openedByTap = false;
  bool _alignRight = false;

  @override
  void dispose() {
    _closeTimer?.cancel();
    super.dispose();
  }

  void _open({bool byTap = false}) {
    _closeTimer?.cancel();
    if (byTap) _openedByTap = true;
    if (_isOpen) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final left = box.localToGlobal(Offset.zero).dx;
      final screenWidth = MediaQuery.of(context).size.width;
      _alignRight = left + _panelMaxWidth > screenWidth;
    }

    setState(() => _isOpen = true);
    _overlayController.show();
  }

  void _close() {
    _closeTimer?.cancel();
    if (!_isOpen) return;

    _openedByTap = false;
    setState(() => _isOpen = false);
    _overlayController.hide();
  }

  void _scheduleClose() {
    if (_openedByTap) return;
    _closeTimer?.cancel();
    _closeTimer = Timer(_closeDelay, _close);
  }

  void _toggleByTap() => _isOpen && _openedByTap ? _close() : _open(byTap: true);

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildOverlay,
      child: CompositedTransformTarget(
        link: _link,
        child: MouseRegion(
          onEnter: (_) => _open(),
          onExit: (_) => _scheduleClose(),
          child: NavButton(
            text: widget.title,
            onPressed: _toggleByTap,
            menuChildren: null,
            backgroundColor: widget.backgroundColor,
            textColor: _isOpen ? AppTheme.colors.orange : null,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final maxWidth = _panelMaxWidth.clamp(0.0, MediaQuery.of(context).size.width - 32).toDouble();

    return Stack(
      children: [
        // Lets touch users dismiss the panel by tapping anywhere else.
        if (_openedByTap)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _close,
            ),
          ),
        CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor: _alignRight ? Alignment.bottomRight : Alignment.bottomLeft,
          followerAnchor: _alignRight ? Alignment.topRight : Alignment.topLeft,
          child: Align(
            alignment: _alignRight ? Alignment.topRight : Alignment.topLeft,
            child: MouseRegion(
              onEnter: (_) => _open(),
              onExit: (_) => _scheduleClose(),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, (1 - value) * -8),
                    child: child,
                  ),
                ),
                child: Padding(
                  // Transparent gap between trigger and panel, still inside
                  // the MouseRegion so the pointer can cross it.
                  padding: const EdgeInsets.only(top: 26),
                  child: _DropdownPanel(
                    entries: widget.entries,
                    maxWidth: maxWidth,
                    onSelected: _close,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownPanel extends StatelessWidget {
  const _DropdownPanel({
    required this.entries,
    required this.maxWidth,
    required this.onSelected,
  });

  final List<NavbarDropdownEntry> entries;
  final double maxWidth;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.colors.white,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
        border: Border.all(color: AppTheme.colors.lighterGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
        child: _buildContent(context, maxHeight),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double maxHeight) {
    return Material(
      type: MaterialType.transparency,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 200.scale.clamp(0, maxWidth).toDouble(),
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        child: IntrinsicWidth(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: AppTheme.dimensions.space.mini.verticalSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final entry in entries)
                  _DropdownItem(
                    entry: entry,
                    onSelected: onSelected,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DropdownItem extends StatefulWidget {
  const _DropdownItem({required this.entry, required this.onSelected});

  final NavbarDropdownEntry entry;
  final VoidCallback onSelected;

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = (ScreenUtils.isSmallDesktop(context)
            ? AppTheme.typography.title.small
            : AppTheme.typography.title.medium)
        .copyWith(
      fontWeight: widget.entry.isSelected ? FontWeight.w700 : FontWeight.w500,
      color: _hovered || widget.entry.isSelected
          ? AppTheme.colors.orange
          : AppTheme.colors.darkGray.withValues(alpha: 0.7),
    );
    final padding = EdgeInsets.symmetric(
      horizontal: AppTheme.dimensions.space.medium.scale,
      vertical: AppTheme.dimensions.space.small.verticalSpacing,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.entry.isDisabled) return;
          widget.onSelected();
          widget.entry.onTap();
        },
        child: Padding(
          padding: padding,
          child: Text(widget.entry.title, style: style),
        ),
      ),
    );
  }
}
