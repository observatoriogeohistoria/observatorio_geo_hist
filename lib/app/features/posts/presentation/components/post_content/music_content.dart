import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/view_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MusicContent extends StatelessWidget {
  const MusicContent({
    required this.post,
    required this.music,
    super.key,
  });

  final PostModel post;
  final MusicModel music;

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
                if (music.image.url?.isNotEmpty ?? false)
                  AppNetworkImage(
                    imageUrl: music.image.url!,
                  ),
                SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                SizedBox(
                  width: double.maxFinite,
                  child: SecondaryButton.medium(
                    text: "Acesse",
                    onPressed: () => openUrl(music.link),
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
                  text: music.title.toUpperCase(),
                  textAlign: TextAlign.start,
                  color: AppTheme.colors.orange,
                ),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                const AppDivider(),
                AppTitle.big(
                  text: 'Música',
                  color: AppTheme.colors.gray,
                ),
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                _buildInfo('Artista', music.artistName),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                _buildInfo('Descrição', music.description),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                if (ViewQuill.isQuillContentEmpty(music.lyrics) == false) ...[
                  AppTitle.medium(
                    text: 'Letra:',
                    color: AppTheme.colors.orange,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
                  ViewQuill(initialContent: music.lyrics),
                ]
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
