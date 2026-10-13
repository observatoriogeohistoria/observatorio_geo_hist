import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/panel_action.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_team_member_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/crud_section.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/team_member_row.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_states.dart';
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
  late final PanelCountsStore countsStore = PanelSetup.getIt<PanelCountsStore>();
  final _pending = PendingPanelAction();

  void _save(TeamMemberModel member) {
    _pending.start(PanelAction.save);
    teamStore.createOrUpdateItem(member);
  }

  Future<void> _delete(TeamMemberModel member) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Remover este membro?',
      message: '“${member.name}” sai da equipe no site e do painel. Não dá para desfazer.',
      confirmText: 'Remover',
    );
    if (!confirmed) return;
    _pending.start(PanelAction.delete);
    teamStore.deleteItem(member);
  }

  void _openForm([TeamMemberModel? member]) {
    showCreateOrUpdateTeamMemberDialog(context, onCreateOrUpdate: _save, member: member);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool canEdit = authStore.user?.permissions.canEditTeamSection ?? false;

        return CrudSection<TeamMemberModel>(
          header: PanelSectionHeader(
            eyebrow: SidebarItem.team.eyebrow,
            title: SidebarItem.team.title,
            summary: countSummary(
              countsStore.counts.team,
              'pessoa',
              'pessoas',
              note: 'quem tem descrição ganha página no site',
            ),
            actionLabel: canEdit ? 'Novo membro' : null,
            onAction: _openForm,
          ),
          store: teamStore,
          pending: _pending,
          messages: const {
            PanelAction.save: 'Membro salvo.',
            PanelAction.delete: 'Membro removido da equipe.',
          },
          empty: PanelEmptyInfo(
            icon: Icons.groups_outlined,
            title: 'Ninguém na equipe ainda',
            message: 'Cadastre as pessoas do Observatório para que apareçam no site.',
            actionLabel: canEdit ? 'Novo membro' : null,
            onAction: _openForm,
          ),
          bodyBuilder: (items, footer) => PanelList(
            itemCount: items.length,
            footer: footer,
            itemBuilder: (context, index) {
              final member = items[index];
              return TeamMemberRow(
                key: ValueKey(member.id),
                member: member,
                canEdit: canEdit,
                onEdit: () => _openForm(member),
                onDelete: () => _delete(member),
              );
            },
          ),
        );
      },
    );
  }
}
