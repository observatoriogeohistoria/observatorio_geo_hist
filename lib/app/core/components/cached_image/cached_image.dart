import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    required this.imageUrl,
    this.height,
    this.width,
    super.key,
  });

  final String imageUrl;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.contains('.svg')) {
      return SvgPicture.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholderBuilder: (_) {
          return Skeleton(
            width: width,
            height: height,
          );
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (_, __) {
        return Skeleton(
          width: width,
          height: height,
        );
      },
    );
  }
}
