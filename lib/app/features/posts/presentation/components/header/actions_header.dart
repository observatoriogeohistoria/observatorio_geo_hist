import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ActionsHeader extends StatelessWidget {
  const ActionsHeader({
    required this.category,
    required this.searchText,
    required this.onTextChanged,
    super.key,
  });

  final CategoryModel category;
  final String? searchText;

  final void Function(String) onTextChanged;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController(text: searchText);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.huge.verticalSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: category.title,
              style: AppTheme.typography.headline.big.copyWith(
                color: AppTheme.colors.orange,
              ),
              children: [
                TextSpan(
                  text: ' | ',
                  style: AppTheme.typography.headline.big.copyWith(
                    color: AppTheme.colors.gray,
                  ),
                ),
                TextSpan(
                  text: category.areas.first.portuguese,
                  style: AppTheme.typography.headline.big.copyWith(
                    color: AppTheme.colors.orange,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
          AppTextField(
            controller: textController,
            hintText: 'Buscar por título',
            onChanged: onTextChanged,
            useDebounce: true,
          ),
        ],
      ),
    );
  }
}
