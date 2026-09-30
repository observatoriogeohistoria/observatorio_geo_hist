import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Conteúdo do menu de uma área (História ou Geografia): carregando (esqueleto),
/// vazio, erro com "Tentar de novo" ou a lista de categorias. Em Geografia,
/// Expogeo e Geoensine vêm antes, separados por um divisor.
///
/// Usado no menu suspenso (desktop) e nas sanfonas do painel de celular.
class NavbarCategoriesMenu extends StatelessWidget {
  const NavbarCategoriesMenu({
    super.key,
    required this.area,
    required this.store,
    this.selectedCategoryKey,
    this.onSelected,
  });

  final PostsAreas area;
  final FetchCategoriesStore store;

  /// Chave da categoria aberta na rota atual (fica marcada na lista).
  final String? selectedCategoryKey;

  /// Chamado antes de navegar ou abrir um link (o menu se fecha).
  final VoidCallback? onSelected;

  void _goToCategory(BuildContext context, CategoryModel category) {
    final router = GoRouter.of(context);
    onSelected?.call();
    store.setSelectedCategory(category);
    router.go(AppRoutes.category(category.areas.first.key, category.key), extra: category);
  }

  void _openExternal(String url) {
    onSelected?.call();
    openUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;
    final isGeography = area == PostsAreas.geography;

    return Observer(
      builder: (context) {
        final state = store.state;
        final categories = isGeography ? store.categories.geography : store.categories.history;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isGeography) ...[
              NavbarMenuOption(
                label: 'Expogeo',
                isExternal: true,
                onTap: () => _openExternal(AppStrings.expogeoUrl),
              ),
              NavbarMenuOption(
                label: 'Geoensine',
                isExternal: true,
                onTap: () => _openExternal(AppStrings.geoensineUrl),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.s8, horizontal: spacing.s8),
                child: Divider(height: 1, thickness: 1, color: AppTheme.colors.line),
              ),
            ],
            switch (state) {
              FetchCategoriesInitialState() || FetchCategoriesLoadingState() => const _LoadingRows(),
              FetchCategoriesErrorState() => _ErrorRow(onRetry: store.fetchCategories),
              FetchCategoriesSuccessState() when categories.isEmpty => const _MessageRow(
                  'Nenhuma categoria por enquanto',
                ),
              FetchCategoriesSuccessState() => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final category in categories)
                      NavbarMenuOption(
                        label: category.title,
                        isSelected: category.key == selectedCategoryKey,
                        onTap: () => _goToCategory(context, category),
                      ),
                  ],
                ),
            },
          ],
        );
      },
    );
  }
}

/// Uma opção de menu: linha inteira clicável, com foco visível.
class NavbarMenuOption extends StatefulWidget {
  const NavbarMenuOption({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.isExternal = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  /// Abre em outra aba: mostra o ícone de link externo e avisa o leitor de tela.
  final bool isExternal;

  @override
  State<NavbarMenuOption> createState() => _NavbarMenuOptionState();
}

class _NavbarMenuOptionState extends State<NavbarMenuOption> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);
    final highlighted = _hovered || widget.isSelected;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      link: widget.isExternal,
      label: widget.isExternal ? '${widget.label}, abre em outra aba' : widget.label,
      // Repete a ação do InkWell (excluído da semântica) para o leitor de tela ativar a opção.
      onTap: widget.onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: widget.isSelected ? colors.accentSoft : Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: widget.onTap,
            onHover: (value) => setState(() => _hovered = value),
            hoverColor: colors.surface,
            mouseCursor: SystemMouseCursors.click,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.s12, vertical: spacing.s8 + 1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.label,
                      style: AppTheme.typography.of(context).regular.copyWith(
                            fontSize: components.navItemText,
                            fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                            height: 1.35,
                            color: highlighted ? colors.accentStrong : colors.ink,
                          ),
                    ),
                  ),
                  if (widget.isExternal) ...[
                    SizedBox(width: spacing.s12),
                    Icon(Icons.north_east, size: components.navIcon, color: colors.inkSecondary),
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

class _LoadingRows extends StatelessWidget {
  const _LoadingRows();

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);
    const widths = [0.8, 0.6, 0.7];

    return Semantics(
      label: 'Carregando categorias',
      excludeSemantics: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.s12, vertical: spacing.s8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final factor in widths)
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.s8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: factor,
                    child: ClipRRect(
                      borderRadius: radius,
                      child: Skeleton(width: null, height: spacing.s16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.s12, vertical: spacing.s12),
      child: Text(
        message,
        style: AppTheme.typography.of(context).small.copyWith(color: AppTheme.colors.inkSecondary),
      ),
    );
  }
}

class _ErrorRow extends StatelessWidget {
  const _ErrorRow({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.s4, vertical: spacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MessageRow('Não foi possível carregar as categorias'),
          Padding(
            padding: EdgeInsets.only(left: spacing.s8),
            child: AppTextButton.small(text: 'Tentar de novo', onPressed: onRetry),
          ),
        ],
      ),
    );
  }
}
