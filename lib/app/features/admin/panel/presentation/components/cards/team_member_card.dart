import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    required this.member,
    required this.index,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final TeamMemberModel member;
  final int index;
  final void Function() onDelete;
  final void Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme(context).dimensions.space.medium,
        vertical: AppTheme(context).dimensions.space.small,
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
                  AppLabel.small(
                    text: '$index',
                    color: AppTheme(context).colors.gray,
                  ),
                  SizedBox(height: AppTheme(context).dimensions.space.xsmall),
                  AppTitle.big(
                    text: member.name,
                    color: AppTheme(context).colors.darkGray,
                  ),
                  SizedBox(height: AppTheme(context).dimensions.space.small),
                  AppBody.big(
                    text: member.role,
                    color: AppTheme(context).colors.gray,
                  ),
                  if (member.lattesUrl?.isNotEmpty ?? false) ...[
                    SizedBox(height: AppTheme(context).dimensions.space.small),
                    AppBody.small(
                      text: member.lattesUrl!,
                      color: AppTheme(context).colors.gray,
                    ),
                  ]
                ],
              ),
            ),
            SizedBox(width: AppTheme(context).dimensions.space.medium),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: AppTheme(context).colors.orange),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppTheme(context).colors.red),
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
