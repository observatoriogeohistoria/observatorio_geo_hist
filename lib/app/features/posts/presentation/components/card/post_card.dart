import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card_info.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/post_cover.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';
import 'package:observatorio_geo_hist/app/core/components/image/fitted_network_image.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.route,
    this.showSummary = true,
  });

  final PostModel post;
  final String route;
  final bool showSummary;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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

    final info = postCardInfo(widget.post);
    final summary = widget.showSummary ? info.summary : '';

    return Semantics(
      link: true,
      label: [
        info.title,
        widget.post.type.portuguese,
        if (info.meta.isNotEmpty) info.meta,
      ].join(', '),
      linkUrl: Uri.parse(widget.route),
      onTap: _open,
      excludeSemantics: true,
      child: RepaintBoundary(
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
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: _hovered ? 1 : 0),
                    duration: duration,
                    builder: (context, t, child) => Transform.translate(
                      offset: Offset(0, reduceMotion ? 0 : -components.postCardThumbLift * t),
                      child: DecoratedBox(
                        // Sombra transparente ainda custa o desfoque a cada quadro do scroll;
                        // fora do hover não há sombra nenhuma.
                        decoration: BoxDecoration(
                          borderRadius: radius,
                          boxShadow: t == 0 ? null : shadows.fade(shadows.elevated, t),
                        ),
                        child: child,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: radius,
                      child: AspectRatio(
                        aspectRatio: components.postCardThumbAspect,
                        child: ColoredBox(
                          color: colors.surface,
                          child: info.imageUrl.isEmpty
                              ? const PostImagePlaceholder()
                              : FittedNetworkImage(
                                  info.imageUrl,
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
                    info.label,
                    style: styles.label.copyWith(color: colors.accentStrong),
                  ),
                  SizedBox(height: components.postCardTitleGap),
                  AnimatedDefaultTextStyle(
                    duration: duration,
                    style: styles.postCardTitle.copyWith(
                      color: _hovered ? colors.accent : colors.ink,
                    ),
                    child: Text(
                      info.title,
                      maxLines: components.postCardTitleMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (summary.isNotEmpty) ...[
                    SizedBox(height: components.postCardInnerGap),
                    Text(
                      summary,
                      maxLines: components.postCardSummaryMaxLines,
                      overflow: TextOverflow.ellipsis,
                      style: styles.postCardSummary.copyWith(
                        color: colors.inkSecondary,
                      ),
                    ),
                  ],
                  if (info.meta.isNotEmpty) ...[
                    SizedBox(height: components.postCardInnerGap),
                    Text(
                      info.meta,
                      style: styles.small.copyWith(color: colors.inkSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
