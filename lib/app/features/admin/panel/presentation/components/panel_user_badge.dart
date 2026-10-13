import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/labels/user_role_label.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelUserBadge extends StatelessWidget {
  const PanelUserBadge({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final showText = breakpoint == Breakpoint.desktop;
    final showDivider = breakpoint != Breakpoint.mobile;
    final role = user.role.label;

    final avatar = SizedBox.square(
      dimension: components.panelAvatar,
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.accentSoft, shape: BoxShape.circle),
        child: Center(
          child: Text(
            initialsOf(user.name),
            maxLines: 1,
            // O círculo tem tamanho fixo; ampliar as iniciais as faria vazar.
            textScaler: TextScaler.noScaling,
            style: styles.panelAvatarInitials.copyWith(color: colors.accentStrong),
          ),
        ),
      ),
    );

    return Semantics(
      label: '${user.name}, $role',
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.only(left: showDivider ? components.panelUserDividerGap : 0),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  left: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            avatar,
            if (showText) ...[
              SizedBox(width: components.panelUserGap),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.panelUserName.copyWith(color: colors.ink),
                    ),
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.panelUserRole.copyWith(color: colors.inkSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
