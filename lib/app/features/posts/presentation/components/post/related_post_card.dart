import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/date/date.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/post_cover.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class RelatedPostCard extends StatefulWidget {
  const RelatedPostCard({
    super.key,
    required this.article,
    required this.route,
  });

  final ArticleModel article;
  final String route;

  @override
  State<RelatedPostCard> createState() => _RelatedPostCardState();
}

class _RelatedPostCardState extends State<RelatedPostCard> {
  bool _hovered = false;

  void _open() => GoRouter.of(context).go(widget.route);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final shadows = AppTheme.dimensions.shadows;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r14);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : components.postCardAnimation;

    final title = widget.article.title.trim();
    final imageUrl = widget.article.image.url?.trim() ?? '';
    final meta = [
      joinNames(widget.article.authors),
      formatMonthYear(widget.article.date),
    ].where((part) => part.isNotEmpty).join(' · ');

    return Semantics(
      link: true,
      label: [title, 'Artigo', if (meta.isNotEmpty) meta].join(', '),
      linkUrl: Uri.parse(widget.route),
      onTap: _open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: _open,
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: radius,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            mouseCursor: SystemMouseCursors.click,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedContainer(
                  duration: duration,
                  transform: Matrix4.translationValues(
                    0,
                    _hovered && !reduceMotion ? -components.postCardThumbLift : 0,
                    0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    boxShadow: _hovered ? shadows.elevated : shadows.hidden(shadows.elevated),
                  ),
                  child: ClipRRect(
                    borderRadius: radius,
                    child: AspectRatio(
                      aspectRatio: components.postCardThumbAspect,
                      child: ColoredBox(
                        color: colors.surface,
                        child: imageUrl.isEmpty
                            ? const PostImagePlaceholder()
                            : Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                excludeFromSemantics: true,
                                errorBuilder: (context, error, stackTrace) =>
                                    const PostImagePlaceholder(),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: components.postCardInnerGap),
                Text(
                  'ARTIGO',
                  style: styles.label.copyWith(color: colors.accentStrong),
                ),
                SizedBox(height: components.postCardTitleGap),
                AnimatedDefaultTextStyle(
                  duration: duration,
                  style: styles.postCardTitle.copyWith(
                    color: _hovered ? colors.accent : colors.ink,
                  ),
                  child: Text(
                    title,
                    maxLines: components.postCardTitleMaxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (meta.isNotEmpty) ...[
                  SizedBox(height: components.postCardInnerGap),
                  Text(
                    meta,
                    style: styles.small.copyWith(color: colors.inkSecondary),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
