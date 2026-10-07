import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/panel_field_decoration.dart';
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
    this.canUnselect = false,
    super.key,
  });

  final List<T> items;
  final String Function(T) itemToString;
  final T? value;
  final void Function(String?)? onChanged;

  final String hintText;
  final String? Function(String?)? validator;

  final bool isDisabled;
  final bool canUnselect;

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  String? _selectedValue;
  List<T?> _items = [];

  @override
  void initState() {
    super.initState();

    _setSelectedValue();
    _setItems();
  }

  @override
  void didUpdateWidget(covariant AppDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) _setSelectedValue();
    if (widget.items != oldWidget.items) _setItems();
  }

  void _setSelectedValue() {
    _selectedValue = widget.value != null ? widget.itemToString(widget.value as T) : null;
  }

  void _setItems() {
    _items = widget.items.map((item) => item).toList();
    if (widget.canUnselect) _items = [null, ..._items];
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = PanelFieldDecoration.textStyle(context);
    final placeholder = Text(
      widget.hintText,
      overflow: TextOverflow.ellipsis,
      style: PanelFieldDecoration.secondaryStyle(context),
    );

    return DropdownButtonFormField<String>(
      isDense: true,
      isExpanded: true,
      hint: placeholder,
      style: textStyle,
      iconEnabledColor: AppTheme.colors.inkSecondary,
      dropdownColor: AppTheme.colors.page,
      focusColor: AppTheme.colors.accentSoft,
      items: _items.map(
        (item) {
          if (item == null) {
            return DropdownMenuItem<String>(value: null, child: placeholder);
          }

          return DropdownMenuItem<String>(
            value: widget.itemToString(item),
            child: Text(
              widget.itemToString(item),
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          );
        },
      ).toList(),
      initialValue: _selectedValue,
      onChanged: widget.isDisabled
          ? null
          : (value) {
              setState(() => _selectedValue = value);
              widget.onChanged?.call(value);
            },
      validator: widget.validator,
      borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r10),
      decoration: PanelFieldDecoration.build(context),
    );
  }
}
