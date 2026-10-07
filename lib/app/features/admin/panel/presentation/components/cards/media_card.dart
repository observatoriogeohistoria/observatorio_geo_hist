import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
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
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final typography = AppTheme.typography.of(context);
    final hasUrl = media.url?.isNotEmpty ?? false;

    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: components.panelCardPaddingH,
        vertical: components.panelCardPaddingV,
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
                  Text('$index', style: typography.label.copyWith(color: colors.inkSecondary)),
                  SizedBox(height: components.panelCardTextGap),
                  Text(media.name, style: typography.h3.copyWith(color: colors.ink)),
                  Text(
                    '.${media.extension}',
                    style: typography.regular.copyWith(color: colors.inkSecondary),
                  ),
                  if (hasUrl) ...[
                    SizedBox(height: dimensions.spacing.s12),
                    Text(
                      media.url!,
                      style: typography.small.copyWith(color: colors.inkSecondary),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: dimensions.spacing.s16),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppIconButton(
                  tooltip: 'Ver imagem',
                  icon: Icons.visibility,
                  color: colors.accent,
                  onPressed: () => showViewImageDialog(context, media),
                ),
                if (hasUrl) ...[
                  SizedBox(height: components.panelCardActionsGap),
                  AppIconButton(
                    tooltip: 'Copiar link',
                    icon: Icons.copy,
                    color: colors.inkSecondary,
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: media.url!));
                    },
                  ),
                ],
                if (canEdit) ...[
                  SizedBox(height: components.panelCardActionsGap),
                  AppIconButton(
                    tooltip: 'Excluir imagem',
                    icon: Icons.delete,
                    color: colors.error,
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
