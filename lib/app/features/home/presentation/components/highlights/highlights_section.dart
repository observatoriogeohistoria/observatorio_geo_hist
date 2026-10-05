import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/arrow_link.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_error_inline.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/highlights/highlight_card.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/highlights/highlights_grid.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/highlights/select_highlights.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_highlights_store.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/states/fetch_highlights_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key, required this.store, required this.onRetry});

  final FetchHighlightsStore store;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final state = store.state;
        final highlights = selectHighlights(store.highlights);

        final Widget content;
        switch (state) {
          case FetchHighlightsInitialState() || FetchHighlightsLoadingState():
            content = const _Loading();
          case FetchHighlightsErrorState():
            content = StateErrorInline(
                message: 'Não foi possível carregar os destaques.', onRetry: onRetry);
          case FetchHighlightsSuccessState() when highlights.isEmpty:
            return const SizedBox.shrink();
          case FetchHighlightsSuccessState():
            content = HighlightsGrid(
              itemCount: highlights.length,
              itemBuilder: (context, index) =>
                  HighlightCard(post: highlights[index], isMain: index == 0),
            );
        }

        return _Section(child: content);
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final padding = components.sectionPaddingVertical(breakpoint);

    final title = Semantics(
      header: true,
      child: Text(
        'Destaques',
        style: AppTheme.typography.of(context).h2.copyWith(color: AppTheme.colors.ink),
      ),
    );
    final more = ArrowLink(
      text: 'Ver todas as publicações',
      url: AppRoutes.publications,
      onTap: () => GoRouter.of(context).go(AppRoutes.publications),
    );

    return ColoredBox(
      color: AppTheme.colors.page,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (breakpoint == Breakpoint.mobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    SizedBox(height: components.postSubtitleGap),
                    more,
                  ],
                )
              else
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: components.postBylineGap,
                  runSpacing: components.postSubtitleGap,
                  children: [title, more],
                ),
              SizedBox(height: components.sectionHeadGap),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r16);
    final isMobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    return Semantics(
      label: 'Carregando destaques',
      excludeSemantics: true,
      child: HighlightsGrid(
        itemCount: maxHighlights,
        itemBuilder: (context, index) => isMobile && index > 0
            ? const _CompactSkeleton()
            : ClipRRect(
                borderRadius: radius,
                child: const Skeleton(width: null, height: null),
              ),
      ),
    );
  }
}

class _CompactSkeleton extends StatelessWidget {
  const _CompactSkeleton();

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final thumbWidth = components.featuredCompactThumbWidth;

    Widget bar(double widthFactor, TextStyle style) => FractionallySizedBox(
          widthFactor: widthFactor,
          alignment: Alignment.centerLeft,
          child: Skeleton(width: null, height: textScaler.scale(style.fontSize!)),
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r10),
          child: Skeleton(
              width: thumbWidth, height: thumbWidth / components.featuredCompactThumbAspectRatio),
        ),
        SizedBox(width: components.featuredCompactGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bar(0.5, styles.label),
              SizedBox(height: components.featuredCompactTextGap * 2),
              bar(1, styles.featureTitleSmall),
              SizedBox(height: components.featuredCompactTextGap),
              bar(0.7, styles.featureTitleSmall),
            ],
          ),
        ),
      ],
    );
  }
}
