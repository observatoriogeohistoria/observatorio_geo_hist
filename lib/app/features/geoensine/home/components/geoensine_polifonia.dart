import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_rounded_image.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class GeoensinePolifonia extends StatelessWidget {
  const GeoensinePolifonia({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceUtils.isMobile(context);
    bool isSmallMobile = DeviceUtils.isSmallMobile(context);
    bool isTablet = DeviceUtils.isTablet(context);

    List<Map<String, String>> images = [
      {
        'image': 'capa_por_que_colagens',
        'text': 'Por que colagens?',
      },
      {
        'image': 'capa_geoensine_instagram',
        'text': 'GeoEnsine no Instagram',
      },
      {
        'image': 'capa_docentes_curadores',
        'text': 'Docentes Curadores',
      },
      {
        'image': 'capa_geoensine_tese',
        'text': 'GeoEnsine em Tese',
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.massive.verticalSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeadline.big(
            text: 'Polifonia',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          AlignedGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: isSmallMobile
                ? 1
                : isMobile
                    ? 2
                    : (isTablet ? 2 : 4),
            crossAxisSpacing: AppTheme.dimensions.space.medium.horizontalSpacing,
            mainAxisSpacing: AppTheme.dimensions.space.medium.verticalSpacing,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return _buildCard(images[index]['image']!, images[index]['text']!);
            },
          )
        ],
      ),
    );
  }

  Widget _buildCard(
    String image,
    String text,
  ) {
    return AppCard(
      padding: EdgeInsets.zero,
      isHover: true,
      child: Column(
        children: [
          AppRoundedImageAsset(
            path: '${AppAssets.geoensine}/$image.png',
            height: null,
            radius: BorderRadius.only(
              topLeft: Radius.circular(AppTheme.dimensions.radius.large),
              topRight: Radius.circular(AppTheme.dimensions.radius.large),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppTheme.dimensions.space.small.verticalSpacing,
            ),
            child: AppTitle.medium(
              text: text,
              textAlign: TextAlign.center,
              color: AppTheme.colors.darkGray,
            ),
          ),
        ],
      ),
    );
  }
}
