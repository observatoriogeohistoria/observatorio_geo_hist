import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/features/posts/posts_setup.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/fetch_posts_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({
    required this.category,
    super.key,
  });

  final CategoryModel category;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late FetchPostsStore fetchPostsStore;

  @override
  void initState() {
    super.initState();

    fetchPostsStore = PostsSetup.getIt<FetchPostsStore>();
    fetchPostsStore.fetchPosts(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://observatoriogeohistoria.net.br/wp-content/themes/observatorio/img/opiniao.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
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
                        TitleWidget(title: widget.category.title.toUpperCase()),
                        SizedBox(height: AppTheme.dimensions.space.xlarge),
                        Text(
                          'Acompanhe reflexões e debates sobre Educação, Cultura e ensino de História e Geografia. Pesquisadores, professores e estudantes lançam luz sobre temas como políticas públicas, formação e os desafios da prática pedagógica.',
                          textAlign: TextAlign.center,
                          style: AppTheme.typography.headline.medium.copyWith(
                            color: AppTheme.colors.white,
                          ),
                        ),
                        SizedBox(height: AppTheme.dimensions.space.xlarge),
                        if (widget.category.collaborateOption)
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
            Observer(builder: (context) {
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
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: fetchPostsStore.posts.length,
                        itemBuilder: (context, index) {
                          final post = fetchPostsStore.posts[index];

                          return Container(
                            width: 160,
                            padding: EdgeInsets.all(AppTheme.dimensions.space.small),
                            decoration: BoxDecoration(
                              color: AppTheme.colors.white,
                              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  post.title,
                                  style: AppTheme.typography.headline.medium,
                                ),
                                // Text(post.content),
                              ],
                            ),
                          );
                        },
                      )
                  ],
                ),
              );
            }),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
