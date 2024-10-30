import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
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

  final String area;
  final String categoryKey;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late FetchCategoriesStore fetchCategoriesStore;
  late FetchPostsStore fetchPostsStore;

  List<ReactionDisposer> reactions = [];
  ValueNotifier<CategoryModel?> categoryNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    fetchCategoriesStore = PostsSetup.getIt<FetchCategoriesStore>();
    fetchPostsStore = PostsSetup.getIt<FetchPostsStore>();

    setupReactions();
  }

  @override
  void didUpdateWidget(covariant PostsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    categoryNotifier = ValueNotifier(
        fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CategoryModel?>(
      valueListenable: categoryNotifier,
      builder: (context, category, child) {
        if (category != null) fetchPostsStore.fetchPosts(category);

        return Scaffold(
          backgroundColor: AppTheme.colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Navbar(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: (category?.backgroundImgUrl != null)
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(category!.backgroundImgUrl),
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.35),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.15,
                          vertical: AppTheme.dimensions.space.medium,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TitleWidget(title: category?.title.toUpperCase() ?? ''),
                            SizedBox(height: AppTheme.dimensions.space.xlarge),
                            Text(
                              'Acompanhe reflexões e debates sobre Educação, Cultura e ensino de História e Geografia. Pesquisadores, professores e estudantes lançam luz sobre temas como políticas públicas, formação e os desafios da prática pedagógica.',
                              textAlign: TextAlign.center,
                              style: AppTheme.typography.headline.medium.copyWith(
                                color: AppTheme.colors.white,
                              ),
                            ),
                            SizedBox(height: AppTheme.dimensions.space.xlarge),
                            if (category?.collaborateOption ?? false)
                              PrimaryButton(
                                text: 'COLABORE',
                                onPressed: () {},
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Observer(
                  builder: (context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.dimensions.space.large,
                        vertical: AppTheme.dimensions.space.medium,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(title: 'POSTS', color: AppTheme.colors.orange),
                          if (fetchPostsStore.posts.isNotEmpty)
                            for (final post in fetchPostsStore.posts) PostCard(post: post),
                        ],
                      ),
                    );
                  },
                ),
                const Footer(),
              ],
            ),
          ),
        );
      },
    );
  }

  void setupReactions() {
    reactions = [
      reaction((_) => fetchCategoriesStore.historyCategories, (_) {
        categoryNotifier.value =
            fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);
      }),
      reaction((_) => fetchCategoriesStore.geographyCategories, (_) {
        categoryNotifier.value =
            fetchCategoriesStore.getCategoryByAreaAndKey(widget.area, widget.categoryKey);
      }),
    ];
  }
}
