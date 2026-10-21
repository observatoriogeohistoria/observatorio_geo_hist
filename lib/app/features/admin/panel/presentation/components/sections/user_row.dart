import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_role.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_row.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_row_leading.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/labels/user_role_label.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class UserRow extends StatelessWidget {
  const UserRow({
    required this.user,
    required this.canEdit,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final UserModel user;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final iconSize = AppTheme.dimensions.components.panelActionIcon;

    return PanelListRow(
      leading: PanelAvatar(name: user.name),
      title: user.name,
      meta: user.email,
      badges: [
        StatusBadge(
          user.role.label,
          tone: user.role == UserRole.admin ? StatusTone.accent : StatusTone.neutral,
        ),
        if (user.isDeleted) const StatusBadge('Removido', tone: StatusTone.error),
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
