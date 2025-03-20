import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/loading.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/team_member_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_team_member_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/team_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/users_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/team_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class TeamSection extends StatefulWidget {
  const TeamSection({super.key});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> {
  late final TeamStore teamStore = PanelSetup.getIt<TeamStore>();
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    teamStore.getTeamMembers();

    _reactions = [
      reaction((_) => teamStore.state, (state) {
        if (state is ManageTeamErrorState) {
          final error = state.failure;
          Messenger.showError(context, error.message);

          if (error is Forbidden) authStore.logout();
        }

        if (state is ManageTeamSuccessState) {
          if (state.message.isNotEmpty) {
            Messenger.showSuccess(context, state.message);
          }
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeadline.big(
          text: 'Equipe',
          color: AppTheme.colors.orange,
        ),
        SizedBox(height: AppTheme.dimensions.space.xlarge),
        Align(
          alignment: Alignment.centerRight,
          child: SecondaryButton.medium(
            text: 'Criar membro',
            onPressed: () {
              showCreateOrUpdateTeamMemberDialog(
                context,
                onCreateOrUpdate: (member) => teamStore.createOrUpdateTeamMember(member),
              );
            },
          ),
        ),
        Expanded(
          child: Observer(
            builder: (context) {
              if (teamStore.state is ManageUsersLoadingState) {
                return const Center(child: Loading());
              }

              final members = teamStore.teamMembers;

              return ListView.separated(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  vertical: AppTheme.dimensions.space.large,
                ),
                separatorBuilder: (context, index) {
                  final isLast = index == members.length - 1;

                  return isLast
                      ? const SizedBox()
                      : SizedBox(height: AppTheme.dimensions.space.medium);
                },
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];

                  return TeamMemberCard(
                    member: member,
                    index: index + 1,
                    onDelete: () => teamStore.deleteTeamMember(member),
                    onEdit: () {
                      showCreateOrUpdateTeamMemberDialog(
                        context,
                        onCreateOrUpdate: (member) => teamStore.createOrUpdateTeamMember(member),
                        member: member,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
