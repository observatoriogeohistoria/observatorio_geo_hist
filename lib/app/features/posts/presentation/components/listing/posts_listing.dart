import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_error_box.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_message_box.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/listing/listing_toolbar.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/listing/listing_type_block.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/posts_listing_store.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/posts_listing_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Busca, chips, contagem e blocos por tipo. Não sabe de categoria: quem monta
/// a página carrega o [store] com o escopo e diz a rota de cada post.
class PostsListing extends StatefulWidget {
  const PostsListing({super.key, required this.store, required this.routeFor});

  final PostsListingStore store;
  final String Function(PostModel post) routeFor;

  @override
  State<PostsListing> createState() => _PostsListingState();
}

class _PostsListingState extends State<PostsListing> {
  final _searchController = TextEditingController();
  final _searchKey = GlobalKey();
  late final ReactionDisposer _disposeSync;

  @override
  void initState() {
    super.initState();
    // A busca pode ser zerada pelo store (troca de categoria, "Limpar busca").
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

    return PageContent(
      child: Observer(
        builder: (context) {
          final status = store.status;
          final searching = store.searchText.isNotEmpty;
          final success = status == PostsListingStatus.success;
          final showToolbar = status != PostsListingStatus.empty || searching;
          final total = store.totalCount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showToolbar)
                Padding(
                  padding: EdgeInsets.only(
                    top: components.listingToolbarPaddingTop,
                    bottom: components.listingToolbarPaddingBottom,
                  ),
                  child: ListingToolbar(
                    searchKey: _searchKey,
                    controller: _searchController,
                    onSearch: store.search,
                    types: success && store.typesWithPosts.length >= 2
                        ? store.typesWithPosts
                        : const [],
                    counts: store.counts,
                    selectedType: store.selectedType,
                    onSelectType: store.selectType,
                  ),
                ),
              if (success && total != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: components.listingCountPaddingTop,
                    bottom: components.listingCountPaddingBottom,
                  ),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      searching
                          ? '${publicationsCount(total)} para “${store.searchText}”'
                          : publicationsCount(total),
                      style: AppTheme.typography
                          .of(context)
                          .small
                          .copyWith(color: AppTheme.colors.inkSecondary),
                    ),
                  ),
                ),
              switch (status) {
                PostsListingStatus.initial ||
                PostsListingStatus.loading =>
                  const _StateFrame(child: PostCardSkeletonRow()),
                PostsListingStatus.error => _StateFrame(
                    child: StateErrorBox(onRetry: store.retry),
                  ),
                PostsListingStatus.empty when searching => _StateFrame(
                    child: StateMessageBox(
                      icon: Icons.search,
                      title: 'Nenhuma publicação encontrada',
                      message: 'Tente outro termo ou limpe a busca.',
                      action: SecondaryButton.small(
                        text: 'Limpar busca',
                        onPressed: store.clearSearch,
                      ),
                    ),
                  ),
                PostsListingStatus.empty => const _StateFrame(
                    child: StateMessageBox(
                      icon: Icons.article_outlined,
                      title: 'Ainda não há publicações nesta categoria',
                      message: 'Volte em breve ou explore outras categorias no menu.',
                    ),
                  ),
                PostsListingStatus.success => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final block in store.visibleBlocks)
                        ListingTypeBlock(
                          key: ValueKey(block.type),
                          block: block,
                          count: store.counts?[block.type],
                          routeFor: widget.routeFor,
                          onLoadMore: () => store.loadMore(block.type),
                        ),
                      SizedBox(height: components.listingBottomGap),
                    ],
                  ),
              },
            ],
          );
        },
      ),
    );
  }
}

class _StateFrame extends StatelessWidget {
  const _StateFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Padding(
      padding: EdgeInsets.only(
        top: components.listingStatePaddingTop,
        bottom: components.listingStatePaddingBottom,
      ),
      child: child,
    );
  }
}
