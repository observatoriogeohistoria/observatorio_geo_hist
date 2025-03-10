import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/general_content/error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/general_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/markdown/markdown_text.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/fetch_posts_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostDetailedPage extends StatefulWidget {
  const PostDetailedPage({
    required this.area,
    required this.categoryKey,
    required this.postId,
    super.key,
  });

  final PostsAreas area;
  final String categoryKey;
  final String postId;

  @override
  State<PostDetailedPage> createState() => _PostDetailedPageState();
}

class _PostDetailedPageState extends State<PostDetailedPage> {
  late final FetchCategoriesStore fetchCategoriesStore = HomeSetup.getIt<FetchCategoriesStore>();
  late final FetchPostsStore fetchPostsStore = HomeSetup.getIt<FetchPostsStore>();

  List<ReactionDisposer> reactions = [];

  ValueNotifier<CategoryModel?> categoryNotifier = ValueNotifier(null);
  ValueNotifier<PostModel?> postNotifier = ValueNotifier(null);

  bool error = false;

  @override
  void initState() {
    super.initState();

    setupReactions();
    updateData();
  }

  @override
  void didUpdateWidget(covariant PostDetailedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateData();
  }

  @override
  void dispose() {
    for (var dispose in reactions) {
      dispose();
    }
    categoryNotifier.dispose();
    postNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme(context).colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Navbar()),
          ValueListenableBuilder<PostModel?>(
            valueListenable: postNotifier,
            builder: (context, post, child) {
              if (error) return const ErrorContent(isSliver: true);
              if (post == null) return const LoadingContent(isSliver: true);
              return _buildPostContent(context, post);
            },
          ),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, PostModel post) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2,
          vertical: 2 * AppTheme(context).dimensions.space.large,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeadline.small(
              text: post.title.toUpperCase(),
              textAlign: TextAlign.start,
              color: AppTheme(context).colors.orange,
            ),
            SizedBox(height: AppTheme(context).dimensions.space.small),
            AppTitle.small(
              text: post.subtitle.toUpperCase(),
              color: AppTheme(context).colors.gray,
            ),
            SizedBox(height: AppTheme(context).dimensions.space.large),
            MarkdownText(text: post.markdownContent),
          ],
        ),
      ),
    );
  }

  void setupReactions() {
    reactions.addAll([
      reaction((_) => fetchCategoriesStore.historyCategories, (_) => updateCategoryAndFetchPosts()),
      reaction(
          (_) => fetchCategoriesStore.geographyCategories, (_) => updateCategoryAndFetchPosts()),
      reaction((_) => fetchPostsStore.posts, (_) => updatePost()),
    ]);
  }

  void updateData() {
    categoryNotifier = ValueNotifier(
        fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey));
    postNotifier = ValueNotifier(fetchPostsStore.getPostById(widget.postId));

    setState(() => error = postNotifier.value == null);
    if (categoryNotifier.value != null) fetchPostsStore.fetchPosts(categoryNotifier.value!);
  }

  void updateCategoryAndFetchPosts() {
    categoryNotifier.value =
        fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);

    setState(() => error = categoryNotifier.value == null);
    if (categoryNotifier.value != null) fetchPostsStore.fetchPosts(categoryNotifier.value!);
  }

  void updatePost() {
    postNotifier.value = fetchPostsStore.getPostById(widget.postId);

    setState(() => error = postNotifier.value == null);
  }
}
