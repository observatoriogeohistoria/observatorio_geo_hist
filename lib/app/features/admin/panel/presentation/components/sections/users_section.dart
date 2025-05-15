import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditTeamSection ?? false;

        return CrudSection<UserModel>(
          title: 'Usuários',
          canEdit: canEdit,
          store: usersStore,
          itemBuilder: (item, index) {
            return UserCard(
              user: item,
              index: index + 1,
              onDelete: () => usersStore.deleteItem(item),
              onEdit: () {
                showCreateOrUpdateUserDialog(
                  context,
                  onCreate: (item, extra) => usersStore.createOrUpdateItem(item, extra: extra),
                  onUpdate: (item) => usersStore.createOrUpdateItem(item),
                  user: item,
                );
              },
            );
          },
          onCreatePressed: () {
            showCreateOrUpdateUserDialog(
              context,
              onCreate: (item, extra) => usersStore.createOrUpdateItem(item, extra: extra),
              onUpdate: (item) => usersStore.createOrUpdateItem(item),
            );
          },
        );
      },
    );
  }
}
