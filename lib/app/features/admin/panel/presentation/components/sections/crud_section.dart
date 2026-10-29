import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_footer.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_section_scroll.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/panel_action.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/crud_store.dart';

/// Base for sections without server pagination (or just "load on scroll"): handles states,
/// the filter bar and the footer. Items are drawn by [bodyBuilder], as a sliver.
class CrudSection<T> extends StatefulWidget {
  const CrudSection({
    required this.header,
    required this.store,
    required this.pending,
    required this.messages,
    required this.empty,
    required this.bodyBuilder,
    this.paginated = false,
    this.isGrid = false,
    this.filterBar,
    this.filter,
    this.onClearFilters,
    super.key,
  });

  final Widget header;
  final CrudStore<T> store;
  final PendingPanelAction pending;
  final Map<PanelAction, String> messages;
  final PanelEmptyInfo empty;

  /// Receives the items that pass the filter and the footer, when there's something to show in it.
  final Widget Function(List<T> items, Widget? footer) bodyBuilder;
  final bool paginated;
  final bool isGrid;

  final Widget? filterBar;

  /// Filter applied on screen, over the items already loaded. Null when no filter is active.
  final bool Function(T item)? filter;
  final VoidCallback? onClearFilters;

  @override
  State<CrudSection<T>> createState() => _CrudSectionState<T>();
}

class _CrudSectionState<T> extends State<CrudSection<T>> {
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();
  final _scrollController = ScrollController();

  List<ReactionDisposer> _reactions = [];
  bool _loadingFirstPage = false;
  bool _firstPageFailed = false;
  bool _loadingMore = false;

  // After a failure loading more, the next attempt is via the button, not on every scroll.
  bool _loadMoreFailed = false;

  @override
  void initState() {
    super.initState();

    _reactions = [
      reaction((_) => widget.store.state, _handleState, fireImmediately: false),
    ];

    _load();
  }

  void _load() => widget.store.getItems();

  void _loadMore() {
    if (_loadMoreFailed) return;
    final before = widget.store.state;
    widget.store.loadMore();
    if (!identical(before, widget.store.state)) _loadingMore = true;
  }

  void _retryLoadMore() {
    setState(() => _loadMoreFailed = false);
    _loadMore();
  }

  void _retry() {
    setState(() => _firstPageFailed = false);
    _load();
  }

  void _handleState(CrudState state) {
    if (state is CrudLoadingState) _loadingFirstPage = !state.isRefreshing;

    final isFirstPageError = state is CrudErrorState && _loadingFirstPage;
    if (isFirstPageError) setState(() => _firstPageFailed = true);
    if (state is CrudErrorState && _loadingMore) setState(() => _loadMoreFailed = true);
    if (state is! CrudLoadingState) _loadingMore = false;

    showPanelActionResult(
      context,
      state: state,
      pending: widget.pending,
      messages: widget.messages,
      onForbidden: authStore.logout,
      isFirstPageLoad: isFirstPageError,
    );

    if (state is CrudSuccessState && widget.paginated) {
      loadMoreIfNotScrollable(_scrollController, _loadMore);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (var reaction in _reactions) {
      reaction();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final store = widget.store;
        final state = store.state;
        final items = store.items.toList();
        final filter = widget.filter;
        final onClearFilters = widget.onClearFilters;
        final isLoadingMore = state is CrudLoadingState && state.isRefreshing;

        final Widget body;
        if (_firstPageFailed && state is CrudErrorState) {
          body = SliverToBoxAdapter(
            child: PanelErrorState(message: state.failure.message, onRetry: _retry),
          );
        } else if (state is CrudInitialState ||
            (state is CrudLoadingState && !state.isRefreshing)) {
          body = PanelListSkeleton(isGrid: widget.isGrid);
        } else if (items.isEmpty) {
          body = SliverToBoxAdapter(child: PanelEmptyState(info: widget.empty));
        } else {
          final visible = filter == null ? items : items.where(filter).toList();
          final clear = filter == null ? null : onClearFilters;

          if (visible.isEmpty && clear != null) {
            body = SliverToBoxAdapter(child: PanelNoResultsState(onClearFilters: clear));
          } else {
            final loadMore = _loadMoreFailed ? _retryLoadMore : null;
            final footer = PanelListFooter.isNeeded(
              onClearFilters: clear,
              onLoadMore: loadMore,
              isLoadingMore: isLoadingMore,
            )
                ? PanelListFooter(
                    onClearFilters: clear,
                    onLoadMore: loadMore,
                    isLoadingMore: isLoadingMore,
                  )
                : null;
            body = widget.bodyBuilder(visible, footer);
          }
        }

        return PanelSectionScroll(
          controller: _scrollController,
          header: widget.header,
          filterBar: widget.filterBar,
          onNearEnd: widget.paginated ? _loadMore : null,
          body: body,
        );
      },
    );
  }
}
