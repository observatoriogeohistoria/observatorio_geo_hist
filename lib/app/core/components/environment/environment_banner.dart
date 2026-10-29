import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppEnvironment.current.isProd) return const SizedBox.shrink();

    // The banner sits outside the pages, with no Material above; without one the text gets the error underline.
    return Material(
      color: AppTheme.colors.accent,
      child: SizedBox(
        height: AppTheme.dimensions.components.environmentBannerHeight,
        child: Center(
          child: Text(
            'Ambiente de testes',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTheme.typography.of(context).label.copyWith(color: AppTheme.colors.page),
          ),
        ),
      ),
    );
  }
}
