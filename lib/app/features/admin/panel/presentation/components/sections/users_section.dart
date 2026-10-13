import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/panel_action.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/user_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_user_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/crud_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/users_store.dart';

class UsersSection extends StatefulWidget {
  const UsersSection({super.key});

  @override
  State<UsersSection> createState() => _UsersSectionState();
}

class _UsersSectionState extends State<UsersSection> {
  late final UsersStore usersStore = PanelSetup.getIt<UsersStore>();
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();
  late final PanelCountsStore countsStore = PanelSetup.getIt<PanelCountsStore>();
  final _pending = PendingPanelAction();

  void _save(UserModel user, {dynamic extra}) {
    _pending.start(PanelAction.save);
    usersStore.createOrUpdateItem(user, extra: extra);
  }

  Future<void> _delete(UserModel user) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Excluir este usuário?',
      message: '“${user.name}” deixa de ter acesso ao painel. '
          'O que a pessoa publicou continua no site.',
    );
    if (!confirmed) return;
    _pending.start(PanelAction.delete);
    usersStore.deleteItem(user);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditTeamSection ?? false;

        return CrudSection<UserModel>(
          header: PanelSectionHeader(
            eyebrow: SidebarItem.users.eyebrow,
            title: SidebarItem.users.title,
            summary: countSummary(
              countsStore.counts.users,
              'usuário',
              'usuários',
              note: 'só a administração vê esta seção',
            ),
            actionLabel: canEdit ? 'Novo usuário' : null,
            onAction: () => showCreateOrUpdateUserDialog(
              context,
              onCreate: (item, extra) => _save(item, extra: extra),
              onUpdate: _save,
            ),
          ),
          store: usersStore,
          pending: _pending,
          messages: const {
            PanelAction.save: 'Usuário salvo.',
            PanelAction.delete: 'Usuário excluído.',
          },
          itemBuilder: (item, index) {
            return UserCard(
              user: item,
              index: index + 1,
              onDelete: () => _delete(item),
              onEdit: () {
                showCreateOrUpdateUserDialog(
                  context,
                  onCreate: (item, extra) => _save(item, extra: extra),
                  onUpdate: _save,
                  user: item,
                );
              },
            );
          },
        );
      },
    );
  }
}
