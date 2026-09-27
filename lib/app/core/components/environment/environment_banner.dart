import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Faixa fixa no topo do site avisando que o ambiente atual é de testes.
/// Não aparece em produção. Altura fixa em [ComponentSizes.environmentBannerHeight],
/// para o [AppWidget] descontar do espaço disponível para o resto do app.
class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppEnvironment.current.isProd) return const SizedBox.shrink();

    return ColoredBox(
      color: AppTheme.colors.accent,
      child: SizedBox(
        height: AppTheme.dimensions.components.environmentBannerHeight,
        child: Center(
          child: Text(
            'Ambiente de Testes',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTheme.typography.label.medium.copyWith(
              color: AppTheme.colors.page,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
