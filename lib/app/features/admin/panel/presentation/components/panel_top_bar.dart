import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_button_base.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/logo/app_logo.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_user_badge.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelTopBar extends StatelessWidget {
  const PanelTopBar({
    required this.user,
    required this.isMenuOpen,
    required this.onMenuPressed,
    required this.menuFocusNode,
    super.key,
  });

  final UserModel? user;
  final bool isMenuOpen;
  final VoidCallback onMenuPressed;
  final FocusNode menuFocusNode;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final isMobile = breakpoint == Breakpoint.mobile;
    final gap = components.panelTopBarGap(breakpoint);
    final user = this.user;

    return Container(
      height: components.panelTopBarHeight,
      padding: EdgeInsetsDirectional.only(
        start: components.panelTopBarPaddingStart(breakpoint),
        end: components.panelTopBarPaddingEnd(breakpoint),
      ),
      decoration: BoxDecoration(
        color: colors.page,
        border: Border(
          bottom: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
      ),
      child: Row(
        children: [
          if (breakpoint != Breakpoint.desktop) ...[
            AppIconButton(
              icon: isMenuOpen ? Icons.close : Icons.menu,
              color: colors.ink,
              tooltip: isMenuOpen ? 'Fechar menu do painel' : 'Abrir menu do painel',
              focusNode: menuFocusNode,
              onPressed: onMenuPressed,
            ),
            SizedBox(width: gap),
          ],
          AppLogo(
            subtitle: 'Painel',
            destination: AppRoutes.panelPosts(PostType.article.value),
            showName: !isMobile,
            semanticLabel: 'Painel do Observatório',
          ),
          SizedBox(width: gap),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isMobile) ...[
                  AppButtonBase(
                    kind: AppButtonKind.ghost,
                    size: ButtonSize.small,
                    text: 'Ver site',
                    trailingIcon: Icons.open_in_new,
                    onPressed: () => openUrl(Uri.base.resolve(AppRoutes.root).toString()),
                  ),
                  SizedBox(width: components.panelTopBarActionsGap),
                ],
                if (user != null) Flexible(child: PanelUserBadge(user: user)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
