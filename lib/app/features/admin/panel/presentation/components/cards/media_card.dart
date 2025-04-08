import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/view_image_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    required this.media,
    required this.index,
    required this.onDelete,
    required this.canEdit,
    super.key,
  });

  final MediaModel media;
  final int index;
  final void Function() onDelete;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
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
                    color: AppTheme.colors.gray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
                  AppTitle.big(
                    text: media.name,
                    color: AppTheme.colors.darkGray,
                  ),
                  AppBody.medium(
                    text: '.${media.extension}',
                    color: AppTheme.colors.darkGray,
                  ),
                  if (media.url?.isNotEmpty ?? false) ...[
                    SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                    AppLabel.big(
                      text: media.url!,
                      color: AppTheme.colors.gray,
                    ),
                  ]
                ],
              ),
            ),
            SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppIconButton(
                  icon: Icons.visibility,
                  color: AppTheme.colors.orange,
                  onPressed: () => showViewImageDialog(context, media),
                ),
                if (media.url?.isNotEmpty ?? false) ...[
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppIconButton(
                    icon: Icons.copy,
                    color: AppTheme.colors.gray,
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: media.url!));
                    },
                  ),
                ],
                if (canEdit) ...[
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppIconButton(
                    icon: Icons.delete,
                    color: AppTheme.colors.red,
                    onPressed: onDelete,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
