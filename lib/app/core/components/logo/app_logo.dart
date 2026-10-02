import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final spacing = AppTheme.dimensions.spacing;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r10);
    final showSubtitle = ScreenUtils.breakpointOf(context) != Breakpoint.mobile;

    return Semantics(
      link: true,
      label: 'Observatório do Ensino de História e Geografia, início',
      linkUrl: Uri.parse(AppRoutes.root),
      onTap: () => context.go(AppRoutes.root),
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        color: onDark ? colors.footerHighlight : null,
        child: InkWell(
          borderRadius: radius,
          onTap: () => context.go(AppRoutes.root),
          mouseCursor: SystemMouseCursors.click,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                '${AppAssets.images}/logo.svg',
                width: components.logoMark,
                height: components.logoMark,
              ),
              SizedBox(width: spacing.s12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Observatório',
                    style: styles.h3.copyWith(
                      fontSize: components.logoName,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: components.logoName * -0.03,
                      color: onDark ? colors.white : colors.ink,
                    ),
                  ),
                  if (showSubtitle)
                    Text(
                      'Ensino de História e Geografia',
                      style: styles.small.copyWith(
                        fontSize: components.logoSubtitle,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                        color: onDark ? colors.footerText : colors.inkSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
