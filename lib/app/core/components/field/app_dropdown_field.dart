import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppDropdownField<T> extends StatefulWidget {
  const AppDropdownField({
    required this.items,
    required this.itemToString,
    required this.hintText,
    this.value,
    this.onChanged,
    this.validator,
    this.isDisabled = false,
    super.key,
  });

  final List<T> items;
  final String Function(T) itemToString;
  final T? value;
  final void Function(String?)? onChanged;

  final String hintText;
  final String? Function(String?)? validator;

  final bool isDisabled;

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value != null ? widget.itemToString(widget.value as T) : null;
  }

  @override
  void didUpdateWidget(covariant AppDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      selectedValue = widget.value != null ? widget.itemToString(widget.value as T) : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DropdownButtonFormField<String>(
        hint: AppLabel.medium(
          text: widget.hintText,
          color: AppTheme(context).colors.gray,
        ),
        items: widget.items
            .map(
              (item) => DropdownMenuItem<String>(
                value: widget.itemToString(item),
                child: AppLabel.medium(
                  text: widget.itemToString(item),
                  color: AppTheme(context).colors.darkGray,
                ),
              ),
            )
            .toList(),
        value: selectedValue,
        onChanged: widget.isDisabled
            ? null
            : (value) {
                setState(() => selectedValue = value);
                widget.onChanged?.call(value);
              },
        validator: widget.validator,
        borderRadius: BorderRadius.circular(AppTheme(context).dimensions.radius.medium),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppTheme(context).colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppTheme(context).dimensions.space.small,
            vertical: AppTheme(context).dimensions.space.medium,
          ),
          enabledBorder: _buildBorder(AppTheme(context).colors.gray),
          focusedBorder: _buildBorder(AppTheme(context).colors.orange),
          focusedErrorBorder: _buildBorder(AppTheme(context).colors.red),
          disabledBorder: _buildBorder(AppTheme(context).colors.gray),
          errorBorder: _buildBorder(AppTheme(context).colors.red),
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme(context).dimensions.radius.medium),
        borderSide: BorderSide(
          width: AppTheme(context).dimensions.stroke.small,
          color: color,
        ),
      );
}
