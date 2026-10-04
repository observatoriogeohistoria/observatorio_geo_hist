import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_error_box.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_message_box.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_active_filters.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_category_filter.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_document_row.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_listing_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_search_bar.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_year_field.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/library_listing_store.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/states/library_listing_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryListing extends StatefulWidget {
  const LibraryListing({super.key, required this.store, required this.area});

  final LibraryListingStore store;
  final DocumentArea area;

  @override
  State<LibraryListing> createState() => _LibraryListingState();
}

class _LibraryListingState extends State<LibraryListing> {
  final _searchController = TextEditingController();
  late final ReactionDisposer _disposeSync;

  @override
  void initState() {
    super.initState();
    // A busca pode ser zerada pelo store ("Limpar tudo", troca de área).
    _disposeSync = reaction((_) => widget.store.searchText, (String text) {
      if (_searchController.text.trim() != text) _searchController.text = text;
    });
  }

  @override
  void dispose() {
    _disposeSync();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final store = widget.store;

    return Observer(
      builder: (context) {
        final status = store.status;
        final total = store.total;
        final success = status == LibraryListingStatus.success;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (status != LibraryListingStatus.areaEmpty)
              PageContent(
                child: Padding(
                  padding: EdgeInsets.only(top: components.listingToolbarPaddingTop),
                  child: _Controls(store: store, searchController: _searchController),
                ),
              ),
            if (success && total != null)
              PageContent(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: components.libraryCountPaddingTop,
                    bottom: components.libraryCountPaddingBottom,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        store.isSearching
                            ? '${documentsCount(total)} para “${store.searchText}”'
                            : documentsCount(total),
                        style: AppTheme.typography
                            .of(context)
                            .meta
                            .copyWith(color: AppTheme.colors.inkSecondary),
                      ),
                    ),
                  ),
                ),
              ),
            switch (status) {
              LibraryListingStatus.initial ||
              LibraryListingStatus.loading =>
                const _StateFrame(bleed: true, child: LibraryListingSkeleton()),
              LibraryListingStatus.error => _StateFrame(
                  child: StateErrorBox(onRetry: store.retry),
                ),
              LibraryListingStatus.areaEmpty => _StateFrame(
                  child: StateMessageBox(
                    icon: Icons.menu_book_outlined,
                    title: 'Ainda não há documentos em ${widget.area.value}',
                    message: 'Volte em breve.',
                  ),
                ),
              LibraryListingStatus.noResults => _StateFrame(
                  child: StateMessageBox(
                    icon: Icons.search,
                    title: 'Nenhum documento encontrado',
                    message: 'Tente outro termo ou remova algum filtro.',
                    action: SecondaryButton.small(
                      text: 'Limpar filtros',
                      onPressed: store.clearAll,
                    ),
                  ),
                ),
              LibraryListingStatus.success => _Results(store: store),
            },
          ],
        );
      },
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.store, required this.searchController});

  final LibraryListingStore store;
  final TextEditingController searchController;

  static String _typeOption(DocumentType? type, Map<DocumentType, int>? counts) {
    if (type == null) return 'Tipo: todos';
    final count = counts?[type];
    return count == null ? type.value : '${type.value} ($count)';
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Observer(
      builder: (context) {
        final typeCounts = store.typeCounts;
        final type = store.type;
        final year = store.year;
        final categories = store.categories;

        final activeFilters = [
          if (type != null) LibraryActiveFilter('Tipo: ${type.value}', () => store.setType(null)),
          if (year != null) LibraryActiveFilter('Ano: $year', () => store.setYear('')),
          for (final category in categories)
            LibraryActiveFilter(category.value, () => store.toggleCategory(category)),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LibrarySearchBar(
              controller: searchController,
              field: store.searchField,
              onFieldChanged: store.setSearchField,
              onSearch: store.search,
            ),
            SizedBox(height: components.libraryFiltersTop),
            Wrap(
              spacing: components.libraryFilterGap,
              runSpacing: components.libraryFilterGap,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                LibraryFilterSelect<DocumentType?>(
                  semanticLabel: 'Tipo de produção',
                  value: type,
                  options: [
                    for (final option in [null, ...DocumentType.values])
                      LibraryFilterOption(option, _typeOption(option, typeCounts)),
                  ],
                  onSelected: store.setType,
                ),
                LibraryYearField(value: year, onChanged: store.setYear),
                LibraryCategoryFilter(
                  categories: store.visibleCategories,
                  counts: store.categoryCounts,
                  selected: categories,
                  onToggle: store.toggleCategory,
                  onClear: store.clearCategories,
                ),
              ],
            ),
            if (activeFilters.isNotEmpty) ...[
              SizedBox(height: components.libraryActiveRowTop),
              LibraryActiveFilters(filters: activeFilters, onClearAll: store.clearAll),
            ],
          ],
        );
      },
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.store});

  final LibraryListingStore store;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    const moreText = 'Ver mais documentos';
    const loadingText = 'Carregando…';

    return Observer(
      builder: (context) {
        final loadingMore = store.isLoadingMore;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Bleed(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final document in store.documents)
                    LibraryDocumentRow(
                      key: ValueKey(document.id ?? document.title),
                      document: document,
                    ),
                ],
              ),
            ),
            if (store.hasMore || store.loadMoreFailed)
              PageContent(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: components.listingMorePaddingTop,
                    bottom: components.listingMorePaddingBottom,
                  ),
                  child: Column(
                    children: [
                      SecondaryButton.medium(
                        text: loadingMore ? loadingText : moreText,
                        onPressed: store.loadMore,
                        isDisabled: loadingMore,
                        reserveTexts: const [moreText, loadingText],
                      ),
                      if (store.loadMoreFailed) ...[
                        SizedBox(height: components.listingMoreErrorGap),
                        Semantics(
                          liveRegion: true,
                          child: Text(
                            'Não foi possível carregar mais documentos.',
                            textAlign: TextAlign.center,
                            style: styles.small.copyWith(color: colors.error),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else
              SizedBox(height: components.listingBottomGap),
          ],
        );
      },
    );
  }
}

/// Conteúdo que avança sobre a margem para o fundo da linha no hover passar do texto.
class _Bleed extends StatelessWidget {
  const _Bleed({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final margin = ScreenUtils.contentMargin(ScreenUtils.breakpointOf(context));

    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: ScreenUtils.contentMaxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: margin - AppTheme.dimensions.components.libraryDocPaddingH,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _StateFrame extends StatelessWidget {
  const _StateFrame({required this.child, this.bleed = false});

  final Widget child;
  final bool bleed;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final padded = Padding(
      padding: EdgeInsets.only(
        top: components.listingStatePaddingTop,
        bottom: components.listingStatePaddingBottom,
      ),
      child: child,
    );

    return bleed ? _Bleed(child: padded) : PageContent(child: padded);
  }
}
