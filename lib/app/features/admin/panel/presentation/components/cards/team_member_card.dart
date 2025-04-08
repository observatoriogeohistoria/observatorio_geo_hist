import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({
    required this.member,
    required this.index,
    required this.onDelete,
    required this.onEdit,
    required this.canEdit,
    super.key,
  });

  final TeamMemberModel member;
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
                    text: member.name,
                    color: AppTheme.colors.darkGray,
                  ),
                  AppBody.big(
                    text: member.role,
                    color: AppTheme.colors.gray,
                  ),
                  if (member.lattesUrl?.isNotEmpty ?? false) ...[
                    SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                    AppBody.medium(
                      text: member.lattesUrl!,
                      color: AppTheme.colors.lightOrange,
                    ),
                  ]
                ],
              ),
            ),
            if (canEdit) ...[
              SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppIconButton(
                    icon: Icons.edit,
                    color: AppTheme.colors.orange,
                    onPressed: onEdit,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppIconButton(
                    icon: Icons.delete,
                    color: AppTheme.colors.red,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
