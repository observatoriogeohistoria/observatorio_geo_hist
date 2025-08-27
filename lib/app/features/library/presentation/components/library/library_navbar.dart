import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/social_buttons.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryNavbar extends StatelessWidget {
  const LibraryNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = ScreenUtils.isMobile(context);

    return Container(
      height: isMobile ? MediaQuery.of(context).size.height * 0.075 : null,
      padding: EdgeInsets.symmetric(horizontal: ScreenUtils.getPageHorizontalPadding(context)),
      color: AppTheme.colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            '${AppAssets.images}/logo.webp',
            width: width * (isMobile ? 0.4 : 0.2),
            height: isMobile ? double.infinity : null,
          ),
          const SocialButtons(),
        ],
      ),
    );
  }
}
