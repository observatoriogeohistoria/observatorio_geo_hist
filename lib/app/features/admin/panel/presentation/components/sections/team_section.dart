import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/team_member_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_team_member_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/crud_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/team_store.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';

class TeamSection extends StatefulWidget {
  const TeamSection({super.key});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> {
  late final TeamStore teamStore = PanelSetup.getIt<TeamStore>();
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditTeamSection ?? false;

        return CrudSection<TeamMemberModel>(
          title: 'Equipe',
          canEdit: canEdit,
          store: teamStore,
          itemBuilder: (item, index) {
            return TeamMemberCard(
              member: item,
              index: index + 1,
              onDelete: () => teamStore.deleteItem(item),
              onEdit: () {
                showCreateOrUpdateTeamMemberDialog(
                  context,
                  onCreateOrUpdate: (item) => teamStore.createOrUpdateItem(item),
                  member: item,
                );
              },
              canEdit: canEdit,
            );
          },
          onCreatePressed: () {
            showCreateOrUpdateTeamMemberDialog(
              context,
              onCreateOrUpdate: (item) => teamStore.createOrUpdateItem(item),
            );
          },
        );
      },
    );
  }
}
