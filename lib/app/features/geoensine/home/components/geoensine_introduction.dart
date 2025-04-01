import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/geoensine/home/components/geoensine_carousel.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class GeoensineIntroduction extends StatelessWidget {
  const GeoensineIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceUtils.isMobile(context);

    double width = MediaQuery.of(context).size.width -
        2 * DeviceUtils.getPageHorizontalPadding(context) -
        AppTheme.dimensions.space.massive.horizontalSpacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.getPageHorizontalPadding(context),
        vertical: !isMobile ? AppTheme.dimensions.space.massive.verticalSpacing : 0,
      ),
      child: isMobile
          ? _mobileChild()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    width: width,
                    child: text,
                  ),
                ),
                SizedBox(width: AppTheme.dimensions.space.massive.horizontalSpacing),
                SizedBox(
                  width: width / 2,
                  child: const GeoensineCarousel(),
                ),
              ],
            ),
    );
  }

  Widget _mobileChild() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: AppTheme.dimensions.space.massive.verticalSpacing),
        text,
        SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
        const GeoensineCarousel(),
      ],
    );
  }

  Widget get text => AppBody.medium(
        text:
            'O GeoEnsine é um projeto atrelado ao Observatório do Ensino de História e Geografia que surge a partir de resultados de uma pesquisa de doutorado pela Universidade Federal de Uberlândia (UFU) na área de curadoria de conteúdos digitais e formação colaborativa de professores de Geografia. Procuramos analisar quais são as necessidades formativas destes profissionais e criamos este espaço, que conta com materiais curados resultantes de uma pesquisa criteriosa de conteúdos em diferentes formatos, direcionados à formação de professores na área, somados a um diferencial: uma proposta colaborativa, onde os docentes podem sugerir materiais e compartilhar suas narrativas e experiências pedagógicas.',
        color: AppTheme.colors.darkGray,
        textAlign: TextAlign.justify,
        notSelectable: true,
      );
}
