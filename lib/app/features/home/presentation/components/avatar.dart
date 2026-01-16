import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    required this.imageUrl,
    this.size = 150,
    super.key,
  });

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.scale,
      height: size.scale,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.gigantic),
        border: Border.all(
          color: AppTheme.colors.lightGray,
          width: AppTheme.dimensions.stroke.medium,
        ),
      ),
      child: AppNetworkImage(
        imageUrl: imageUrl,
        width: size.scale,
        radius: AppTheme.dimensions.radius.gigantic,
        fit: BoxFit.cover,
        noPlaceholder: true,
      ),
    );
  }
}
