import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/play_pill_button.dart';
import 'package:observatorio_geo_hist/app/core/components/image/fitted_network_image.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/post_cover.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class WorkCover extends StatelessWidget {
  const WorkCover({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return SizedBox(
      width: components.workCoverWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: components.workCoverRadius,
          boxShadow: AppTheme.dimensions.shadows.soft,
        ),
        child: _WorkPicture(
          url: url,
          aspectRatio: components.workCoverAspect,
          borderRadius: components.workCoverRadius,
          semanticLabel: 'Capa de $title',
        ),
      ),
    );
  }
}

class WorkPoster extends StatelessWidget {
  const WorkPoster({super.key, required this.url, required this.title, required this.link});

  final String url;
  final String title;
  final String link;

  @override
  Widget build(BuildContext context) {
    final link = this.link.trim();

    return Stack(
      alignment: Alignment.center,
      children: [
        _WorkPicture(
          url: url,
          aspectRatio: AppTheme.dimensions.components.workPosterAspect,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
          semanticLabel: 'Cartaz de $title',
        ),
        if (link.isNotEmpty)
          PlayPillButton(
            semanticLabel: 'Assistir a $title em outra aba',
            onPressed: () => openUrl(link),
          ),
      ],
    );
  }
}

class _WorkPicture extends StatelessWidget {
  const _WorkPicture({
    required this.url,
    required this.aspectRatio,
    required this.borderRadius,
    required this.semanticLabel,
  });

  final String url;
  final double aspectRatio;
  final BorderRadius borderRadius;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: AppTheme.colors.surface,
          child: url.isEmpty
              ? const PostImagePlaceholder()
              : FittedNetworkImage(
                  url,
                  fit: BoxFit.cover,
                  semanticLabel: semanticLabel,
                  errorBuilder: (context, error, stackTrace) => const PostImagePlaceholder(),
                ),
        ),
      ),
    );
  }
}
