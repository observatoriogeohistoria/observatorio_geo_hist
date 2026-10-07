import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    required this.user,
    required this.index,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final UserModel user;
  final int index;
  final void Function() onDelete;
  final void Function() onEdit;

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
                  Text(user.name, style: typography.h3.copyWith(color: colors.ink)),
                  SizedBox(height: components.panelCardTextGap),
                  Text(
                    user.email,
                    style: typography.regular.copyWith(color: colors.inkSecondary),
                  ),
                  SizedBox(height: dimensions.spacing.s12),
                  user.isDeleted
                      ? const StatusBadge('Usuário inativo', tone: StatusTone.error)
                      : const StatusBadge('Usuário ativo', tone: StatusTone.success),
                ],
              ),
            ),
            SizedBox(width: dimensions.spacing.s16),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppIconButton(
                  tooltip: 'Editar usuário',
                  color: colors.accent,
                  icon: Icons.edit,
                  onPressed: onEdit,
                ),
                SizedBox(height: components.panelCardActionsGap),
                AppIconButton(
                  tooltip: 'Excluir usuário',
                  color: colors.error,
                  icon: Icons.delete,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
