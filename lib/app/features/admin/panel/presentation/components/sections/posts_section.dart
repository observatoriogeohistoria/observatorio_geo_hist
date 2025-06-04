import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/linear_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/post_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_post_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/posts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostsSection extends StatefulWidget {
  const PostsSection({super.key});

  @override
  State<PostsSection> createState() => _PostsSectionState();
}

class _PostsSectionState extends State<PostsSection> {
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();
  late final PostsStore postsStore = PanelSetup.getIt<PostsStore>();
  late final CategoriesStore categoriesStore = PanelSetup.getIt<CategoriesStore>();
  late final SidebarStore sidebarStore = PanelSetup.getIt<SidebarStore>();

  final _scrollController = ScrollController();

  PostType selectedPostType = PostType.article;
  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    categoriesStore.getItems();

    selectedPostType = sidebarStore.selectedPostType ?? PostType.article;
    postsStore.getPosts(sidebarStore.selectedPostType ?? PostType.article);

    _reactions = [
      reaction(
        (_) => sidebarStore.selectedPostType,
        (PostType? postType) {
          setState(() => selectedPostType = postType ?? PostType.article);
          postsStore.getPosts(postType ?? PostType.article);
        },
      ),
      reaction(
        (_) => postsStore.state,
        (state) {
          if (state is CrudErrorState) {
            final error = state.failure;
            Messenger.showError(context, error.message);

            if (error is Forbidden) authStore.logout();
          }

          if (state is CrudSuccessState) {
            if (state.message.isNotEmpty) {
              GoRouter.of(context).pop();
              Messenger.showSuccess(context, state.message);
            }
          }
        },
      ),
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
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditPostsSection ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeadline.big(
              text: selectedPostType.portuguesePlural,
              color: AppTheme.colors.orange,
            ),
            if (canEdit) ...[
              SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: AppTheme.dimensions.space.medium.horizontalSpacing,
                  ),
                  child: SecondaryButton.medium(
                    text: 'Criar',
                    onPressed: () {
                      showCreateOrUpdatePostDialog(
                        context,
                        categories: categoriesStore.items,
                        onCreateOrUpdate: (post) => postsStore.createOrUpdatePost(post),
                        postType: selectedPostType,
                        isLoading: postsStore.state is CrudLoadingState,
                      );
                    },
                    isDisabled: categoriesStore.state is CrudLoadingState,
                  ),
                ),
              ),
            ],
            Observer(
              builder: (context) {
                final state = postsStore.state;

                if (state is CrudLoadingState && state.isRefreshing) {
                  return const LinearLoading();
                }

                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
            Expanded(
              child: Observer(
                builder: (context) {
                  final postsState = postsStore.state;
                  final categoriesState = categoriesStore.state;

                  if (postsState is CrudLoadingState && !postsState.isRefreshing) {
                    return const Center(child: CircularLoading());
                  }

                  if (categoriesState is CrudLoadingState) {
                    return const Center(child: CircularLoading());
                  }

                  final posts = postsStore.posts[selectedPostType] ?? [];

                  return AppScrollbar(
                    controller: _scrollController,
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: AppTheme.dimensions.space.large.verticalSpacing,
                      ),
                      separatorBuilder: (context, index) {
                        final isLast = index == posts.length - 1;

                        return isLast
                            ? const SizedBox()
                            : SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing);
                      },
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        return PostCard(
                          post: post,
                          index: index + 1,
                          onPublish: () {
                            postsStore.createOrUpdatePost(post.copyWith(
                              isPublished: !post.isPublished,
                              body: post.body?.copyWith(
                                image: ImageModel(url: post.body?.image.url),
                              ),
                            ));
                          },
                          onEdit: () {
                            showCreateOrUpdatePostDialog(
                              context,
                              categories: categoriesStore.items,
                              onCreateOrUpdate: (post) => postsStore.createOrUpdatePost(post),
                              post: post,
                              postType: post.type,
                              isLoading: postsStore.state is CrudLoadingState,
                            );
                          },
                          onDelete: () => postsStore.deletePost(post),
                          canEdit: canEdit,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
