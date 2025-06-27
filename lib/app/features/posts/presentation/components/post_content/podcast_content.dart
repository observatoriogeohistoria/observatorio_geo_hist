import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PodcastContent extends StatelessWidget {
  const PodcastContent({
    required this.post,
    required this.podcast,
    super.key,
  });

  final PostModel post;
  final PodcastModel podcast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.massive.verticalSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                if (podcast.image.url?.isNotEmpty ?? false)
                  AppNetworkImage(
                    imageUrl: podcast.image.url!,
                  ),
                SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                SizedBox(
                  width: double.maxFinite,
                  child: SecondaryButton.medium(
                    text: "Acesse",
                    onPressed: () => openUrl(podcast.link),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppTheme.dimensions.space.massive.horizontalSpacing),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeadline.big(
                  text: podcast.title.toUpperCase(),
                  textAlign: TextAlign.start,
                  color: AppTheme.colors.orange,
                ),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                const AppDivider(),
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                AppBody.big(
                  text: podcast.description,
                  textAlign: TextAlign.start,
                  color: AppTheme.colors.darkGray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
