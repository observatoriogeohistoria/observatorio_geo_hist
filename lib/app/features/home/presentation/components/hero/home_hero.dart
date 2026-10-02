import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/hero/area_categories_dialog.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/hero/hero_background_painter.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/hero/hero_shortcut_card.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class HomeHero extends StatefulWidget {
  const HomeHero({super.key});

  @override
  State<HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<HomeHero> {
  late final _fetchCategoriesStore = HomeSetup.getIt<FetchCategoriesStore>();

  final _historyFocus = FocusNode(debugLabel: 'Atalho História');
  final _geographyFocus = FocusNode(debugLabel: 'Atalho Geografia');

  @override
  void dispose() {
    _historyFocus.dispose();
    _geographyFocus.dispose();
    super.dispose();
  }

  Future<void> _openArea(PostsAreas area, FocusNode origin) async {
    await showAreaCategoriesDialog(context, area: area, store: _fetchCategoriesStore);
    if (!mounted) return;
    origin.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);

    const label = 'Universidade Federal de Uberlândia';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small)),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: HeroBackground()),
          PageContent(
            child: Padding(
              padding: EdgeInsets.only(
                top: components.heroPaddingTop(breakpoint),
                bottom: components.heroPaddingBottom(breakpoint),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: label,
                    excludeSemantics: true,
                    child: Text(label.toUpperCase(), style: styles.label.copyWith(color: colors.accentStrong)),
                  ),
                  SizedBox(height: components.heroTitleGap),
                  Semantics(
                    header: true,
                    child: ConstrainedBox(
                      // Em "em" para acompanhar o texto ampliado; senão, as palavras quebram no meio.
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.textScalerOf(context).scale(styles.display.fontSize!) *
                            components.heroTitleMaxWidthEm,
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: 'Ensino de História e Geografia, ',
                          children: [
                            TextSpan(text: 'em um só lugar.', style: TextStyle(color: colors.accent)),
                          ],
                        ),
                        style: styles.display.copyWith(color: colors.ink),
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.s20),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: components.heroLeadMaxWidth),
                    child: Text(
                      'Narrativas, pesquisas, documentos e experiências didáticas reunidos para '
                      'professores, pesquisadores e estudantes.',
                      style: styles.lead.copyWith(color: colors.inkSecondary),
                    ),
                  ),
                  SizedBox(height: components.heroActionsGap),
                  Wrap(
                    spacing: spacing.s12,
                    runSpacing: spacing.s12,
                    children: [
                      PrimaryButton.medium(
                        text: 'Explorar a biblioteca',
                        trailingIcon: Icons.arrow_forward,
                        onPressed: () => GoRouter.of(context).go(AppRoutes.library),
                      ),
                      SecondaryButton.medium(
                        text: 'Ler o manifesto',
                        onPressed: () => GoRouter.of(context).go(AppRoutes.manifesto),
                      ),
                    ],
                  ),
                  SizedBox(height: components.heroShortcutsGap(breakpoint)),
                  _shortcuts(breakpoint),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shortcuts(Breakpoint breakpoint) {
    final gap = AppTheme.dimensions.spacing.s16;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >=
        AppTheme.dimensions.components.heroShortcutsStackTextScale;
    final singleColumn = breakpoint == Breakpoint.mobile || largeText;
    final layout = breakpoint == Breakpoint.tablet && !singleColumn
        ? HeroShortcutLayout.vertical
        : HeroShortcutLayout.horizontal;

    final cards = [
      HeroShortcutCard(
        icon: Icons.hourglass_empty_rounded,
        title: 'História',
        description: 'Categorias e publicações da área',
        semanticLabel: 'História. Categorias e publicações da área. Abre a lista de categorias',
        layout: layout,
        focusNode: _historyFocus,
        onTap: () => _openArea(PostsAreas.history, _historyFocus),
      ),
      HeroShortcutCard(
        icon: Icons.public,
        title: 'Geografia',
        description: 'Categorias, Expogeo e Geoensine',
        semanticLabel: 'Geografia. Categorias, Expogeo e Geoensine. Abre a lista de categorias',
        layout: layout,
        focusNode: _geographyFocus,
        onTap: () => _openArea(PostsAreas.geography, _geographyFocus),
      ),
      HeroShortcutCard(
        icon: Icons.menu_book_outlined,
        title: 'Biblioteca',
        description: 'Teses e dissertações',
        semanticLabel: 'Biblioteca. Teses e dissertações',
        url: AppRoutes.library,
        layout: layout,
        onTap: () => GoRouter.of(context).go(AppRoutes.library),
      ),
    ];

    if (singleColumn) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, card) in cards.indexed) ...[
            if (index > 0) SizedBox(height: gap),
            card,
          ],
        ],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, card) in cards.indexed) ...[
            if (index > 0) SizedBox(width: gap),
            Expanded(child: card),
          ],
        ],
      ),
    );
  }
}
