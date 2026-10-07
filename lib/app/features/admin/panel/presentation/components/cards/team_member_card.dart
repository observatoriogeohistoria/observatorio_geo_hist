import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
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
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final typography = AppTheme.typography.of(context);
    final photoSize = components.panelMemberPhoto(ScreenUtils.breakpointOf(context));

    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: components.panelCardPaddingH,
        vertical: components.panelCardPaddingV,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (member.image?.url?.isNotEmpty ?? false) ...[
              Align(
                alignment: Alignment.center,
                child: AppNetworkImage(
                  imageUrl: member.image!.url!,
                  width: photoSize,
                  height: photoSize,
                  radius: dimensions.radii.r12,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: dimensions.spacing.s16),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$index', style: typography.label.copyWith(color: colors.inkSecondary)),
                  SizedBox(height: components.panelCardTextGap),
                  Text(member.name, style: typography.h3.copyWith(color: colors.ink)),
                  Text(
                    member.role,
                    style: typography.regular.copyWith(color: colors.inkSecondary),
                  ),
                  if (member.lattesUrl?.isNotEmpty ?? false) ...[
                    SizedBox(height: dimensions.spacing.s8),
                    Text(
                      member.lattesUrl!,
                      style: typography.small.copyWith(color: colors.accent),
                    ),
                  ],
                ],
              ),
            ),
            if (canEdit) ...[
              SizedBox(width: dimensions.spacing.s16),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppIconButton(
                    tooltip: 'Editar membro',
                    icon: Icons.edit,
                    color: colors.accent,
                    onPressed: onEdit,
                  ),
                  SizedBox(height: components.panelCardActionsGap),
                  AppIconButton(
                    tooltip: 'Excluir membro',
                    icon: Icons.delete,
                    color: colors.error,
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
