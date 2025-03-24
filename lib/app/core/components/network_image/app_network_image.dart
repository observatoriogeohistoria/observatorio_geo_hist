import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/cached_image/cached_image.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 253,
    this.radius,
    super.key,
  });

  final String imageUrl;
  final double width;
  final double height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: CachedImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
