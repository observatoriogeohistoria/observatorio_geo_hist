import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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
                    text: user.name,
                    color: AppTheme.colors.darkGray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppBody.big(
                    text: user.email,
                    color: AppTheme.colors.gray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppLabel.medium(
                    text: user.isDeleted ? 'Usuário inativo' : 'Usuário ativo',
                    color: user.isDeleted ? AppTheme.colors.red : AppTheme.colors.green,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppIconButton(
                  color: AppTheme.colors.orange,
                  icon: Icons.edit,
                  onPressed: onEdit,
                ),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                AppIconButton(
                  color: AppTheme.colors.red,
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
