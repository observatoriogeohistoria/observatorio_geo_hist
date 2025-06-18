import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostsSectionList extends StatelessWidget {
  const PostsSectionList({
    required this.posts,
    required this.numberOfPostsTypes,
    required this.category,
    required this.hasMorePosts,
    required this.loadMorePosts,
    required this.loadMorePostsIsDisabled,
    super.key,
  });

  final Map<PostType, List<PostModel>> posts;
  final int numberOfPostsTypes;
  final CategoryModel category;

  final bool Function(PostType postType) hasMorePosts;
  final void Function(PostType postType) loadMorePosts;
  final bool loadMorePostsIsDisabled;

  @override
  Widget build(BuildContext context) {
    final isTablet = DeviceUtils.isTablet(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: posts.entries.length,
      itemBuilder: (context, index) {
        final entry = posts.entries.elementAt(index);
        final isEven = numberOfPostsTypes > 1 && index % 2 == 0;

        return Container(
          color: isEven ? AppTheme.colors.lighterGray : AppTheme.colors.white,
          padding: EdgeInsets.symmetric(
            vertical: AppTheme.dimensions.space.medium.verticalSpacing,
          ),
          child: Column(
            children: [
              if (numberOfPostsTypes > 1 && entry.value.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.dimensions.space.massive.horizontalSpacing,
                    vertical: AppTheme.dimensions.space.medium.verticalSpacing,
                  ),
                  width: double.infinity,
                  child: Center(
                    child: AppHeadline.big(
                      text: entry.key.portuguesePlural,
                      color: AppTheme.colors.orange,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: DeviceUtils.getPageHorizontalPadding(context),
                  vertical: AppTheme.dimensions.space.huge.verticalSpacing,
                ),
                child: StaggeredGrid.count(
                  crossAxisCount: isTablet ? 2 : 3,
                  mainAxisSpacing: AppTheme.dimensions.space.gigantic.verticalSpacing,
                  crossAxisSpacing: AppTheme.dimensions.space.massive.horizontalSpacing,
                  children: [
                    for (final post in entry.value)
                      PostCard(
                        category: category,
                        post: post,
                        index: entry.value.indexOf(post),
                        backgroundColor:
                            isEven ? AppTheme.colors.lighterGray : AppTheme.colors.white,
                        borderColor:
                            isEven ? AppTheme.colors.lightGray : AppTheme.colors.lighterGray,
                      ),
                  ],
                ),
              ),
              if (hasMorePosts(entry.key)) ...[
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                PrimaryButton.big(
                  text: 'Ver mais',
                  onPressed: () => loadMorePosts(entry.key),
                  isDisabled: loadMorePostsIsDisabled,
                ),
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
              ],
            ],
          ),
        );
      },
    );
  }
}
