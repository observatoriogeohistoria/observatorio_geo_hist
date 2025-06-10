import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/page_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/loading_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/support/support.dart';
import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/artist_model.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/document_model.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/academic_production_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/article_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/artist_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/book_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/document_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/event_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/film_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/magazine_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/music_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/podcast_content.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post_content/search_content.dart';
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
          const SliverToBoxAdapter(child: Support()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, PostModel post) {
    Widget content;

    switch (post.type) {
      case PostType.article:
        content = ArticleContent(
          post: post,
          article: post.body! as ArticleModel,
        );
        break;
      case PostType.document:
        content = DocumentContent(
          post: post,
          document: post.body! as DocumentModel,
        );
        break;
      case PostType.book:
        content = BookContent(
          post: post,
          book: post.body! as BookModel,
        );
        break;
      case PostType.film:
        content = FilmContent(
          post: post,
          film: post.body! as FilmModel,
        );
        break;
      case PostType.magazine:
        content = MagazineContent(
          post: post,
          magazine: post.body! as MagazineModel,
        );
        break;
      case PostType.podcast:
        content = PodcastContent(
          post: post,
          podcast: post.body! as PodcastModel,
        );
        break;
      case PostType.music:
        content = MusicContent(
          post: post,
          music: post.body! as MusicModel,
        );
        break;
      case PostType.artist:
        content = ArtistContent(
          post: post,
          artis: post.body! as ArtistModel,
        );
        break;
      case PostType.academicProduction:
        content = AcademicProductionContent(
          post: post,
          academicProduction: post.body! as AcademicProductionModel,
        );
        break;
      case PostType.event:
        content = EventContent(
          post: post,
          event: post.body! as EventModel,
        );
        break;
      case PostType.search:
        content = SearchContent(
          post: post,
          search: post.body! as SearchModel,
        );
        break;
    }

    return SliverToBoxAdapter(child: content);
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
