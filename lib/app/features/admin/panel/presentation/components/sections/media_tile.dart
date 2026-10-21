import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/image/fitted_network_image.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/view_image_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_row_leading.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MediaTile extends StatelessWidget {
  const MediaTile({
    required this.media,
    required this.canEdit,
    required this.onDelete,
    super.key,
  });

  final MediaModel media;
  final bool canEdit;
  final VoidCallback onDelete;

  String get fileName => '${media.name}.${media.extension}';

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final iconSize = components.panelActionIcon;
    final url = media.url;
    final hasUrl = url != null && url.isNotEmpty;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: fileName,
      child: Container(
        decoration: BoxDecoration(
          color: colors.page,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
          border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: components.panelTileAspect,
              child: hasUrl
                  ? ColoredBox(
                      color: colors.surface,
                      child: FittedNetworkImage(
                        url,
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                        errorBuilder: (_, __, ___) => const PanelImagePlaceholder(),
                      ),
                    )
                  : const PanelImagePlaceholder(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                components.panelTilePaddingH,
                components.panelTilePaddingTop,
                components.panelTilePaddingH,
                0,
              ),
              child: ExcludeSemantics(
                child: Tooltip(
                  message: fileName,
                  child: Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.typography.of(context).panelTileName.copyWith(
                          color: colors.ink,
                        ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(components.panelTileActionsPadding),
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: components.panelRowActionsGap,
                children: [
                  AppIconButton(
                    label: 'Ver imagem',
                    tooltip: 'Ver: abre a imagem em tamanho maior',
                    icon: Icons.visibility_outlined,
                    color: colors.inkSecondary,
                    size: iconSize,
                    onPressed: () => showViewImageDialog(context, media),
                  ),
                  if (hasUrl)
                    AppIconButton(
                      label: 'Copiar link',
                      tooltip: 'Copiar link: para colar no editor',
                      icon: Icons.link,
                      color: colors.inkSecondary,
                      size: iconSize,
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: url));
                        if (context.mounted) Messenger.showSuccess(context, 'Link copiado.');
                      },
                    ),
                  if (canEdit)
                    AppIconButton(
                      label: 'Excluir',
                      tooltip: 'Excluir: pede confirmação antes de apagar',
                      icon: Icons.delete_outline,
                      color: colors.error,
                      size: iconSize,
                      onPressed: onDelete,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
