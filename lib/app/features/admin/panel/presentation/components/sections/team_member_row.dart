import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_row.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_row_leading.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class TeamMemberRow extends StatelessWidget {
  const TeamMemberRow({
    required this.member,
    required this.canEdit,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final TeamMemberModel member;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final iconSize = AppTheme.dimensions.components.panelActionIcon;
    // Quem tem descrição ganha página própria no site.
    final hasPage = member.description?.trim().isNotEmpty ?? false;
    final hasLattes = member.lattesUrl?.trim().isNotEmpty ?? false;

    return PanelListRow(
      leading: PanelAvatar(name: member.name, imageUrl: member.image?.url),
      title: member.name,
      meta: [member.role.trim(), if (hasLattes) 'Currículo Lattes']
          .where((part) => part.isNotEmpty)
          .join(' · '),
      badges: [
        hasPage
            ? const StatusBadge('Com página', tone: StatusTone.success)
            : const StatusBadge('Sem página', tone: StatusTone.neutral),
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
            tooltip: 'Excluir: pede confirmação antes de remover',
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
