import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/field/search_field.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_media_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_filter_bar.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_grid.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/crud_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/media_tile.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/panel_action.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/media_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class MediaSection extends StatefulWidget {
  const MediaSection({super.key});

  @override
  State<MediaSection> createState() => _MediaSectionState();
}

class _MediaSectionState extends State<MediaSection> {
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();
  late final MediaStore mediaStore = PanelSetup.getIt<MediaStore>();
  final _pending = PendingPanelAction();
  final _searchController = TextEditingController();

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _upload() {
    showCreateMediaDialog(
      context,
      onCreate: (item) {
        _pending.start(PanelAction.save);
        mediaStore.createOrUpdateItem(item);
      },
    );
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() => _query = '');
  }

  bool _matches(MediaModel media) =>
      foldForSearch('${media.name}.${media.extension}').contains(_query);

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return Observer(
      builder: (context) {
        final canEdit = authStore.user?.permissions.canEditMediaSection ?? false;

        return CrudSection<MediaModel>(
          header: PanelSectionHeader(
            eyebrow: SidebarItem.media.eyebrow,
            title: SidebarItem.media.title,
            summary: 'Imagens usadas nas publicações. Copie o link para usar no editor.',
            actionLabel: canEdit ? 'Enviar imagens' : null,
            actionIcon: Icons.file_upload_outlined,
            onAction: _upload,
          ),
          filterBar: PanelFilterBar(
            search: SearchField(
              controller: _searchController,
              hint: 'Buscar pelo nome do arquivo',
              semanticLabel: 'Buscar pelo nome do arquivo',
              height: components.panelControlHeight,
              keepClearSpace: false,
              onSearch: (text) => setState(() => _query = foldForSearch(text)),
            ),
          ),
          store: mediaStore,
          pending: _pending,
          messages: const {
            PanelAction.save: 'Imagem enviada.',
            PanelAction.delete: 'Imagem excluída.',
          },
          paginated: true,
          isGrid: true,
          empty: PanelEmptyInfo(
            icon: Icons.image_outlined,
            title: 'Nenhuma imagem ainda',
            message: 'Envie as imagens que vão ilustrar as publicações.',
            actionLabel: canEdit ? 'Enviar imagens' : null,
            actionIcon: Icons.file_upload_outlined,
            onAction: _upload,
          ),
          filter: _query.isEmpty ? null : _matches,
          onClearFilters: _clearFilters,
          bodyBuilder: (items, footer) => SliverMainAxisGroup(
            slivers: [
              PanelGrid(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final media = items[index];
                  return MediaTile(
                    key: ValueKey(media.id),
                    media: media,
                    canEdit: canEdit,
                    onDelete: () => _delete(media),
                  );
                },
              ),
              if (footer != null) SliverToBoxAdapter(child: footer),
              if (mediaStore.hasMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: components.panelMoreNoteTop),
                    child: Text(
                      '${mediaStore.items.length} imagens carregadas · '
                      'as próximas carregam ao rolar',
                      textAlign: TextAlign.center,
                      style: AppTheme.typography.of(context).panelListFoot.copyWith(
                            color: AppTheme.colors.inkSecondary,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
