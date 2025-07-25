import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/linear_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/post_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_post_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/section_header_actions.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/section_header_title.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/posts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

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

  final _scrollController = ScrollController();

  PostType selectedPostType = PostType.article;
  List<ReactionDisposer> _reactions = [];

  String? _searchText;
  PostsAreas? _searchArea;
  CategoryModel? _searchCategory;
  bool? _isPublished;
  bool? _isHighlighted;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    categoriesStore.getItems();

    selectedPostType = sidebarStore.selectedPostType ?? PostType.article;
    postsStore.getPosts(sidebarStore.selectedPostType ?? PostType.article);

    _reactions = [
      reaction(
        (_) => sidebarStore.selectedPostType,
        (PostType? postType) {
          setState(() => selectedPostType = postType ?? PostType.article);
          postsStore.getPosts(postType ?? PostType.article);
        },
      ),
      reaction(
        (_) => postsStore.state,
        (state) {
          if (state is CrudErrorState) {
            final error = state.failure;
            Messenger.showError(context, error.message);

            if (error is Forbidden) authStore.logout();
          }

          if (state is CrudSuccessState) {
            if (state.message.isNotEmpty) {
              GoRouter.of(context).pop();
              Messenger.showSuccess(context, state.message);
            }
          }
        },
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditPostsSection ?? false;
        bool categoriesLoading = postsStore.state is CrudLoadingState;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeaderTitle(
              title: selectedPostType.portuguesePlural,
              onCreate: () {
                showCreateOrUpdatePostDialog(
                  context,
                  categories: categoriesStore.items,
                  onCreateOrUpdate: (post, pastCategory) =>
                      postsStore.createOrUpdatePost(post, pastCategory),
                  postType: selectedPostType,
                  isLoading: postsStore.state is CrudLoadingState,
                );
              },
              canEdit: canEdit,
              isLoading: categoriesLoading,
            ),
            SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
            SectionHeaderActions(
              onTextChange: (text) => _onSearch(1, text: text),
              onAreaChange: (area) => _onSearch(2, area: area),
              onCategoryChange: (category) => _onSearch(3, category: category),
              onPublishedChange: (isPublished) => _onSearch(4, isPublished: isPublished),
              onHighlightedChange: (isHighlighted) => _onSearch(5, isHighlighted: isHighlighted),
              onClear: _onClear,
              selectedText: _searchText,
              selectedArea: _searchArea,
              selectedCategory: _searchCategory,
              isPublished: _isPublished,
              isHighlighted: _isHighlighted,
              categories: categoriesStore.items,
            ),
            Observer(
              builder: (context) {
                final state = postsStore.state;

                if (state is CrudLoadingState && state.isRefreshing) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: AppTheme.dimensions.space.medium.horizontalSpacing,
                    ),
                    child: const LinearLoading(),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
            Expanded(
              child: Observer(
                builder: (context) {
                  final postsState = postsStore.state;
                  final categoriesState = categoriesStore.state;

                  if (postsState is CrudLoadingState && !postsState.isRefreshing) {
                    return const Center(child: CircularLoading());
                  }

                  if (categoriesState is CrudLoadingState) {
                    return const Center(child: CircularLoading());
                  }

                  final posts = postsStore.posts[selectedPostType] ?? [];

                  return AppScrollbar(
                    controller: _scrollController,
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: AppTheme.dimensions.space.large.verticalSpacing,
                      ),
                      separatorBuilder: (context, index) {
                        final isLast = index == posts.length - 1;

                        return isLast
                            ? const SizedBox()
                            : SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing);
                      },
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        return PostCard(
                          post: post,
                          index: index + 1,
                          onPublish: () {
                            postsStore.createOrUpdatePost(
                              post.copyWith(
                                isPublished: !post.isPublished,
                                body: post.body?.copyWith(
                                  image: FileModel(url: post.body?.image.url),
                                ),
                              ),
                              null,
                            );
                          },
                          onHighlight: () {
                            postsStore.createOrUpdatePost(
                              post.copyWith(
                                isHighlighted: !post.isHighlighted,
                                body: post.body?.copyWith(
                                  image: FileModel(url: post.body?.image.url),
                                ),
                              ),
                              null,
                            );
                          },
                          onEdit: () {
                            showCreateOrUpdatePostDialog(
                              context,
                              categories: categoriesStore.items,
                              onCreateOrUpdate: (post, pastCategory) =>
                                  postsStore.createOrUpdatePost(post, pastCategory),
                              post: post,
                              postType: post.type,
                              isLoading: postsStore.state is CrudLoadingState,
                            );
                          },
                          onDelete: () => postsStore.deletePost(post),
                          canEdit: canEdit,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      postsStore.getPosts(
        sidebarStore.selectedPostType ?? PostType.article,
        searchText: _searchText,
        searchArea: _searchArea,
        searchCategory: _searchCategory,
        isPublished: _isPublished,
        isHighlighted: _isHighlighted,
      );
    }
  }

  void _onSearch(
    int action, {
    String? text,
    PostsAreas? area,
    CategoryModel? category,
    bool? isPublished,
    bool? isHighlighted,
  }) {
    setState(() {
      if (action == 1) _searchText = text;
      if (action == 2) _searchArea = area;
      if (action == 3) _searchCategory = category;
      if (action == 4) _isPublished = isPublished;
      if (action == 5) _isHighlighted = isHighlighted;
    });

    postsStore.getPosts(
      sidebarStore.selectedPostType ?? PostType.article,
      searchText: _searchText,
      searchArea: _searchArea,
      searchCategory: _searchCategory,
      isPublished: _isPublished,
      isHighlighted: _isHighlighted,
    );
  }

  void _onClear() {
    setState(() {
      _searchText = null;
      _searchArea = null;
      _searchCategory = null;
      _isPublished = null;
      _isHighlighted = null;
    });

    postsStore.getPosts(sidebarStore.selectedPostType ?? PostType.article);
  }
}
