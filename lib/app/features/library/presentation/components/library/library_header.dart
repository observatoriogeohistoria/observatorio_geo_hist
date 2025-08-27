import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryHeader extends StatelessWidget {
  const LibraryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (isMobile ? 0.3 : 0.5),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.huge.verticalSpacing,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('${AppAssets.images}/library.webp'),
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: AppHeadline.big(
          text: 'Biblioteca',
          color: AppTheme.colors.white,
        ),
      ),
    );
  }
}
