import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/image_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/core/utils/image/image.dart';

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
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (ImageUtils.isSvg(imageUrl)) {
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

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;

        return AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: frame != null
              ? child
              : Skeleton(
                  width: width,
                  height: height,
                ),
        );
      },
      errorBuilder: (_, __, ___) {
        return const ImageErrorContent();
      },
    );
  }
}
