import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    super.key,
  });

  final IconData icon;
  final void Function() onTap;

  /// Nome acessível do botão (também aparece ao passar o mouse).
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    bool isMobile = ScreenUtils.isMobile(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radius.small);

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        // Repete a ação do InkWell (excluído da semântica) para o leitor de tela ativar o botão.
        onTap: onTap,
        excludeSemantics: true,
        child: AppFocusRing(
          borderRadius: radius,
          child: Material(
            color: AppTheme.colors.orange.withValues(alpha: 0.35),
            borderRadius: radius,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              mouseCursor: SystemMouseCursors.click,
              child: Container(
                alignment: Alignment.center,
                padding: isMobile
                    ? EdgeInsets.zero
                    : EdgeInsets.all(AppTheme.dimensions.space.small.scale),
                child: Center(
                  child: Icon(icon, color: AppTheme.colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
