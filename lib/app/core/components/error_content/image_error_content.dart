import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ImageErrorContent extends StatelessWidget {
  const ImageErrorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          size: 24.scale,
          color: AppTheme.colors.gray,
        ),
        SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
        AppTitle.medium(
          text: 'Erro ao carregar a imagem',
          color: AppTheme.colors.gray,
        ),
      ],
    );
  }
}
