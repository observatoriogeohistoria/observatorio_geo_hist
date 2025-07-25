import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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
    return Wrap(
      spacing: AppTheme.dimensions.space.small.horizontalSpacing,
      runSpacing: AppTheme.dimensions.space.small.verticalSpacing,
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
                    activeColor: AppTheme.colors.orange,
                    checkColor: AppTheme.colors.white,
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
                    child: AppLabel.big(
                      text: itemToString(item),
                      color: AppTheme.colors.darkGray,
                      notSelectable: true,
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
