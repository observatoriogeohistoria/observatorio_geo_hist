import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/empty_content.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/page_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/loading_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/common_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/header_actions.dart';
import 'package:observatorio_geo_hist/app/features/posts/posts_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_card.dart';
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
    updateData();
  }

  @override
  void didUpdateWidget(covariant PostsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateData();
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
                    _buildCategoryHeader(context, category),
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

  Widget _buildCategoryHeader(BuildContext context, CategoryModel category) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: isMobile ? null : MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.huge.verticalSpacing,
      ),
      decoration: BoxDecoration(
        image: (category.backgroundImg.url?.isNotEmpty ?? false)
            ? DecorationImage(
                image: NetworkImage(category.backgroundImg.url!),
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.5),
                  BlendMode.darken,
                ),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonTitle(title: category.title.toUpperCase()),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppBody.big(
            text: category.description,
            textAlign: TextAlign.center,
            color: AppTheme.colors.white,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          if (category.hasCollaborateOption)
            PrimaryButton.medium(
              text: 'COLABORE',
              onPressed: () => GoRouter.of(context).go('/colaborar'),
            ),
        ],
      ),
    );
  }

  Widget _buildPostsSection(CategoryModel category) {
    return Observer(
      builder: (context) {
        if (fetchPostsStore.state is FetchPostsLoadingState) {
          return Column(
            children: [
              SizedBox(height: AppTheme.dimensions.space.gigantic.verticalSpacing),
              const LoadingContent(isSliver: false),
            ],
          );
        }

        final posts = fetchPostsStore.posts;

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: DeviceUtils.getPageHorizontalPadding(context),
            vertical: AppTheme.dimensions.space.huge.verticalSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderActions(
                category: category,
                searchText: searchText,
                onTextChanged: (text) {
                  searchText = text;
                  fetchPostsStore.fetchPosts(category, searchText: text);
                },
              ),
              SizedBox(
                height: isMobile
                    ? AppTheme.dimensions.space.huge.verticalSpacing
                    : AppTheme.dimensions.space.gigantic.verticalSpacing,
              ),
              if (posts.isEmpty) const Center(child: EmptyContent(isSliver: false)),
              if (posts.isNotEmpty)
                isMobile
                    ? ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: AppTheme.dimensions.space.large.verticalSpacing,
                            ),
                            child: AppDivider(
                              color: AppTheme.colors.gray.withValues(alpha: 0.2),
                            ),
                          );
                        },
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return PostCard(
                            category: category,
                            post: posts[index],
                            index: index,
                          );
                        },
                      )
                    : StaggeredGrid.count(
                        crossAxisCount: isTablet ? 2 : 3,
                        mainAxisSpacing: AppTheme.dimensions.space.gigantic.verticalSpacing,
                        crossAxisSpacing: AppTheme.dimensions.space.massive.horizontalSpacing,
                        children: [
                          for (final post in posts)
                            PostCard(
                              category: category,
                              post: post,
                              index: posts.indexOf(post),
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
      reaction((_) => fetchCategoriesStore.historyCategories, (_) => updateCategory()),
      reaction((_) => fetchCategoriesStore.geographyCategories, (_) => updateCategory()),
      reaction((_) => fetchCategoriesStore.state, (_) {
        setState(() => error = fetchCategoriesStore.state is FetchCategoriesErrorState);
      }),
      reaction((_) => fetchPostsStore.state, (_) {
        setState(() => error = fetchPostsStore.state is FetchPostsErrorState);
      }),
    ];
  }

  void updateData() {
    categoryNotifier.value =
        fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);

    if (categoryNotifier.value != null) {
      fetchPostsStore.fetchPosts(categoryNotifier.value!, searchText: searchText);
    }
  }

  void updateCategory() {
    final category = fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);
    categoryNotifier.value = category;

    if (category != null) {
      fetchPostsStore.fetchPosts(category, searchText: searchText);
      fetchCategoriesStore.setSelectedCategory(category);
    }
  }
}
