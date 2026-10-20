import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Diálogos e painéis laterais abrem em outra rota, fora da área da página, e precisam da sua.
class AppSelectionArea extends StatelessWidget {
  const AppSelectionArea({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultSelectionStyle.merge(
      selectionColor: AppTheme.colors.textSelection,
      child: SelectionArea(child: child),
    );
  }
}
