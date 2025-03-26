import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/partners_images.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Partners extends StatelessWidget {
  const Partners({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceUtils.isMobile(context);
    bool isTablet = DeviceUtils.isTablet(context);

    const images = PartnersImages.values;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.massive.verticalSpacing,
      ),
      child: Column(
        children: [
          TitleWidget(
            title: 'PARCEIROS',
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
}
