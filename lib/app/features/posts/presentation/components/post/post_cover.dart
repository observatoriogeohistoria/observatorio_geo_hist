import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostCover extends StatelessWidget {
  const PostCover({super.key, required this.imageUrl, this.caption});

  final String imageUrl;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final caption = this.caption?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: components.postCoverAspect,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r16),
            child: ColoredBox(
              color: colors.surface,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                semanticLabel: caption.isEmpty ? 'Imagem de capa do artigo' : caption,
                errorBuilder: (context, error, stackTrace) => const PostImagePlaceholder(),
              ),
            ),
          ),
        ),
        if (caption.isNotEmpty) ...[
          SizedBox(height: components.postCoverCaptionGap),
          ExcludeSemantics(
            child: Text(caption, style: AppTheme.typography.of(context).small.copyWith(color: colors.inkSecondary)),
          ),
        ],
      ],
    );
  }
}

class PostImagePlaceholder extends StatelessWidget {
  const PostImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;

    return ExcludeSemantics(
      child: SizedBox.expand(
        child: ColoredBox(
          color: colors.accentSoft,
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: AppTheme.dimensions.components.postPlaceholderIcon,
              color: colors.accent,
            ),
          ),
        ),
      ),
    );
  }
}
