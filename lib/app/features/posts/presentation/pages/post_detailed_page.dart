import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/page_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/loading_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/network_image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/view_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/social_icons.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/fetch_posts_store.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/fetch_posts_states.dart';
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

  bool get isMobile => DeviceUtils.isMobile(context);
  bool get isTablet => DeviceUtils.isTablet(context);
  bool get isDesktop => DeviceUtils.isDesktop(context);

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
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Navbar()),
          ValueListenableBuilder<PostModel?>(
            valueListenable: postNotifier,
            builder: (context, post, child) {
              if (error) return const PageErrorContent(isSliver: true);
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
          horizontal: (isDesktop
                  ? (2 * AppTheme.dimensions.space.gigantic)
                  : (isTablet
                      ? AppTheme.dimensions.space.gigantic
                      : AppTheme.dimensions.space.large))
              .horizontalSpacing,
          vertical: AppTheme.dimensions.space.massive.verticalSpacing,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeadline.big(
              text: post.title.toUpperCase(),
              textAlign: TextAlign.start,
              color: AppTheme.colors.orange,
            ),
            SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
            AppTitle.big(
              text: post.subtitle.toUpperCase(),
              color: AppTheme.colors.gray,
            ),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
            for (var author in post.authors)
              AppTitle.small(
                text: author,
                color: AppTheme.colors.orange,
              ),
            SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
            AppTitle.medium(
              text: post.date,
              color: AppTheme.colors.darkGray,
            ),
            SizedBox(height: AppTheme.dimensions.space.massive.verticalSpacing),
            SocialIcons(post: post),
            SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
            const AppDivider(),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
            AppNetworkImage(
              imageUrl: post.imgUrl,
              height: null,
            ),
            if (post.imgCaption != null)
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                    AppTitle.small(
                      text: post.imgCaption!,
                      textAlign: TextAlign.start,
                      color: AppTheme.colors.gray,
                    ),
                  ],
                ),
              ),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
            ViewQuill(initialContent: post.markdownContent),
            if (post.observation != null)
              Column(
                children: [
                  SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppTheme.dimensions.space.large.horizontalSpacing,
                      vertical: AppTheme.dimensions.space.medium.verticalSpacing,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.lightGray,
                      borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
                    ),
                    child: ViewQuill(initialContent: post.observation),
                  ),
                ],
              ),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
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
      reaction((_) => fetchCategoriesStore.state, (_) {
        if (fetchCategoriesStore.state is FetchCategoriesErrorState) {
          setState(() => error = true);
        }
      }),
      reaction((_) => fetchPostsStore.state, (_) {
        if (fetchPostsStore.state is FetchPostsErrorState) {
          setState(() => error = true);
        }
      }),
    ]);
  }

  void updateData() {
    categoryNotifier.value =
        fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);
    postNotifier.value = fetchPostsStore.getPostById(widget.postId);

    if (categoryNotifier.value != null) fetchPostsStore.fetchPosts(categoryNotifier.value!);
  }

  void updateCategoryAndFetchPosts() {
    categoryNotifier.value =
        fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);

    if (categoryNotifier.value != null) fetchPostsStore.fetchPosts(categoryNotifier.value!);
  }

  void updatePost() {
    postNotifier.value = fetchPostsStore.getPostById(widget.postId);
    if (postNotifier.value != null) setState(() => error = false);
  }
}
