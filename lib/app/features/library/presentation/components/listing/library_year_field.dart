import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryYearField extends StatefulWidget {
  const LibraryYearField({super.key, required this.value, required this.onChanged});

  final int? value;

  /// Chamado só com o ano completo ou com o campo vazio.
  final ValueChanged<String> onChanged;

  @override
  State<LibraryYearField> createState() => _LibraryYearFieldState();
}

class _LibraryYearFieldState extends State<LibraryYearField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value?.toString() ?? '';
    _focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant LibraryYearField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final digits = AppTheme.dimensions.components.libraryYearDigits;
    // O ano pode ser tirado pelo chip ou por "Limpar tudo"; um ano incompleto continua.
    if (widget.value == null && _controller.text.length == digits) {
      _controller.clear();
    } else if (widget.value != null && _controller.text != '${widget.value}') {
      _controller.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocus() {
    if (_focused != _focusNode.hasFocus) setState(() => _focused = _focusNode.hasFocus);
  }

  void _handleChanged(String text) {
    final digits = AppTheme.dimensions.components.libraryYearDigits;
    if (text.isEmpty || text.length == digits) widget.onChanged(text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);

    return AnimatedContainer(
      duration: components.menuAnimation,
      width: components.libraryYearFieldWidth,
      constraints: BoxConstraints(minHeight: components.libraryFilterHeight),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r10),
        border: Border.all(
          color: _focused ? colors.accent : colors.line,
          width: components.libraryFilterBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: _focused ? colors.accentSoft : colors.accentSoft.withValues(alpha: 0),
            spreadRadius: components.searchFieldFocusRing,
          ),
        ],
      ),
      child: Semantics(
        label: 'Ano',
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _handleChanged,
          onSubmitted: _handleChanged,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(components.libraryYearDigits),
          ],
          style: styles.libraryFilter.copyWith(color: colors.ink),
          cursorColor: colors.accent,
          decoration: InputDecoration(
            hintText: 'Ano',
            hintStyle: styles.libraryFilter.copyWith(color: colors.inkSecondary),
            isCollapsed: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: components.libraryFilterPaddingStart - components.libraryFilterBorder,
            ),
          ),
        ),
      ),
    );
  }
}
