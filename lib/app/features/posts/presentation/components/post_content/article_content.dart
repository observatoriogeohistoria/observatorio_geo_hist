import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/view_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/social_icons.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ArticleContent extends StatelessWidget {
  const ArticleContent({
    required this.post,
    required this.article,
    super.key,
  });

  final PostModel post;
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.massive.verticalSpacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeadline.big(
            text: article.title.toUpperCase(),
            textAlign: TextAlign.start,
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
          AppTitle.big(
            text: article.subtitle,
            color: AppTheme.colors.gray,
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          for (var author in article.authors)
            AppTitle.small(
              text: author,
              color: AppTheme.colors.orange,
            ),
          SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
          AppTitle.medium(
            text: article.date,
            color: AppTheme.colors.darkGray,
          ),
          SizedBox(height: AppTheme.dimensions.space.massive.verticalSpacing),
          SocialIcons(post: post),
          SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
          const AppDivider(),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          if (article.image.url?.isNotEmpty ?? false)
            AppNetworkImage(
              imageUrl: article.image.url!,
              height: null,
            ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                AppTitle.small(
                  text: article.imageCaption,
                  textAlign: TextAlign.start,
                  color: AppTheme.colors.gray,
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          ViewQuill(initialContent: article.content),
          if (!ViewQuill.isQuillContentEmpty(article.observation))
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
                  child: ViewQuill(initialContent: article.observation),
                ),
              ],
            ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
        ],
      ),
    );
  }
}
