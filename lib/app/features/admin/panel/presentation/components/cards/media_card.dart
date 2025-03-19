import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/view_image_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    required this.media,
    required this.index,
    required this.onDelete,
    super.key,
  });

  final MediaModel media;
  final int index;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme(context).dimensions.space.medium,
        vertical: AppTheme(context).dimensions.space.small,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLabel.small(
                    text: '$index',
                    color: AppTheme(context).colors.gray,
                  ),
                  SizedBox(height: AppTheme(context).dimensions.space.xsmall),
                  AppTitle.medium(
                    text: media.name,
                    color: AppTheme(context).colors.darkGray,
                  ),
                  AppBody.small(
                    text: '.${media.extension}',
                    color: AppTheme(context).colors.darkGray,
                  ),
                  if (media.url?.isNotEmpty ?? false) ...[
                    SizedBox(height: AppTheme(context).dimensions.space.medium),
                    AppLabel.big(
                      text: media.url!,
                      color: AppTheme(context).colors.gray,
                    ),
                  ]
                ],
              ),
            ),
            SizedBox(width: AppTheme(context).dimensions.space.medium),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility, color: AppTheme(context).colors.orange),
                  onPressed: () => showViewImageDialog(context, media),
                ),
                if (media.url?.isNotEmpty ?? false)
                  IconButton(
                    icon: Icon(Icons.copy, color: AppTheme(context).colors.gray),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: media.url!));
                    },
                  ),
                IconButton(
                  icon: Icon(Icons.delete, color: AppTheme(context).colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
