import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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
    return Container(
      margin: EdgeInsets.only(top: AppTheme.dimensions.space.small.verticalSpacing),
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
        cursorColor: AppTheme.colors.darkGray,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          suffixIcon: widget.suffixIcon == null
              ? null
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
                  child: widget.suffixIcon,
                ),
          suffixIconConstraints: const BoxConstraints(
            minHeight: 32,
            minWidth: 32,
          ),
          labelText: widget.labelText,
          labelStyle: AppTheme.typography.body.medium.copyWith(
            color: AppTheme.colors.gray,
          ),
          hintText: widget.hintText,
          hintStyle: AppTheme.typography.body.medium.copyWith(
            color: AppTheme.colors.gray,
          ),
          filled: true,
          fillColor: AppTheme.colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppTheme.dimensions.space.small,
            vertical: AppTheme.dimensions.space.medium,
          ),
          enabledBorder: _buildBorder(AppTheme.colors.gray),
          focusedBorder: _buildBorder(AppTheme.colors.orange),
          focusedErrorBorder: _buildBorder(AppTheme.colors.red),
          disabledBorder: _buildBorder(AppTheme.colors.gray),
          errorBorder: _buildBorder(AppTheme.colors.red),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
      borderSide: BorderSide(
        width: AppTheme.dimensions.stroke.small,
        color: color,
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
