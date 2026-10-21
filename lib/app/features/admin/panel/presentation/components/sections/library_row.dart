import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_row.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_row_leading.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryRow extends StatelessWidget {
  const LibraryRow({
    required this.document,
    required this.canEdit,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final LibraryDocumentModel document;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final iconSize = AppTheme.dimensions.components.panelActionIcon;
    final categories = document.categories.length;
    final type = document.type;
    final year = document.year;

    return PanelListRow(
      leading: const PanelLeadIcon(icon: Icons.description_outlined),
      title: document.title,
      meta: [
        document.author.trim(),
        document.institution?.trim() ?? '',
        if (year != null) '$year',
        if (categories > 0) categories == 1 ? '1 categoria' : '$categories categorias',
      ].where((part) => part.isNotEmpty).join(' · '),
      badges: [
        if (type != null) StatusBadge(type.value, tone: StatusTone.neutral),
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
            tooltip: 'Excluir: pede confirmação antes de apagar',
            icon: Icons.delete_outline,
            color: colors.error,
            size: iconSize,
            onPressed: onDelete,
          ),
        ],
      ],
    );
  }
}
