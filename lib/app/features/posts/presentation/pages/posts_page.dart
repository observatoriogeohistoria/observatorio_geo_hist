import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/empty_content.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/page_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/loading_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/posts/posts_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/header/actions_header.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/header/category_header.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/posts_section_list.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/fetch_posts_store.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/fetch_posts_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({
    required this.area,
    required this.categoryKey,
    super.key,
  });

  final PostsAreas area;
  final String categoryKey;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late final _fetchCategoriesStore = PostsSetup.getIt<FetchCategoriesStore>();
  late final _fetchPostsStore = PostsSetup.getIt<FetchPostsStore>();

  List<ReactionDisposer> _reactions = [];

  final _scrollController = ScrollController();
  final ValueNotifier<CategoryModel?> _categoryNotifier = ValueNotifier(null);

  String? _searchText;
  bool _error = false;

  @override
  void initState() {
    super.initState();

    _setupReactions();
    updateCategory();
  }

  @override
  void didUpdateWidget(covariant PostsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCategory();
  }

  @override
  void dispose() {
    for (final disposer in _reactions) {
      disposer();
    }

    _fetchCategoriesStore.setSelectedCategory(null);
    _categoryNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverToBoxAdapter(child: Navbar()),
          ValueListenableBuilder<CategoryModel?>(
            valueListenable: _categoryNotifier,
            builder: (context, category, child) {
              if (_error) return const PageErrorContent(isSliver: true);
              if (category == null) return const LoadingContent(isSliver: true);

              return SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryHeader(category: category),
                    _buildPostsSection(category),
                  ],
                ),
              );
            },
          ),
          const SliverFillRemaining(hasScrollBody: false, child: SizedBox.shrink()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }

  Widget _buildPostsSection(CategoryModel category) {
    return Observer(
      builder: (context) {
        final state = _fetchPostsStore.state;

        if (state is FetchPostsLoadingState && !state.isRefreshing) {
          return Column(
            children: [
              SizedBox(height: AppTheme.dimensions.space.gigantic.verticalSpacing),
              const LoadingContent(isSliver: false),
            ],
          );
        }

        final posts = _fetchPostsStore.postsByType;
        final numberOfPostsTypes = _fetchCategoriesStore.selectedCategory?.postsTypes.length ?? 0;

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
              ActionsHeader(
                category: category,
                searchText: _searchText,
                onTextChanged: (text) {
                  _searchText = text;
                  fetchPosts();
                },
              ),
              SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
              if (posts.isEmpty) ...[
                const Center(child: EmptyContent(isSliver: false)),
                SizedBox(height: AppTheme.dimensions.space.massive.verticalSpacing),
              ],
              if (posts.isNotEmpty)
                PostsSectionList(
                  posts: posts,
                  numberOfPostsTypes: numberOfPostsTypes,
                  category: category,
                  hasMorePosts: (type) => _fetchPostsStore.hasMore[type] ?? false,
                  loadMorePosts: (type) => fetchPosts(postType: type),
                  loadMorePostsIsDisabled: state is FetchPostsLoadingState && state.isRefreshing,
                ),
            ],
          ),
        );
      },
    );
  }

  void _setupReactions() {
    _reactions = [
      reaction((_) => _fetchCategoriesStore.selectedCategory, (_) {
        updateCategory();
      }),
      reaction((_) => _fetchCategoriesStore.categories, (_) {
        updateCategory();
      }),
      reaction((_) => _fetchCategoriesStore.state, (_) {
        setState(() => _error = _fetchCategoriesStore.state is FetchCategoriesErrorState);
      }),
      reaction((_) => _fetchPostsStore.state, (_) {
        setState(() => _error = _fetchPostsStore.state is FetchPostsErrorState);
      }),
    ];
  }

  void updateCategory() {
    final category = _fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);
    if (category == null) return;

    if (_categoryNotifier.value?.key != category.key) {
      _categoryNotifier.value = category;

      _fetchPostsStore.reset();
      fetchPosts();
      _fetchCategoriesStore.setSelectedCategory(category);
    }
  }

  void fetchPosts({PostType? postType}) {
    if (_categoryNotifier.value == null) return;

    if (postType != null) {
      _fetchPostsStore.fetchPostsByType(_categoryNotifier.value!, postType,
          searchText: _searchText);
      return;
    }

    final postTypes = _categoryNotifier.value?.postsTypes ?? [];
    for (final postType in postTypes) {
      _fetchPostsStore.fetchPostsByType(_categoryNotifier.value!, postType,
          searchText: _searchText);
    }
  }
}
