import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditMediaSection ?? false;

        return CrudSection<MediaModel>(
          title: 'Mídias',
          canEdit: canEdit,
          store: mediaStore,
          itemBuilder: (item, index) {
            return MediaCard(
              media: item,
              index: index + 1,
              onDelete: () => mediaStore.deleteItem(item),
              canEdit: canEdit,
            );
          },
          onCreatePressed: () {
            showCreateMediaDialog(
              context,
              onCreate: (item) => mediaStore.createOrUpdateItem(item),
            );
          },
        );
      },
    );
  }
}
