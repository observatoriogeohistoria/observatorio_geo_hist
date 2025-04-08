import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    required this.index,
    required this.onDelete,
    required this.onEdit,
    required this.canEdit,
    super.key,
  });

  final CategoryModel category;
  final int index;
  final void Function() onDelete;
  final void Function() onEdit;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLabel.small(
                    text: '$index',
                    color: AppTheme.colors.gray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
                  AppTitle.big(
                    text: category.title,
                    color: AppTheme.colors.darkGray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppBody.big(
                    text: category.areas.map((area) => area.portuguese).join(' | '),
                    color: AppTheme.colors.gray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppLabel.medium(
                    text: '${category.numberOfPosts} Posts',
                    color: AppTheme.colors.orange,
                  ),
                ],
              ),
            ),
            if (canEdit) ...[
              SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppIconButton(
                    icon: Icons.edit,
                    color: AppTheme.colors.orange,
                    onPressed: onEdit,
                  ),
                  if (category.numberOfPosts == 0) ...[
                    SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                    AppIconButton(
                      icon: Icons.delete,
                      color: AppTheme.colors.red,
                      onPressed: onDelete,
                    ),
                  ]
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
