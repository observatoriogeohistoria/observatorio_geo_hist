import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ReadingFigure extends StatelessWidget {
  const ReadingFigure({
    super.key,
    required this.image,
    required this.semanticLabel,
    this.caption,
    this.alignment = Alignment.center,
  });

  final ImageProvider image;
  final String semanticLabel;
  final String? caption;

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(top: components.readingPaddingTop),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.readingFigureMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: components.readingFigureAspect,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r16),
                    child: ColoredBox(
                      color: colors.surface,
                      child: Image(
                        image: image,
                        semanticLabel: semanticLabel,
                        fit: BoxFit.cover,
                        alignment: alignment,
                        errorBuilder: (context, error, stackTrace) => const _FigurePlaceholder(),
                      ),
                    ),
                  ),
                ),
                if (caption != null) ...[
                  SizedBox(height: components.readingFigureCaptionGap),
                  Text(caption!,
                      style: AppTheme.typography
                          .of(context)
                          .small
                          .copyWith(color: colors.inkSecondary)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FigurePlaceholder extends StatelessWidget {
  const _FigurePlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;

    return ExcludeSemantics(
      child: ColoredBox(
        color: colors.accentSoft,
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: AppTheme.dimensions.components.readingFigurePlaceholderIcon,
            color: colors.accent,
          ),
        ),
      ),
    );
  }
}
