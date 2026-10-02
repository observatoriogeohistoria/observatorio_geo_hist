import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_error_box.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/page_header.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/posts/posts_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/listing/category_page_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/listing/posts_listing.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/posts_listing_store.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/posts_listing_states.dart';
import 'package:observatorio_geo_hist/app/router/page_not_found.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

enum _CategoryState { loading, ready, notFound, error }

class PostsPage extends StatefulWidget {
  const PostsPage({required this.area, required this.categoryKey, super.key});

  final PostsAreas area;
  final String categoryKey;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late final _categoriesStore = PostsSetup.getIt<FetchCategoriesStore>();
  late final _store = PostsSetup.getIt<PostsListingStore>();
  late final ReactionDisposer _disposeReaction;

  bool _initializing = true;
  _CategoryState _state = _CategoryState.loading;
  CategoryModel? _category;

  /// A navbar recarrega as categorias a cada página, e isso não deve recarregar a lista.
  String? _requested;

  String get _address => '${widget.area.key}/${widget.categoryKey}';

  @override
  void initState() {
    super.initState();
    _disposeReaction = reaction((_) => _categoriesStore.state, (_) => _load());
    _load();
    _initializing = false;
  }

  @override
  void didUpdateWidget(covariant PostsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.area != widget.area || oldWidget.categoryKey != widget.categoryKey) {
      _requested = null;
      _load();
    }
  }

  @override
  void dispose() {
    _disposeReaction();
    super.dispose();
  }

  void _load() {
    final category = _categoriesStore.getCategoryByAreaAndKey(
      widget.area,
      widget.categoryKey,
    );

    if (category != null) {
      if (_requested == _address) return;
      _requested = _address;
      _categoriesStore.setSelectedCategory(category);
      _store.load(PostsListingScope.ofCategory(category));
      _setState(_CategoryState.ready, category);
      return;
    }

    _requested = null;
    // A 404 monta outra navbar, que recarrega as categorias: sem isso, a página
    // alternaria entre esqueleto e 404 sem parar.
    if (_state == _CategoryState.notFound) return;
    switch (_categoriesStore.state) {
      case FetchCategoriesSuccessState():
        _setState(_CategoryState.notFound, null);
      case FetchCategoriesErrorState():
        _setState(_CategoryState.error, null);
      case FetchCategoriesInitialState() || FetchCategoriesLoadingState():
        if (_category == null) _setState(_CategoryState.loading, null);
    }
  }

  void _setState(_CategoryState state, CategoryModel? category) {
    if (_state == state && _category == category) return;
    _state = state;
    _category = category;
    if (_initializing || !mounted) return;

    // A navbar busca as categorias no próprio initState, ou seja, durante o build.
    final scheduler = SchedulerBinding.instance;
    if (scheduler.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      scheduler.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
    } else {
      setState(() {});
    }
  }

  void _retry() {
    _setState(_CategoryState.loading, null);
    _categoriesStore.fetchCategories();
  }

  String _routeFor(PostModel post) =>
      AppRoutes.post(widget.area.key, post.categoryId, post.id ?? '');

  @override
  Widget build(BuildContext context) {
    final category = _category;

    final Widget body;
    Widget? header;
    switch (_state) {
      case _CategoryState.notFound:
        return const PageNotFound();
      case _CategoryState.loading:
        body = const CategoryPageSkeleton();
      case _CategoryState.error:
        body = PageContent(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppTheme.dimensions.components.listingStatePaddingBottom,
            ),
            child: StateErrorBox(onRetry: _retry),
          ),
        );
      case _CategoryState.ready:
        final description = category!.description.trim();
        header = PageHeader(
          breadcrumbs: [
            const BreadcrumbItem('Início', route: AppRoutes.root),
            BreadcrumbItem(widget.area.portuguese),
            BreadcrumbItem(category.title),
          ],
          title: category.title,
          lead: description.isEmpty ? null : description,
          action: category.hasCollaborateOption
              ? SecondaryButton.medium(
                  text: 'Colabore com esta categoria',
                  onPressed: () => GoRouter.of(context).go(AppRoutes.collaborate),
                )
              : null,
        );
        body = PostsListing(store: _store, routeFor: _routeFor);
    }

    // A chave por endereço volta ao topo ao trocar de categoria pelo menu.
    return ReadingPageScaffold(
      key: ValueKey(_address),
      header: header,
      body: body,
    );
  }
}
