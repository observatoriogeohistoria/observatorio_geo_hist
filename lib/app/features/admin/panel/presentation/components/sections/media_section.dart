import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/panel_action.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/media_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_media_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/crud_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/media_store.dart';

class MediaSection extends StatefulWidget {
  const MediaSection({super.key});

  @override
  State<MediaSection> createState() => _MediaSectionState();
}

class _MediaSectionState extends State<MediaSection> {
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();
  late final MediaStore mediaStore = PanelSetup.getIt<MediaStore>();
  final _pending = PendingPanelAction();

  Future<void> _delete(MediaModel media) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Excluir esta imagem?',
      message: 'Publicações que usam “${media.name}.${media.extension}” ficam sem imagem. '
          'Não dá para desfazer.',
    );
    if (!confirmed) return;
    _pending.start(PanelAction.delete);
    mediaStore.deleteItem(media);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditMediaSection ?? false;

        return CrudSection<MediaModel>(
          header: PanelSectionHeader(
            eyebrow: SidebarItem.media.eyebrow,
            title: SidebarItem.media.title,
            summary: 'Imagens usadas nas publicações. Copie o link para usar no editor.',
            actionLabel: canEdit ? 'Enviar imagens' : null,
            actionIcon: Icons.file_upload_outlined,
            onAction: () => showCreateMediaDialog(
              context,
              onCreate: (item) {
                _pending.start(PanelAction.save);
                mediaStore.createOrUpdateItem(item);
              },
            ),
          ),
          store: mediaStore,
          pending: _pending,
          messages: const {
            PanelAction.save: 'Imagem enviada.',
            PanelAction.delete: 'Imagem excluída.',
          },
          paginated: true,
          itemBuilder: (item, index) {
            return MediaCard(
              media: item,
              index: index + 1,
              onDelete: () => _delete(item),
              canEdit: canEdit,
            );
          },
        );
      },
    );
  }
}
