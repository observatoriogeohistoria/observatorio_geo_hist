import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ToggleCollpaseButton extends StatelessWidget {
  const ToggleCollpaseButton({
    required this.onTap,
    required this.isCollapsed,
    required this.isMenu,
    super.key,
  });

  final VoidCallback onTap;
  final bool isCollapsed;

  /// No celular e no tablet a barra abre como menu, e o botão só a fecha.
  final bool isMenu;

  @override
  Widget build(BuildContext context) {
    final String tooltip;
    if (isMenu) {
      tooltip = 'Fechar menu';
    } else {
      tooltip = isCollapsed ? 'Expandir menu' : 'Recolher menu';
    }

    return Align(
      alignment: isCollapsed ? Alignment.center : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppTheme.dimensions.spacing.s8),
        child: AppIconButton(
          tooltip: tooltip,
          icon: isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
          color: AppTheme.colors.ink,
          size: AppTheme.dimensions.components.panelSidebarIcon,
          onPressed: onTap,
        ),
      ),
    );
  }
}
