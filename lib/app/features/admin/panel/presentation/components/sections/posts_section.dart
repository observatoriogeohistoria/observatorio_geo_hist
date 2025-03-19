import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/loading.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/post_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_post_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/posts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/posts_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostsSection extends StatefulWidget {
  const PostsSection({super.key});

  @override
  State<PostsSection> createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
  late final PostsStore postsStore = PanelSetup.getIt<PostsStore>();
  late final CategoriesStore categoriesStore = PanelSetup.getIt<CategoriesStore>();
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    categoriesStore.getCategories();
    postsStore.getPosts();

    _reactions = [
      reaction((_) => postsStore.state, (state) {
        if (state is ManagePostsErrorState) {
          final error = state.failure;
          Messenger.showError(context, error.message);

          if (error is Forbidden) authStore.logout();
        }

        if (state is ManagePostsSuccessState) {
          if (state.message.isNotEmpty) {
            Messenger.showSuccess(context, state.message);
          }
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeadline.big(
          text: 'Posts',
          color: AppTheme(context).colors.orange,
        ),
        SizedBox(height: AppTheme(context).dimensions.space.xlarge),
        Align(
          alignment: Alignment.centerRight,
          child: SecondaryButton.medium(
            text: 'Criar post',
            onPressed: () {
              showCreateOrUpdatePostDialog(
                context,
                categories: categoriesStore.categories,
                onCreateOrUpdate: (post) => postsStore.createOrUpdatePost(post),
              );
            },
          ),
        ),
        SizedBox(height: AppTheme(context).dimensions.space.large),
        Expanded(
          child: Observer(
            builder: (context) {
              if (postsStore.state is ManagePostsLoadingState) {
                return const Center(child: Loading());
              }

              final posts = postsStore.posts;

              return ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: AppTheme(context).dimensions.space.large,
                ),
                separatorBuilder: (context, index) {
                  final isLast = index == posts.length - 1;

                  return isLast
                      ? const SizedBox()
                      : SizedBox(height: AppTheme(context).dimensions.space.medium);
                },
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return PostCard(
                    post: post,
                    index: index + 1,
                    onPublish: () =>
                        postsStore.createOrUpdatePost(post.copyWith(published: !post.published)),
                    onEdit: () {
                      showCreateOrUpdatePostDialog(
                        context,
                        post: post,
                        categories: categoriesStore.categories,
                        onCreateOrUpdate: (post) => postsStore.createOrUpdatePost(post),
                      );
                    },
                    onDelete: () => postsStore.deletePost(post),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
