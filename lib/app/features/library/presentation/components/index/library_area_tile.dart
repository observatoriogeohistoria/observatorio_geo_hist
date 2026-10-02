import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

String documentTypeCount(DocumentType type, int count) => switch (type) {
      DocumentType.tese => count == 1 ? '1 tese' : '$count teses',
      DocumentType.dissertacao => count == 1 ? '1 dissertação' : '$count dissertações',
    };

class LibraryAreaTile extends StatefulWidget {
  const LibraryAreaTile({
    super.key,
    required this.area,
    required this.counts,
    required this.loading,
  });

  final DocumentArea area;

  /// Nulo sem contagem: a linha de números some (ou vira esqueleto, se [loading]).
  final Map<DocumentType, int>? counts;
  final bool loading;

  @override
  State<LibraryAreaTile> createState() => _LibraryAreaTileState();
}

class _LibraryAreaTileState extends State<LibraryAreaTile> {
  static const _statsOrder = [DocumentType.dissertacao, DocumentType.tese];

  bool _hovered = false;

  String get _route => AppRoutes.libraryArea(widget.area.routeKey);

  void _open() => GoRouter.of(context).go(_route);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final shadows = AppTheme.dimensions.shadows;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r20);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final name = widget.area.value;
    final counts = widget.counts;
    final explore = 'Explorar $name';

    return Semantics(
      link: true,
      label: [
        name,
        if (counts != null)
          for (final type in _statsOrder) documentTypeCount(type, counts[type] ?? 0),
        explore,
      ].join(', '),
      linkUrl: Uri.parse(_route),
      onTap: _open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        fit: StackFit.passthrough,
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: _hovered ? 1 : 0),
          duration: reduceMotion ? Duration.zero : components.areaTileAnimation,
          curve: Curves.easeOut,
          builder: (context, t, child) => Transform.translate(
            offset: Offset(0, reduceMotion ? 0 : -components.areaTileLift * t),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.page,
                borderRadius: radius,
                border: Border.all(
                  color: Color.lerp(colors.line, colors.accent, t)!,
                  width: AppTheme.dimensions.stroke.small,
                ),
                boxShadow: t == 0 ? null : shadows.fade(shadows.lifted, t),
              ),
              child: child,
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: _open,
              onHover: (value) => setState(() => _hovered = value),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              mouseCursor: SystemMouseCursors.click,
              child: Padding(
                padding: EdgeInsets.all(components.areaTilePadding(breakpoint)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: components.areaTileIconBox,
                      height: components.areaTileIconBox,
                      decoration: BoxDecoration(
                        color: colors.accentSoft,
                        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        switch (widget.area) {
                          DocumentArea.geografia => Icons.public,
                          DocumentArea.historia => Icons.hourglass_empty,
                        },
                        size: components.areaTileIcon,
                        color: colors.accent,
                      ),
                    ),
                    SizedBox(height: components.areaTileGap),
                    Text(name, style: styles.areaTileTitle.copyWith(color: colors.ink)),
                    SizedBox(height: components.areaTileGap),
                    Text(
                      'Teses e dissertações sobre o ensino de $name.',
                      style: styles.regular.copyWith(color: colors.inkSecondary),
                    ),
                    if (counts != null || widget.loading) ...[
                      SizedBox(height: components.areaTileGap),
                      _Stats(counts: counts, order: _statsOrder),
                    ],
                    SizedBox(height: components.areaTileGap),
                    _ExploreLabel(text: explore),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.counts, required this.order});

  final Map<DocumentType, int>? counts;
  final List<DocumentType> order;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final style = AppTheme.typography.of(context).meta.copyWith(color: colors.inkSecondary);
    final counts = this.counts;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: components.areaTileStatsPaddingTop),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: Wrap(
        spacing: components.areaTileStatsGap,
        runSpacing: components.areaTileGap,
        children: [
          for (final type in order)
            if (counts == null)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r6),
                child: Skeleton(
                  width: components.areaTileSkeletonWidth,
                  height: components.areaTileSkeletonHeight,
                ),
              )
            else
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${counts[type] ?? 0}',
                      style: TextStyle(
                        color: colors.ink,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    TextSpan(
                      text: documentTypeCount(type, counts[type] ?? 0)
                          .substring('${counts[type] ?? 0}'.length),
                    ),
                  ],
                ),
                style: style,
              ),
        ],
      ),
    );
  }
}

class _ExploreLabel extends StatelessWidget {
  const _ExploreLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final color = AppTheme.colors.accentStrong;
    final style =
        AppTheme.typography.of(context).regular.copyWith(fontWeight: FontWeight.w600, color: color);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(text, style: style)),
        SizedBox(width: components.arrowLinkGap),
        Icon(Icons.arrow_forward, size: style.fontSize! * components.buttonIconScale, color: color),
      ],
    );
  }
}
