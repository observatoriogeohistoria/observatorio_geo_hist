import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
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
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final typography = AppTheme.typography.of(context);

    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: components.panelCardPaddingH,
        vertical: components.panelCardPaddingV,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$index', style: typography.label.copyWith(color: colors.inkSecondary)),
                  SizedBox(height: components.panelCardTextGap),
                  Text(category.title, style: typography.h3.copyWith(color: colors.ink)),
                  SizedBox(height: components.panelCardTextGap),
                  Text(
                    category.areas.map((area) => area.portuguese).join(' | '),
                    style: typography.regular.copyWith(color: colors.inkSecondary),
                  ),
                  SizedBox(height: dimensions.spacing.s8),
                  Text(
                    '${category.numberOfPosts} Posts',
                    style: typography.formLabel.copyWith(color: colors.accent),
                  ),
                ],
              ),
            ),
            if (canEdit) ...[
              SizedBox(width: dimensions.spacing.s16),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppIconButton(
                    tooltip: 'Editar categoria',
                    icon: Icons.edit,
                    color: colors.accent,
                    onPressed: onEdit,
                  ),
                  if (category.numberOfPosts == 0) ...[
                    SizedBox(height: components.panelCardActionsGap),
                    AppIconButton(
                      tooltip: 'Excluir categoria',
                      icon: Icons.delete,
                      color: colors.error,
                      onPressed: onDelete,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
