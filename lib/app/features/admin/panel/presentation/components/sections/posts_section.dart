import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_footer.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_section_scroll.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/panel_action.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/post_row.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/posts_filter_bar.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/posts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/labels/post_type_panel_labels.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';

class PostsSection extends StatefulWidget {
  const PostsSection({super.key});

  @override
  State<PostsSection> createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();
  late final PostsStore postsStore = PanelSetup.getIt<PostsStore>();
  late final CategoriesStore categoriesStore = PanelSetup.getIt<CategoriesStore>();
  late final SidebarStore sidebarStore = PanelSetup.getIt<SidebarStore>();
  late final PanelCountsStore countsStore = PanelSetup.getIt<PanelCountsStore>();

  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _pending = PendingPanelAction();
  List<ReactionDisposer> _reactions = [];

  late PostType _type = sidebarStore.selectedPostType ?? PostType.article;
  bool _loadingFirstPage = false;
  bool _loadingMore = false;
  bool _firstPageFailed = false;

  // Depois de uma falha ao carregar mais, a próxima tentativa é pelo botão, não a cada rolada.
  bool _loadMoreFailed = false;

  String _searchText = '';
  PostsAreas? _area;
  CategoryModel? _category;
  bool? _isPublished;
  bool _onlyHighlighted = false;

  bool get _hasFilter =>
      _searchText.isNotEmpty ||
      _area != null ||
      _category != null ||
      _isPublished != null ||
      _onlyHighlighted;

