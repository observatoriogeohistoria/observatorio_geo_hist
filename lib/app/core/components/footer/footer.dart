import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = DeviceUtils.isTablet(context);
    bool isDesktop = DeviceUtils.isDesktop(context);

    return Container(
      color: AppTheme.colors.orange,
      padding: EdgeInsets.symmetric(
        horizontal: (isDesktop
                ? AppTheme.dimensions.space.gigantic
                : (isTablet ? AppTheme.dimensions.space.massive : AppTheme.dimensions.space.large))
            .horizontalSpacing,
        vertical: AppTheme.dimensions.space.huge.verticalSpacing,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBody.medium(
            text:
                'Faculdade de Educação - Sala 1G156 - UFU - Av. João Naves de Ávila, 2121 - B. Santa Mônica - Uberlândia/MG\n34 3239-4163 | 34 3239-4212 | contato@observatoriogeo.historia.net.br',
            textAlign: TextAlign.center,
            color: AppTheme.colors.white,
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          AppDivider(color: AppTheme.colors.white),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          AppBody.medium(
            text:
                'Observatório do Ensino de História e Geografia | 2024 | Conteúdo sob licença Creative Commons 4.0 Internacional',
            textAlign: TextAlign.center,
            color: AppTheme.colors.white,
          ),
        ],
      ),
    );
  }
}
