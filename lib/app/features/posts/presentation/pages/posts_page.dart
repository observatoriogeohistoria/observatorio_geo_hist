import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/general_content/error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/general_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/features/posts/posts_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_card.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/fetch_posts_store.dart';
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
      backgroundColor: AppTheme(context).colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),
            ValueListenableBuilder<CategoryModel?>(
              valueListenable: categoryNotifier,
              builder: (context, category, child) {
                if (error) return const ErrorContent(isSliver: false);
                if (category == null) return const LoadingContent(isSliver: false);

                return Column(
                  children: [
                    _buildCategoryHeader(context, category),
                    _buildPostsSection(category),
                  ],
                );
              },
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, CategoryModel category) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(category.backgroundImgUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            color: Colors.black.withValues(alpha: .35),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15,
              vertical: AppTheme(context).dimensions.space.medium,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleWidget(title: category.title.toUpperCase()),
                SizedBox(height: AppTheme(context).dimensions.space.xlarge),
                AppBody.big(
                  text: category.description,
                  textAlign: TextAlign.center,
                  color: AppTheme(context).colors.white,
                ),
                SizedBox(height: AppTheme(context).dimensions.space.xlarge),
                if (category.collaborateOption)
                  PrimaryButton.medium(
                    text: 'COLABORE',
                    onPressed: () => GoRouter.of(context).go('/collaborate'),
                  ),
              ],
            ),
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
            horizontal: AppTheme(context).dimensions.space.xlarge,
            vertical: AppTheme(context).dimensions.space.xlarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleWidget(title: 'POSTS', color: AppTheme(context).colors.orange),
              SizedBox(height: AppTheme(context).dimensions.space.medium),
              if (fetchPostsStore.posts.isNotEmpty)
                ...fetchPostsStore.posts.map(
                  (post) => PostCard(
                    category: category,
                    post: post,
                  ),
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
    ];
  }

  void updateData() {
    categoryNotifier = ValueNotifier(
        fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey));

    setState(() => error = categoryNotifier.value == null);
    if (categoryNotifier.value != null) fetchPostsStore.fetchPosts(categoryNotifier.value!);
  }

  void updateCategory() {
    final category = fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);
    categoryNotifier.value = category;

    setState(() => error = category == null);

    if (category != null) fetchPostsStore.fetchPosts(category);
  }
}
