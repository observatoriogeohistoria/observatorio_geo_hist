import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/highlights/highlight_card.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/highlights/highlights_grid.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/highlights/select_highlights.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_highlights_store.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/states/fetch_highlights_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Seção "Destaques" da Home (spec 005): até três publicações escolhidas pela
/// equipe, todas visíveis de uma vez.
///
/// Carregando: título e esqueleto. Erro: título, mensagem e "Tentar de novo".
/// Sem destaques: a seção inteira some.
class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key, required this.store, required this.onRetry});

  final FetchHighlightsStore store;

  /// Refaz a busca dos destaques.
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
            content = _Error(onRetry: onRetry);
          case FetchHighlightsSuccessState() when highlights.isEmpty:
            return const SizedBox.shrink();
          case FetchHighlightsSuccessState():
            content = HighlightsGrid(
              itemCount: highlights.length,
              itemBuilder: (context, index) => HighlightCard(post: highlights[index], isMain: index == 0),
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

    return ColoredBox(
      color: AppTheme.colors.page,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Destaques',
                  style: AppTheme.typography.of(context).h2.copyWith(color: AppTheme.colors.ink),
                ),
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

/// Esqueleto na disposição de três cartões. Parado (sem animação).
class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r16);

    return Semantics(
      label: 'Carregando destaques',
      excludeSemantics: true,
      child: HighlightsGrid(
        itemCount: maxHighlights,
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: radius,
          child: const Skeleton(width: null, height: null),
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r16),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.s24),
        child: Wrap(
          spacing: spacing.s16,
          runSpacing: spacing.s12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Não foi possível carregar os destaques.',
              style: AppTheme.typography.of(context).regular.copyWith(color: colors.inkSecondary),
            ),
            SecondaryButton.small(text: 'Tentar de novo', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
