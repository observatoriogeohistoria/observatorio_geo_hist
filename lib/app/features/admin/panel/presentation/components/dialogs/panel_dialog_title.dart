import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelDialogTitle extends StatelessWidget {
  const PanelDialogTitle({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: AppTheme.typography.of(context).h3.copyWith(color: AppTheme.colors.ink),
      ),
    );
  }
}
