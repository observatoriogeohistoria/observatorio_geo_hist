import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_item.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class NavbarDropdown extends StatefulWidget {
  const NavbarDropdown({
    super.key,
    required this.label,
    required this.menuBuilder,
    this.isActive = false,
  });

  final String label;
  final bool isActive;

  final Widget Function(BuildContext context, VoidCallback close) menuBuilder;

  @override
  State<NavbarDropdown> createState() => _NavbarDropdownState();
}

class _NavbarDropdownState extends State<NavbarDropdown> {
  static const _closeDelay = Duration(milliseconds: 150);

  final _overlayController = OverlayPortalController();
  final _link = LayerLink();
  final _triggerFocus = FocusNode(debugLabel: 'NavbarDropdown trigger');
  final _panelScope = FocusScopeNode(debugLabel: 'NavbarDropdown panel');

  Timer? _closeTimer;
  bool _isOpen = false;

  bool _isPinned = false;
  bool _alignRight = false;

  @override
  void dispose() {
    _closeTimer?.cancel();
    _triggerFocus.dispose();
    _panelScope.dispose();
    super.dispose();
  }

  void _open({bool pinned = false, bool focusFirst = false}) {
    _closeTimer?.cancel();
    if (pinned) _isPinned = true;

    if (!_isOpen) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final left = box.localToGlobal(Offset.zero).dx;
        final screenWidth = MediaQuery.sizeOf(context).width;
        _alignRight = left + AppTheme.dimensions.components.dropdownMaxWidth > screenWidth;
      }

      setState(() => _isOpen = true);
      _overlayController.show();
    }

    if (focusFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isOpen) _focusFirstOption();
      });
    }
  }

  /// Pedir foco ao escopo não basta: sem um filho focado, nada aparece marcado.
  void _focusFirstOption() {
    final policy = FocusTraversalGroup.maybeOfNode(_panelScope) ?? ReadingOrderTraversalPolicy();
    final first = policy.findFirstFocus(_panelScope, ignoreCurrentFocus: true);
    (first ?? _panelScope).requestFocus();
  }

  /// O foco só anda depois que o painel sai da tela; antes disso, as opções ainda contam no Tab.
  void _closeAndMoveFocus({required bool backwards}) {
    _triggerFocus.requestFocus();
    _close();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      backwards ? _triggerFocus.previousFocus() : _triggerFocus.nextFocus();
    });
  }

  void _close() {
    _closeTimer?.cancel();
    if (!_isOpen) return;

    _isPinned = false;
    setState(() => _isOpen = false);
    _overlayController.hide();
  }

  void _scheduleClose() {
    if (_isPinned || _panelScope.hasFocus) return;
    _closeTimer?.cancel();
    _closeTimer = Timer(_closeDelay, _close);
  }

  void _onTap() {
    if (_isOpen && _isPinned) {
      _close();
      return;
    }

    final byKeyboard = FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    _open(pinned: true, focusFirst: byKeyboard);
  }

  KeyEventResult _onTriggerKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _open(pinned: true, focusFirst: true);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape && _isOpen) {
      _close();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.tab && _isOpen) {
      _closeAndMoveFocus(backwards: HardwareKeyboard.instance.isShiftPressed);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _onPanelKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.escape) {
      _triggerFocus.requestFocus();
      _close();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      FocusManager.instance.primaryFocus?.nextFocus();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      FocusManager.instance.primaryFocus?.previousFocus();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.tab) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        _triggerFocus.requestFocus();
        _close();
      } else {
        _closeAndMoveFocus(backwards: false);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

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
          child: Focus(
            canRequestFocus: false,
            skipTraversal: true,
            onKeyEvent: _onTriggerKey,
            child: NavbarItem(
              label: widget.label,
              isActive: widget.isActive,
              hasMenu: true,
              isExpanded: _isOpen,
              focusNode: _triggerFocus,
              onTap: _onTap,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final spacing = AppTheme.dimensions.spacing;
    final screen = MediaQuery.sizeOf(context);
    final maxWidth = components.dropdownMaxWidth.clamp(0.0, screen.width - spacing.s32).toDouble();
    // Deixa o menu 8 px abaixo da linha da navbar.
    final gapAboveMenu = spacing.s20;
    final maxHeight = (screen.height - components.navbarHeight - spacing.s20 - spacing.s16).clamp(0.0, double.infinity);
    final duration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : components.menuAnimation;

    return Stack(
      children: [
        if (_isPinned)
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
                duration: duration,
                curve: Curves.easeOut,
                builder: (context, value, child) => Opacity(opacity: value, child: child),
                child: Padding(
                  // Vão transparente dentro da área do mouse, para o ponteiro chegar ao menu sem fechá-lo.
                  padding: EdgeInsets.only(top: gapAboveMenu),
                  child: FocusScope(
                    node: _panelScope,
                    onKeyEvent: _onPanelKey,
                    child: _Panel(
                      minWidth: components.dropdownMinWidth.clamp(0.0, maxWidth).toDouble(),
                      maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      child: widget.menuBuilder(context, _close),
                    ),
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

class _Panel extends StatelessWidget {
  const _Panel({
    required this.minWidth,
    required this.maxWidth,
    required this.maxHeight,
    required this.child,
  });

  final double minWidth;
  final double maxWidth;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.colors.page,
        borderRadius: radius,
        border: Border.all(color: AppTheme.colors.line),
        boxShadow: AppTheme.dimensions.shadows.elevated,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth, maxHeight: maxHeight),
            child: IntrinsicWidth(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppTheme.dimensions.spacing.s8),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
