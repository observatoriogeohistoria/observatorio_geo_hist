import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/empty_content.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/page_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/loading_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/posts/posts_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/header/actions_header.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/header/category_header.dart';
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
  late final FetchCategoriesStore fetchCategoriesStore = PostsSetup.getIt<FetchCategoriesStore>();
  late final FetchPostsStore fetchPostsStore = PostsSetup.getIt<FetchPostsStore>();

  bool get isMobile => DeviceUtils.isMobile(context);
  bool get isTablet => DeviceUtils.isTablet(context);
  bool get isDesktop => DeviceUtils.isDesktop(context);

  List<ReactionDisposer> reactions = [];
  ValueNotifier<CategoryModel?> categoryNotifier = ValueNotifier(null);

  String? searchText;

  bool error = false;

  @override
  void initState() {
    super.initState();

    setupReactions();
    updateCategory();
  }

  @override
  void didUpdateWidget(covariant PostsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateCategory();
  }

  @override
  void dispose() {
    for (final disposer in reactions) {
      disposer();
    }

    fetchCategoriesStore.setSelectedCategory(null);
    categoryNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Navbar()),
          ValueListenableBuilder<CategoryModel?>(
            valueListenable: categoryNotifier,
            builder: (context, category, child) {
              if (error) return const PageErrorContent(isSliver: true);
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
        final state = fetchPostsStore.state;

        if (state is FetchPostsLoadingState && !state.isRefreshing) {
          return Column(
            children: [
              SizedBox(height: AppTheme.dimensions.space.gigantic.verticalSpacing),
              const LoadingContent(isSliver: false),
            ],
          );
        }

        final posts = fetchPostsStore.posts;
        final numberOfPostsTypes = fetchCategoriesStore.selectedCategory?.postsTypes.length ?? 0;

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActionsHeader(
                category: category,
                searchText: searchText,
                onTextChanged: (text) {
                  searchText = text;
                  // fetchPostsStore.fetchPosts(category, searchText: text);
                },
              ),
              SizedBox(
                height: isMobile
                    ? AppTheme.dimensions.space.huge.verticalSpacing
                    : AppTheme.dimensions.space.gigantic.verticalSpacing,
              ),
              if (posts.isEmpty) const Center(child: EmptyContent(isSliver: false)),
              if (posts.isNotEmpty)
                // isMobile
                //     ? ListView.separated(
                //         physics: const NeverScrollableScrollPhysics(),
                //         shrinkWrap: true,
                //         separatorBuilder: (context, index) {
                //           return Container(
                //             margin: EdgeInsets.symmetric(
                //               vertical: AppTheme.dimensions.space.large.verticalSpacing,
                //             ),
                //             child: AppDivider(
                //               color: AppTheme.colors.gray.withValues(alpha: 0.2),
                //             ),
                //           );
                //         },
                //         itemCount: posts.length,
                //         itemBuilder: (context, index) {
                //           return PostCard(
                //             category: category,
                //             post: posts[index],
                //             index: index,
                //           );
                //         },
                //       )
                //     :
                Column(
                  children: [
                    for (final entry in posts.entries)
                      Column(
                        children: [
                          if (numberOfPostsTypes > 1)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppTheme.dimensions.space.massive.horizontalSpacing,
                                vertical: AppTheme.dimensions.space.medium.verticalSpacing,
                              ),
                              width: double.infinity,
                              color: AppTheme.colors.gray,
                              child: Center(
                                child: AppHeadline.big(
                                  text: entry.key.portuguese,
                                  color: AppTheme.colors.white,
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DeviceUtils.getPageHorizontalPadding(context),
                              vertical: AppTheme.dimensions.space.huge.verticalSpacing,
                            ),
                            child: StaggeredGrid.count(
                              crossAxisCount: isTablet ? 2 : 3,
                              mainAxisSpacing: AppTheme.dimensions.space.gigantic.verticalSpacing,
                              crossAxisSpacing: AppTheme.dimensions.space.massive.horizontalSpacing,
                              children: [
                                for (final post in entry.value)
                                  PostCard(
                                    category: category,
                                    post: post,
                                    index: entry.value.indexOf(post),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                          PrimaryButton.big(
                            text: 'Ver mais',
                            onPressed: () => fetchPosts(postType: entry.key),
                            isDisabled: state is FetchPostsLoadingState && state.isRefreshing,
                          ),
                          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                        ],
                      ),
                  ],
                ),
              SizedBox(
                height: isMobile
                    ? AppTheme.dimensions.space.huge.verticalSpacing
                    : AppTheme.dimensions.space.gigantic.verticalSpacing,
              ),
            ],
          ),
        );
      },
    );
  }

  void setupReactions() {
    reactions = [
      reaction((_) => fetchCategoriesStore.selectedCategory, (_) {
        updateCategory();
      }),
      reaction((_) => fetchCategoriesStore.categories, (_) {
        updateCategory();
      }),
      reaction((_) => fetchCategoriesStore.state, (_) {
        setState(() => error = fetchCategoriesStore.state is FetchCategoriesErrorState);
      }),
      reaction((_) => fetchPostsStore.state, (_) {
        setState(() => error = fetchPostsStore.state is FetchPostsErrorState);
      }),
    ];
  }

  void updateCategory() {
    final category = fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);
    if (category == null) return;

    if (categoryNotifier.value?.key != category.key) {
      categoryNotifier.value = category;

      fetchPosts();
      fetchCategoriesStore.setSelectedCategory(category);
    }
  }

  void fetchPosts({PostType? postType}) {
    if (categoryNotifier.value == null) return;

    if (postType != null) {
      fetchPostsStore.fetchPosts(categoryNotifier.value!, postType, searchText: searchText);
      return;
    }

    for (final postType in (categoryNotifier.value?.postsTypes ?? [])) {
      fetchPostsStore.fetchPosts(categoryNotifier.value!, postType, searchText: searchText);
    }
  }
}