  @override
  void initState() {
    super.initState();

    _reactions = [
      reaction(
        (_) => sidebarStore.selectedPostType,
        (PostType? type) {
          _resetFilters();
          setState(() => _type = type ?? PostType.article);
          _fetch(reset: true);
        },
      ),
      reaction((_) => postsStore.state, _handleState),
    ];

    categoriesStore.getItems();
    _fetch(reset: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  void _handleState(CrudState state) {
    if (state is CrudLoadingState) _loadingFirstPage = !state.isRefreshing;

    final isFirstPageError = state is CrudErrorState && _loadingFirstPage;
    if (isFirstPageError) setState(() => _firstPageFailed = true);
    final isLoadMoreError = state is CrudErrorState && _loadingMore;
    if (isLoadMoreError) setState(() => _loadMoreFailed = true);
    if (state is! CrudLoadingState) _loadingMore = false;

    showPanelActionResult(
      context,
      state: state,
      pending: _pending,
      messages: const {
        PanelAction.delete: 'Publicação excluída.',
        PanelAction.publish: 'Publicado. Já aparece no site.',
        PanelAction.unpublish: 'Despublicado. Saiu do site.',
        PanelAction.highlight: 'Destacado na Home.',
        PanelAction.unhighlight: 'Saiu dos destaques da Home.',
      },
      onForbidden: authStore.logout,
      isFirstPageLoad: isFirstPageError,
    );

    if (state is CrudSuccessState && postsStore.hasMore(_type)) {
      loadMoreIfNotScrollable(_scrollController, _loadMore);
    }
  }

  void _fetch({bool reset = false}) {
    if (_firstPageFailed || _loadMoreFailed) {
      setState(() {
        _firstPageFailed = false;
        _loadMoreFailed = false;
      });
    }
    postsStore.getPosts(
      _type,
      searchText: _searchText.isEmpty ? null : _searchText,
      searchArea: _area,
      searchCategory: _category,
      isPublished: _isPublished,
      isHighlighted: _onlyHighlighted ? true : null,
      reset: reset,
    );
  }

  void _loadMore() {
    if (_firstPageFailed || _loadMoreFailed || !postsStore.hasMore(_type)) return;
    _fetchMore();
  }

  void _retryLoadMore() => _fetchMore();

  void _fetchMore() {
    final before = postsStore.state;
    _fetch();
    if (!identical(before, postsStore.state)) _loadingMore = true;
  }

  void _retry() {
    if (categoriesStore.items.isEmpty) categoriesStore.getItems();
    _fetch(reset: true);
  }

  void _resetFilters() {
    _searchController.clear();
    _searchText = '';
    _area = null;
    _category = null;
    _isPublished = null;
    _onlyHighlighted = false;
  }

  void _clearFilters() {
    setState(_resetFilters);
    _fetch();
  }

  void _setFilter(VoidCallback change) {
    setState(change);
    _fetch();
  }

  // A imagem vai como URL, para salvar não tentar enviá-la de novo.
  PostModel _keepImage(PostModel post) =>
      post.copyWith(body: post.body?.copyWith(image: FileModel(url: post.body?.image.url)));

  void _togglePublished(PostModel post) {
    _pending.start(post.isPublished ? PanelAction.unpublish : PanelAction.publish);
    postsStore.createOrUpdatePost(
      _keepImage(post).copyWith(isPublished: !post.isPublished),
      null,
    );
  }

  void _toggleHighlighted(PostModel post) {
    _pending.start(post.isHighlighted ? PanelAction.unhighlight : PanelAction.highlight);
    postsStore.createOrUpdatePost(
      _keepImage(post).copyWith(isHighlighted: !post.isHighlighted),
      null,
    );
  }

  Future<void> _delete(PostModel post) async {
    final title = post.body?.title ?? '';
    final confirmed = await showConfirmDialog(
      context,
      title: 'Excluir esta publicação?',
      message: title.isEmpty
          ? 'Ela sai do site e do painel. Não dá para desfazer.'
          : '“$title” sai do site e do painel. Não dá para desfazer.',
    );
    if (!confirmed) return;
    _pending.start(PanelAction.delete);
    postsStore.deletePost(post);
  }

  void _openForm([PostModel? post]) {
    final type = post?.type ?? _type;
    final id = post?.id;
    GoRouter.of(context).go(
      post == null || id == null
          ? AppRoutes.panelPostNew(type.value)
          : AppRoutes.panelPostEdit(post.categoryId, id),
    );
  }

  String? _summary(int? count) {
    if (count == null) return null;
    return count == 0 ? 'Nenhuma ainda' : '$count no total';
  }

  PanelEmptyInfo _empty(bool canEdit) {
    final createLabel = _type.panelCreateLabel;
    final isFeminine = createLabel.startsWith('Nova');
    return PanelEmptyInfo(
      icon: Icons.layers_outlined,
      title: 'Nada em ${_type.panelPlural} ainda',
      message: 'Crie ${isFeminine ? 'a primeira e ela' : 'o primeiro e ele'} aparece aqui. '
          'Só vai para o site quando você publicar.',
      actionLabel: canEdit ? createLabel : null,
      onAction: _openForm,
    );
  }

  Widget _body(bool canEdit) {
    final postsState = postsStore.state;
    final categoriesState = categoriesStore.state;
    final categoriesFailed = categoriesState is CrudErrorState && categoriesStore.items.isEmpty;
    final posts = postsStore.posts[_type] ?? [];

    if (_firstPageFailed && postsState is CrudErrorState) {
      return SliverToBoxAdapter(
        child: PanelErrorState(message: postsState.failure.message, onRetry: _retry),
      );
    }
    if (categoriesFailed) {
      return SliverToBoxAdapter(
        child: PanelErrorState(message: categoriesState.failure.message, onRetry: _retry),
      );
    }

    final loadingPosts = postsState is CrudInitialState ||
        (postsState is CrudLoadingState && !postsState.isRefreshing);
    final loadingCategories = categoriesState is CrudLoadingState && categoriesStore.items.isEmpty;
    if (loadingPosts || loadingCategories) return const PanelListSkeleton();

    if (posts.isEmpty) {
      return SliverToBoxAdapter(
        child: _hasFilter
            ? PanelNoResultsState(onClearFilters: _clearFilters)
            : PanelEmptyState(info: _empty(canEdit)),
      );
    }

    final isLoadingMore = postsState is CrudLoadingState;
    final clear = _hasFilter ? _clearFilters : null;
    final loadMore = _loadMoreFailed ? _retryLoadMore : null;

    return PanelList(
      itemCount: posts.length,
      footer: PanelListFooter.isNeeded(
        onClearFilters: clear,
        onLoadMore: loadMore,
        isLoadingMore: isLoadingMore,
      )
          ? PanelListFooter(
              onClearFilters: clear,
              onLoadMore: loadMore,
              isLoadingMore: isLoadingMore,
            )
          : null,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostRow(
          key: ValueKey(post.id),
          post: post,
          canEdit: canEdit,
          onPublish: () => _togglePublished(post),
          onHighlight: () => _toggleHighlighted(post),
          onEdit: () => _openForm(post),
          onDelete: () => _delete(post),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final canEdit = authStore.user?.permissions.canEditPostsSection ?? false;
        final area = _area;
        final categories = categoriesStore.items
            .where((category) => area == null || category.areas.contains(area))
            .toList();

        return PanelSectionScroll(
          controller: _scrollController,
          onNearEnd: _loadMore,
          header: PanelSectionHeader(
            eyebrow: SidebarItem.posts.eyebrow,
            title: _type.panelPlural,
            summary: _summary(countsStore.counts.posts(_type)),
            actionLabel: canEdit ? _type.panelCreateLabel : null,
            onAction: _openForm,
          ),
          filterBar: PostsFilterBar(
            searchController: _searchController,
            onSearch: (text) => _setFilter(() => _searchText = text.trim()),
            area: _area,
            onAreaChanged: (area) => _setFilter(() {
              _area = area;
              _category = null;
            }),
            categories: categories,
            category: _category,
            onCategoryChanged: (category) => _setFilter(() => _category = category),
            isPublished: _isPublished,
            onPublishedChanged: (value) => _setFilter(() => _isPublished = value),
            onlyHighlighted: _onlyHighlighted,
            onHighlightedChanged: (value) => _setFilter(() => _onlyHighlighted = value),
          ),
          body: _body(canEdit),
        );
      },
    );
  }
}
