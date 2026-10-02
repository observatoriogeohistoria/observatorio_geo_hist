import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryFilterOption<T> {
  const LibraryFilterOption(this.value, this.label);

  final T value;
  final String label;
}

class LibraryFilterSelect<T> extends StatefulWidget {
  const LibraryFilterSelect({
    super.key,
    required this.semanticLabel,
    required this.options,
    required this.value,
    required this.onSelected,
    this.labelBuilder,
    this.height,
    this.expand = false,
  });

  final String semanticLabel;
  final List<LibraryFilterOption<T>> options;
  final T value;
  final ValueChanged<T> onSelected;

  /// Texto do botão para a opção escolhida; sem ele, vale o texto da opção.
  final String Function(LibraryFilterOption<T> option)? labelBuilder;
  final double? height;
  final bool expand;

  @override
  State<LibraryFilterSelect<T>> createState() => _LibraryFilterSelectState<T>();
}

class _LibraryFilterSelectState<T> extends State<LibraryFilterSelect<T>> {
  final _controller = MenuController();
  final _buttonFocus = FocusNode();
  final _selectedFocus = FocusNode();

  @override
  void dispose() {
    _buttonFocus.dispose();
    _selectedFocus.dispose();
    super.dispose();
  }

  void _toggle() => _controller.isOpen ? _controller.close() : _controller.open();

  // Aberto pelo teclado, o foco entra no menu na opção atual; pelo mouse, fica onde está.
  void _handleOpen() {
    if (!_buttonFocus.hasFocus) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_controller.isOpen) _selectedFocus.requestFocus();
    });
  }

  // O menu prende o Tab dentro dele; aqui o Tab sai do menu (as setas andam entre as opções).
  KeyEventResult _handleMenuKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.tab) {
      return KeyEventResult.ignored;
    }
    final backwards = HardwareKeyboard.instance.isShiftPressed;
    _controller.close();
    _buttonFocus.requestFocus();
    if (!backwards) {
      SchedulerBinding.instance.addPostFrameCallback((_) => _buttonFocus.nextFocus());
    }
    setState(() {});
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    final selected =
        options.firstWhere((option) => option.value == widget.value, orElse: () => options.first);
    final label = widget.labelBuilder?.call(selected) ?? selected.label;

    return MenuAnchor(
      controller: _controller,
      childFocusNode: _buttonFocus,
      // O clique fora só fecha o menu; sem isso, também abria o documento embaixo.
      consumeOutsideTap: true,
      onOpen: _handleOpen,
      onClose: () => setState(() {}),
      style: libraryMenuStyle(),
      alignmentOffset: Offset(0, AppTheme.dimensions.components.libraryPanelOffset),
      menuChildren: [
        Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: _handleMenuKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final option in options)
                Semantics(
                  selected: option == selected,
                  child: MenuItemButton(
                    focusNode: option == selected ? _selectedFocus : null,
                    requestFocusOnHover: false,
                    style: libraryMenuItemStyle(context),
                    trailingIcon: option == selected
                        ? Icon(Icons.check, size: AppTheme.dimensions.components.libraryFilterIcon)
                        : null,
                    onPressed: () => widget.onSelected(option.value),
                    child: Text(option.label),
                  ),
                ),
            ],
          ),
        ),
      ],
      builder: (context, controller, _) => LibraryFilterButton(
        focusNode: _buttonFocus,
        semanticLabel: widget.semanticLabel,
        semanticValue: label,
        expanded: controller.isOpen,
        onPressed: () {
          _toggle();
          setState(() {});
        },
        height: widget.height,
        expand: widget.expand,
        child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
      ),
    );
  }
}

MenuStyle libraryMenuStyle() {
  final colors = AppTheme.colors;
  final components = AppTheme.dimensions.components;

  return MenuStyle(
    backgroundColor: WidgetStatePropertyAll(colors.page),
    surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    shadowColor: WidgetStatePropertyAll(colors.ink.withValues(alpha: components.scrimOpacity)),
    elevation: WidgetStatePropertyAll(components.libraryPanelElevation),
    padding: WidgetStatePropertyAll(EdgeInsets.all(components.libraryPanelPadding)),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
        side: BorderSide(color: colors.line),
      ),
    ),
    maximumSize: WidgetStatePropertyAll(Size(double.infinity, components.libraryPanelMaxHeight)),
  );
}

ButtonStyle libraryMenuItemStyle(BuildContext context) {
  final colors = AppTheme.colors;
  final components = AppTheme.dimensions.components;

  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.hovered) || states.contains(WidgetState.focused)
          ? colors.surface
          : Colors.transparent,
    ),
    overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    foregroundColor: WidgetStatePropertyAll(colors.ink),
    iconColor: WidgetStatePropertyAll(colors.inkSecondary),
    textStyle: WidgetStatePropertyAll(AppTheme.typography.of(context).meta),
    padding: WidgetStatePropertyAll(EdgeInsets.all(components.libraryPanelItemPadding)),
    minimumSize: WidgetStatePropertyAll(Size(0, components.buttonMinHeightSmall)),
    side: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.focused)
          ? BorderSide(
              color: AppTheme.dimensions.focus.color, width: AppTheme.dimensions.focus.width)
          : BorderSide.none,
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8)),
    ),
  );
}

class LibraryFilterButton extends StatefulWidget {
  const LibraryFilterButton({
    super.key,
    required this.child,
    required this.semanticLabel,
    required this.onPressed,
    required this.expanded,
    this.semanticValue,
    this.focusNode,
    this.height,
    this.expand = false,
  });

  final Widget child;
  final String semanticLabel;
  final String? semanticValue;
  final VoidCallback onPressed;
  final bool expanded;
  final FocusNode? focusNode;
  final double? height;
  final bool expand;

  @override
  State<LibraryFilterButton> createState() => _LibraryFilterButtonState();
}

class _LibraryFilterButtonState extends State<LibraryFilterButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);

    return Semantics(
      button: true,
      expanded: widget.expanded,
      label: widget.semanticLabel,
      value: widget.semanticValue,
      onTap: widget.onPressed,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: colors.page,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: _hovered || widget.expanded ? colors.lineStrong : colors.line,
              width: components.libraryFilterBorder,
            ),
          ),
          child: InkWell(
            focusNode: widget.focusNode,
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            customBorder: RoundedRectangleBorder(borderRadius: radius),
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: widget.height ?? components.libraryFilterHeight),
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: components.libraryFilterPaddingStart,
                  end: components.libraryFilterPaddingEnd,
                ),
                child: Row(
                  mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: widget.expand ? FlexFit.tight : FlexFit.loose,
                      child: DefaultTextStyle.merge(
                        style: AppTheme.typography.of(context).libraryFilter.copyWith(
                              color: colors.ink,
                            ),
                        child: widget.child,
                      ),
                    ),
                    SizedBox(width: components.libraryFilterIconGap),
                    AnimatedRotation(
                      turns: widget.expanded ? 0.5 : 0,
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : components.menuAnimation,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: components.libraryFilterIcon,
                        color: colors.inkSecondary,
                      ),
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
