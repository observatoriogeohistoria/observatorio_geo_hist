import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/panel_field_decoration.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppMultiSelectField<T> extends StatelessWidget {
  const AppMultiSelectField({
    required this.items,
    required this.selectedItems,
    required this.itemToString,
    required this.onChanged,
    this.isSingleSelect = false,
    super.key,
  });

  final List<T> items;
  final List<T> selectedItems;
  final String Function(T) itemToString;
  final void Function(List<T>) onChanged;
  final bool isSingleSelect;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final gap = AppTheme.dimensions.spacing.s8;
    final borderWidth = AppTheme.dimensions.components.formFieldBorder;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        ...items.map(
          (item) {
            final isSelected = selectedItems.contains(item);

            return IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isSelected,
                    activeColor: colors.accent,
                    checkColor: colors.page,
                    side: WidgetStateBorderSide.resolveWith(
                      (states) => BorderSide(
                        color: states.contains(WidgetState.selected)
                            ? colors.accent
                            : colors.fieldBorder,
                        width: borderWidth,
                      ),
                    ),
                    onChanged: (checked) {
                      final newSelected = List<T>.from(selectedItems);

                      if (checked == true) {
                        if (isSingleSelect) newSelected.clear();
                        newSelected.add(item);
                      } else {
                        isSingleSelect ? newSelected.clear() : newSelected.remove(item);
                      }

                      onChanged(newSelected);
                    },
                  ),
                  Flexible(
                    child: Text(
                      itemToString(item),
                      style: PanelFieldDecoration.textStyle(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
