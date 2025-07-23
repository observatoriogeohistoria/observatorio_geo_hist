import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIcon('instagram', AppStrings.instagram),
        _buildIcon('facebook', AppStrings.facebook),
        _buildIcon('youtube', AppStrings.youtube),
      ],
    );
  }

  Widget _buildIcon(
    String name,
    String link,
  ) {
    return InkWell(
      customBorder: const CircleBorder(),
      hoverColor: AppTheme.colors.orange,
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
