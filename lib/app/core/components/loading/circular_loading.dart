import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppTheme.dimensions.components.loadingIndicatorSize;

    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(color: AppTheme.colors.accent),
      ),
    );
  }
}
