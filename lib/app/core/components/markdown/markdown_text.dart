import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/image_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/network_image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/utils/image/image.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MarkdownText extends StatelessWidget {
  final String text;

  const MarkdownText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    String formatText(String text) {
      RegExp regExp = RegExp(r'\[(\d+)\]');

      return text.replaceAllMapped(regExp, (match) {
        int count = int.parse(match.group(1)!);
        return ' \n' * count;
      });
    }

    String formattedText = formatText(text);

    return Markdown(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      data: formattedText,
      paddingBuilders: <String, MarkdownPaddingBuilder>{
        'p': PPaddingBuilder(),
        'h1': HPaddingBuilder(),
        'h2': HPaddingBuilder(),
        'h3': HPaddingBuilder(),
        'h6': HPaddingBuilder(),
      },
      styleSheet: MarkdownStyleSheet(
        code: AppTheme.typography.body.medium.copyWith(
          color: AppTheme.colors.orange,
        ),
        strong: AppTheme.typography.body.medium.copyWith(
          color: AppTheme.colors.orange,
        ),
        p: AppTheme.typography.body.medium.copyWith(
          color: AppTheme.colors.darkGray,
        ),
        h1: AppTheme.typography.title.big.copyWith(
          color: AppTheme.colors.orange,
        ),
        h2: AppTheme.typography.title.medium.copyWith(
          color: AppTheme.colors.gray,
        ),
        h3: AppTheme.typography.title.small.copyWith(
          color: AppTheme.colors.gray,
        ),
        h6: AppTheme.typography.body.medium.copyWith(
          color: Colors.transparent,
          height: 0.5,
          fontSize: 0.5,
        ),
      ),
      onTapLink: (text, url, title) {
        if (url == null) return;
        openUrl(url);
      },
      imageBuilder: (uri, title, alt) {
        final uriString = uri.toString();

        if (ImageUtils.isBase64(uriString)) {
          try {
            Uint8List bytes = ImageUtils.decodeBase64(uriString);

            return ImageUtils.isSvg(uriString) ? SvgPicture.memory(bytes) : Image.memory(bytes);
          } catch (e) {
            return const ImageErrorContent();
          }
        }

        if (ImageUtils.isHttp(uriString)) {
          if (ImageUtils.isAsset(uriString) || ImageUtils.isSvg(uriString)) {
            return AppNetworkImage(imageUrl: uriString);
          }

          return const ImageErrorContent();
        }

        return const ImageErrorContent();
      },
    );
  }
}

class PPaddingBuilder extends MarkdownPaddingBuilder {
  @override
  EdgeInsets getPadding() => const EdgeInsets.only(top: 16);
}

class HPaddingBuilder extends MarkdownPaddingBuilder {
  @override
  EdgeInsets getPadding() => const EdgeInsets.only(top: 16);
}
