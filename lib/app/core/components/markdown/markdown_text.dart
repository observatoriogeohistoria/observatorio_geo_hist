import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:observatorio_geo_hist/app/core/utils/file/file.dart';
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
        code: AppTheme(context).typography.body.medium.copyWith(
              color: AppTheme(context).colors.orange,
            ),
        strong: AppTheme(context).typography.body.medium.copyWith(
              color: AppTheme(context).colors.orange,
            ),
        p: AppTheme(context).typography.body.medium.copyWith(
              color: AppTheme(context).colors.darkGray,
            ),
        h1: AppTheme(context).typography.title.big.copyWith(
              color: AppTheme(context).colors.orange,
            ),
        h2: AppTheme(context).typography.title.medium.copyWith(
              color: AppTheme(context).colors.gray,
            ),
        h3: AppTheme(context).typography.title.small.copyWith(
              color: AppTheme(context).colors.gray,
            ),
        h6: AppTheme(context).typography.body.medium.copyWith(
              color: Colors.transparent,
              height: 0.5,
              fontSize: 0.5,
            ),
      ),
      onTapLink: (text, url, title) {
        if (url == null) return;
        html.window.open(url, 'new tab');
      },
      imageBuilder: (uri, title, alt) {
        final str = uri.toString();
        final isSvgImage = isSvg(str);

        if (str.startsWith("data:image")) {
          try {
            Uint8List bytes = decodeBase64Image(str);
            return isSvgImage ? SvgPicture.memory(bytes) : Image.memory(bytes);
          } catch (e) {
            return const SizedBox();
          }
        } else {
          return isSvgImage ? SvgPicture.network(uri.toString()) : Image.network(uri.toString());
        }
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
