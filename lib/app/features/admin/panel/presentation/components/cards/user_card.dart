import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    required this.user,
    required this.onDelete,
    super.key,
  });

  final UserModel user;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme(context).dimensions.space.medium,
        vertical: AppTheme(context).dimensions.space.small,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTitle.big(
                text: user.name,
                color: AppTheme(context).colors.darkGray,
              ),
              SizedBox(height: AppTheme(context).dimensions.space.small),
              AppBody.big(
                text: user.email,
                color: AppTheme(context).colors.gray,
              ),
              SizedBox(height: AppTheme(context).dimensions.space.medium),
              AppLabel.small(
                text: user.isDeleted ? 'Usuário excluído' : 'Usuário ativo',
                color:
                    user.isDeleted ? AppTheme(context).colors.red : AppTheme(context).colors.green,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: AppTheme(context).colors.red,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
