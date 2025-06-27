import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MagazineContent extends StatelessWidget {
  const MagazineContent({
    required this.post,
    required this.magazine,
    super.key,
  });

  final PostModel post;
  final MagazineModel magazine;

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
                if (magazine.image.url?.isNotEmpty ?? false)
                  AppNetworkImage(
                    imageUrl: magazine.image.url!,
                  ),
                SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                SizedBox(
                  width: double.maxFinite,
                  child: SecondaryButton.medium(
                    text: "Acesse",
                    onPressed: () => openUrl(magazine.link),
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
                  text: magazine.title.toUpperCase(),
                  textAlign: TextAlign.start,
                  color: AppTheme.colors.orange,
                ),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                const AppDivider(),
                AppTitle.big(
                  text: magazine.category.portuguese,
                  color: AppTheme.colors.gray,
                ),
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                if (magazine.teaser?.isNotEmpty ?? false) ...[
                  _buildInfo('Chamada', magazine.teaser!),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                ],
                _buildInfo('Descrição', magazine.description),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(
    String title,
    String text,
  ) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: AppTheme.typography.title.medium.copyWith(color: AppTheme.colors.orange),
        children: [
          TextSpan(
            text: text,
            style: AppTheme.typography.body.big.copyWith(color: AppTheme.colors.darkGray),
          ),
        ],
      ),
    );
  }
}
