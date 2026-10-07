import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/field/panel_field_decoration.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.controller,
    this.labelText,
    this.hintText,
    this.minLines = 1,
    this.maxLines = 3,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.obscureText = false,
    this.isDisabled = false,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.scrollPadding = EdgeInsets.zero,
    this.suffixIcon,
    this.useDebounce = false,
    this.debounceDuration = const Duration(milliseconds: 500),
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;

  final int? minLines;
  final int? maxLines;

  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  final bool obscureText;
  final bool isDisabled;

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  final FocusNode? focusNode;
  final EdgeInsets scrollPadding;
  final Widget? suffixIcon;

  final bool useDebounce;
  final Duration debounceDuration;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final _focusNode = widget.focusNode ?? FocusNode();

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minTapTarget = AppTheme.dimensions.components.minTapTarget;

    return Padding(
      padding: EdgeInsets.only(top: AppTheme.dimensions.components.panelFieldGap),
      child: TextFormField(
        onChanged: widget.useDebounce ? _onChangedDebounced : widget.onChanged,
        controller: widget.controller,
        focusNode: _focusNode,
        enabled: !widget.isDisabled,
        readOnly: widget.isDisabled,
        scrollPadding: widget.scrollPadding,
        expands: widget.minLines == null && widget.maxLines == null,
        minLines: widget.minLines,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        onTapOutside: (_) => _focusNode.unfocus(),
        obscureText: widget.obscureText,
        validator: widget.validator,
        style: PanelFieldDecoration.textStyle(context),
        cursorColor: AppTheme.colors.accent,
        textAlignVertical: TextAlignVertical.top,
        decoration: PanelFieldDecoration.build(
          context,
          alignLabelWithHint: true,
          labelText: widget.labelText,
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon == null
              ? null
              : Padding(
                  padding: EdgeInsetsDirectional.only(end: AppTheme.dimensions.spacing.s4),
                  child: widget.suffixIcon,
                ),
          suffixIconConstraints: BoxConstraints(minHeight: minTapTarget, minWidth: minTapTarget),
        ),
      ),
    );
  }

  void _onChangedDebounced(String value) {
    if (widget.onChanged == null) return;

    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged!(value);
    });
  }
}
