import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class BackToSiteLink extends StatefulWidget {
  const BackToSiteLink({super.key});

  @override
  State<BackToSiteLink> createState() => _BackToSiteLinkState();
}

class _BackToSiteLinkState extends State<BackToSiteLink> {
  static const _text = 'Voltar ao site';

  bool _hovered = false;

  void _go() => context.go(AppRoutes.root);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final color = _hovered ? colors.accentStrong : colors.inkSecondary;
    final style = AppTheme.typography.of(context).badge.copyWith(color: color);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    return Semantics(
      link: true,
      label: _text,
      linkUrl: Uri.parse(AppRoutes.root),
      onTap: _go,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: _go,
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            mouseCursor: SystemMouseCursors.click,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back,
                  size: style.fontSize! * components.buttonIconScale,
                  color: color,
                ),
                SizedBox(width: components.loginBackLinkGap),
                Flexible(child: Text(_text, style: style)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
