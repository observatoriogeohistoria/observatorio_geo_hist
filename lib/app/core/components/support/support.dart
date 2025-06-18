import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/text/common_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/partners_images.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceUtils.isMobile(context);
    bool isTablet = DeviceUtils.isTablet(context);

    const images = [
      PartnersImages.ufu,
      PartnersImages.fapemig,
      PartnersImages.cnpq,
      PartnersImages.capes,
    ];

    return Container(
      color: AppTheme.colors.lighterGray,
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.massive.verticalSpacing,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon('instagram', AppStrings.instagram),
              _buildIcon('facebook', AppStrings.facebook),
              _buildIcon('youtube', AppStrings.youtube),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppTheme.dimensions.space.large.verticalSpacing,
            ),
            child: const AppDivider(),
          ),
          CommonTitle(
            title: 'APOIO',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppTheme.dimensions.space.medium.horizontalSpacing,
            runSpacing: AppTheme.dimensions.space.medium.verticalSpacing,
            children: [
              AlignedGridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
                crossAxisSpacing: AppTheme.dimensions.space.medium.horizontalSpacing,
                mainAxisSpacing: AppTheme.dimensions.space.medium.verticalSpacing,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return AppCard(
                    padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
                    child: Image.asset(images[index].path),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(
    String name,
    String link,
  ) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => openUrl(link),
      mouseCursor: SystemMouseCursors.click,
      child: Padding(
        padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
        child: Image.asset(
          '${AppAssets.icons}/$name.png',
          width: 40.scale,
          height: 40.scale,
        ),
      ),
    );
  }
}
