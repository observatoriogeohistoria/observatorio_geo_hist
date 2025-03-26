import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SocialIcons extends StatefulWidget {
  const SocialIcons({
    required this.post,
    super.key,
  });

  final PostModel post;

  @override
  State<SocialIcons> createState() => _SocialIconsState();
}

class _SocialIconsState extends State<SocialIcons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildIcon('facebook', AppStrings.shareOnFacebook),
        SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
        _buildIcon('twitter', AppStrings.shareOnTwitter),
        SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
        _buildIcon('whatsapp', AppStrings.shareOnWhatsapp),
        SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
        _buildIcon('email', AppStrings.shareOnEmail),
      ],
    );
  }

  Widget _buildIcon(
    String name,
    String link,
  ) {
    return InkWell(
      onTap: () {
        String currentUrl = getEncodedCurrentUrl();

        String linkTo =
            link.replaceAll('[TEXT]', widget.post.title).replaceAll('[URL]', currentUrl);

        js.context.callMethod('open', [linkTo]);
      },
      mouseCursor: SystemMouseCursors.click,
      child: Image.asset(
        'assets/icons/$name.png',
        width: 40.scale,
        height: 40.scale,
      ),
    );
  }
}
