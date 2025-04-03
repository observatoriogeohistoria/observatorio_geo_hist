import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
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
        _buildIcon('facebook', AppStrings.shareOnFacebook, Colors.blue),
        _buildIcon('twitter', AppStrings.shareOnTwitter, Colors.blueGrey),
        _buildIcon('whatsapp', AppStrings.shareOnWhatsapp, Colors.green),
        _buildIcon('email', AppStrings.shareOnEmail, Colors.orange),
      ],
    );
  }

  Widget _buildIcon(
    String name,
    String link,
    Color color,
  ) {
    return InkWell(
      customBorder: const CircleBorder(),
      hoverColor: color,
      onTap: () {
        String currentUrl = getEncodedCurrentUrl();
        String linkTo = link
            .replaceAll('[TEXT]', widget.post.body?.title ?? '')
            .replaceAll('[URL]', currentUrl);

        openUrl(linkTo);
      },
      mouseCursor: SystemMouseCursors.click,
      child: Padding(
        padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
        child: Image.asset(
          '${AppAssets.icons}/$name.png',
          width: 40.scale,
          height: 40.scale,
        ),
      ),
    );
  }
}
