import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onSearch,
    this.semanticLabel,
  });

  final TextEditingController controller;
  final String hint;
  final String? semanticLabel;

  /// Chamado depois que a pessoa para de digitar, ao apertar Enter e ao limpar.
  final ValueChanged<String> onSearch;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final _focusNode = FocusNode();
  Timer? _debounce;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocus);
    widget.controller.addListener(_handleText);
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleText);
      widget.controller.addListener(_handleText);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_handleText);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocus() {
    if (_focused != _focusNode.hasFocus) setState(() => _focused = _focusNode.hasFocus);
  }

  void _handleText() => setState(() {});

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(
      AppTheme.dimensions.components.searchDebounce,
      () => widget.onSearch(text),
    );
  }

  void _submit(String text) {
    _debounce?.cancel();
    widget.onSearch(text);
  }

  void _clear() {
    widget.controller.clear();
    _submit('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r12);
    final hasText = widget.controller.text.isNotEmpty;
    final textStyle = styles.regular.copyWith(color: colors.ink);

    // A borda fica no contêiner: o InputDecorator não se estica até a altura pedida.
    return AnimatedContainer(
      duration: components.menuAnimation,
      constraints: BoxConstraints(minHeight: components.searchFieldHeight),
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: radius,
        border: Border.all(
          color: _focused ? colors.accent : colors.line,
          width: components.searchFieldBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: _focused ? colors.accentSoft : colors.accentSoft.withValues(alpha: 0),
            spreadRadius: components.searchFieldFocusRing,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Semantics(
            label: widget.semanticLabel,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: _onChanged,
              onSubmitted: _submit,
              textInputAction: TextInputAction.search,
              style: textStyle,
              cursorColor: colors.accent,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: styles.regular.copyWith(color: colors.inkSecondary),
                isCollapsed: true,
                border: InputBorder.none,
                contentPadding: EdgeInsetsDirectional.only(
                  start: components.searchFieldPaddingStart - components.searchFieldBorder,
                  end: components.searchFieldPaddingEnd - components.searchFieldBorder,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            start: components.searchFieldIconInset,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Icon(
                  Icons.search,
                  size: components.navIcon,
                  color: colors.inkSecondary,
                ),
              ),
            ),
          ),
          if (hasText)
            PositionedDirectional(
              end: components.searchFieldClearInset,
              child: _ClearButton(onPressed: _clear),
            ),
        ],
      ),
    );
  }
}

class _ClearButton extends StatefulWidget {
  const _ClearButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);

    return Semantics(
      button: true,
      label: 'Limpar busca',
      onTap: widget.onPressed,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: _hovered ? colors.surface : Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: components.searchFieldClearPaddingH,
                vertical: components.searchFieldClearPaddingV,
              ),
              child: Text(
                'Limpar',
                style: AppTheme.typography.of(context).chip.copyWith(
                      color: _hovered ? colors.ink : colors.inkSecondary,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
