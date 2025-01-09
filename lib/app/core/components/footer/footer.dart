import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colors.orange,
      padding: EdgeInsets.all(AppTheme.dimensions.space.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Contact Information
          Text(
            'Faculdade de Educação - Sala 1G156 - UFU - Av. João Naves de Ávila, 2121 - B. Santa Mônica - Uberlândia/MG\n34 3239-4163 | 34 3239-4212 | contato@observatoriogeo.historia.net.br',
            textAlign: TextAlign.center,
            style: AppTheme.typography.body.medium.copyWith(
              color: AppTheme.colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: AppTheme.colors.white, thickness: 1),
          const SizedBox(height: 20),

          Text(
            'Observatório do Ensino de História e Geografia | 2024 | Conteúdo sob licença Creative Commons 4.0 Internacional',
            textAlign: TextAlign.center,
            style: AppTheme.typography.body.medium.copyWith(
              color: AppTheme.colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
