import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_row.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_row_leading.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    required this.category,
    required this.canEdit,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final CategoryModel category;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  IconData get _icon {
    final areas = category.areas;
    if (areas.length != 1) return Icons.layers_outlined;
    return areas.first == PostsAreas.history ? Icons.hourglass_empty : Icons.public;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final iconSize = AppTheme.dimensions.components.panelActionIcon;
    final count = category.numberOfPosts;
    final hasPosts = count > 0;

    return PanelListRow(
      leading: PanelLeadIcon(icon: _icon),
      title: category.title,
      meta: [
        category.areas.map((area) => area.portuguese).join(' e '),
        count == 1 ? '1 publicação' : '$count publicações',
        category.description.trim(),
      ].where((part) => part.isNotEmpty).join(' · '),
      badges: [
        if (category.hasCollaborateOption)
          const StatusBadge('Aceita colaboração', tone: StatusTone.success),
      ],
      actions: [
        if (canEdit) ...[
          AppIconButton(
            label: 'Editar',
            tooltip: 'Editar: abre o formulário ao lado',
            icon: Icons.edit_outlined,
            color: colors.inkSecondary,
            size: iconSize,
            onPressed: onEdit,
          ),
          AppIconButton(
            label: 'Excluir',
            tooltip: hasPosts
                ? 'Só dá para excluir categoria sem publicações. Esta tem $count.'
                : 'Excluir: pede confirmação antes de apagar',
            icon: Icons.delete_outline,
            color: colors.error,
            size: iconSize,
            isDisabled: hasPosts,
            onPressed: onDelete,
          ),
        ],
      ],
    );
  }
}
