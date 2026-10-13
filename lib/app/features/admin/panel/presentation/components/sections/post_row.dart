import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_row.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_row_leading.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/post_row_meta.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostRow extends StatelessWidget {
  const PostRow({
    required this.post,
    required this.canEdit,
    required this.onPublish,
    required this.onHighlight,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final PostModel post;
  final bool canEdit;
  final VoidCallback onPublish;
  final VoidCallback onHighlight;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final iconSize = AppTheme.dimensions.components.panelActionIcon;
    final published = post.isPublished;
    final highlighted = post.isHighlighted;

    return PanelListRow(
      leading: PanelThumbnail(url: post.body?.image.url),
      title: postRowTitle(post),
      meta: postRowMeta(post),
      badges: [
        published
            ? const StatusBadge('Publicado', tone: StatusTone.success)
            : const StatusBadge('Não publicado', tone: StatusTone.neutral),
        if (highlighted) const StatusBadge('Destaque', tone: StatusTone.accent, icon: Icons.star),
      ],
      actions: [
        if (canEdit) ...[
          AppIconButton(
            label: published ? 'Despublicar' : 'Publicar',
            tooltip: published
                ? 'Despublicar: sai do site e continua salva no painel'
                : 'Publicar: passa a aparecer no site',
            icon: published ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: colors.inkSecondary,
            size: iconSize,
            onPressed: onPublish,
          ),
          AppIconButton(
            label: 'Destacar na Home',
            tooltip: highlighted
                ? 'Tirar dos destaques: deixa de aparecer no topo da Home'
                : 'Destacar: entra nos destaques da Home',
            icon: highlighted ? Icons.star : Icons.star_border,
            color: highlighted ? colors.accent : colors.inkSecondary,
            size: iconSize,
            isToggled: highlighted,
            onPressed: onHighlight,
          ),
          AppIconButton(
            label: 'Editar',
            tooltip: 'Editar: abre a publicação no editor',
            icon: Icons.edit_outlined,
            color: colors.inkSecondary,
            size: iconSize,
            onPressed: onEdit,
          ),
          AppIconButton(
            label: 'Excluir',
            tooltip: 'Excluir: pede confirmação antes de apagar',
            icon: Icons.delete_outline,
            color: colors.error,
            size: iconSize,
            onPressed: onDelete,
          ),
        ],
      ],
    );
  }
}
