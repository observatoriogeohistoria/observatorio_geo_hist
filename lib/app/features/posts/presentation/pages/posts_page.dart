import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/page_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/loading_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
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
        image: DecorationImage(
          image: NetworkImage(category.backgroundImgUrl),
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TitleWidget(title: category.title.toUpperCase()),
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
              onPressed: () => GoRouter.of(context).go('/collaborate'),
            ),
        ],
      ),
    );
  }

  Widget _buildPostsSection(CategoryModel category) {
    return Observer(
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: DeviceUtils.getPageHorizontalPadding(context),
            vertical: AppTheme.dimensions.space.huge.verticalSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleWidget(title: 'POSTS', color: AppTheme.colors.orange),
              SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
              if (fetchPostsStore.posts.isNotEmpty)
                AlignedGridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                  crossAxisSpacing: AppTheme.dimensions.space.medium.horizontalSpacing,
                  mainAxisSpacing: AppTheme.dimensions.space.medium.verticalSpacing,
                  itemCount: fetchPostsStore.posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(
                      category: category,
                      post: fetchPostsStore.posts[index],
                    );
                  },
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

    if (categoryNotifier.value != null) fetchPostsStore.fetchPosts(categoryNotifier.value!);
  }

  void updateCategory() {
    final category = fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);
    categoryNotifier.value = category;

    if (category != null) {
      fetchPostsStore.fetchPosts(category);
      fetchCategoriesStore.setSelectedCategory(category);
    }
  }
}
