import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/image_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/image/image.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.imageUrl,
    this.width = double.infinity,
    this.height,
    this.radius,
    this.fit = BoxFit.cover,
    this.noPlaceholder = false,
    super.key,
  });

  final String imageUrl;

  final double width;
  final double? height;
  final double? radius;

  final BoxFit fit;

  final bool noPlaceholder;

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
        fit: fit,
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
      fit: fit,
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        if (noPlaceholder) return child;

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
                  height: height ?? 253.verticalSpacing,
                ),
        );
      },
      errorBuilder: (_, __, ___) {
        return SizedBox(
          width: width,
          height: height,
          child: const ImageErrorContent(),
        );
      },
    );
  }
}
