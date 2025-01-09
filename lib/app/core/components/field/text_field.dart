import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.scrollPadding = EdgeInsets.zero,
    this.isDisabled = false,
    this.minLines = 1,
    this.maxLines = 3,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final bool isDisabled;
  final EdgeInsets scrollPadding;
  final int? minLines;
  final int? maxLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final _focusNode = widget.focusNode ?? FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: !widget.isDisabled,
      readOnly: widget.isDisabled,
      scrollPadding: widget.scrollPadding,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onTapOutside: (_) => _focusNode.unfocus(),
      decoration: InputDecoration(
        suffixIconConstraints: const BoxConstraints(
          minHeight: 32,
          minWidth: 32,
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
          borderSide: BorderSide(
            color: AppTheme.colors.gray,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
          borderSide: BorderSide(
            width: AppTheme.dimensions.stroke.small,
            color: AppTheme.colors.orange,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
          borderSide: BorderSide(
            color: AppTheme.colors.gray,
          ),
        ),
      ),
    );
  }
}
