import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_team_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class TeamMemberPage extends StatefulWidget {
  const TeamMemberPage({
    required this.memberId,
    super.key,
  });

  final String memberId;

  @override
  State<TeamMemberPage> createState() => _TeamMemberPageState();
}

class _TeamMemberPageState extends State<TeamMemberPage> {
  late final FetchTeamStore fetchTeamStore = HomeSetup.getIt<FetchTeamStore>();

  List<ReactionDisposer> reactions = [];
  ValueNotifier<TeamMemberModel?> teamMemberNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    teamMemberNotifier = ValueNotifier(fetchTeamStore.getTeamMemberById(widget.memberId));
    setupReactions();
  }

  @override
  void didUpdateWidget(covariant TeamMemberPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    teamMemberNotifier = ValueNotifier(fetchTeamStore.getTeamMemberById(widget.memberId));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TeamMemberModel?>(
      valueListenable: teamMemberNotifier,
      builder: (context, member, child) {
        if (member == null) fetchTeamStore.fetchTeam();

        return Scaffold(
          backgroundColor: AppTheme.colors.white,
          body: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: Navbar()),
              SliverFillRemaining(
                hasScrollBody: false,
                child: member == null
                    ? CircularProgressIndicator(
                        color: AppTheme.colors.orange,
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.2,
                          vertical: 2 * AppTheme.dimensions.space.large,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: AppHeadline.small(
                                text: member.name.toUpperCase(),
                                color: AppTheme.colors.orange,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: AppHeadline.medium(
                                text: member.role.toUpperCase(),
                                color: AppTheme.colors.gray,
                              ),
                            ),
                            SizedBox(height: AppTheme.dimensions.space.large),
                            AppBody.big(
                              text: member.description,
                              textAlign: TextAlign.justify,
                              color: AppTheme.colors.darkGray,
                            ),
                            if (member.lattesUrl.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(top: AppTheme.dimensions.space.large),
                                child: PrimaryButton.medium(
                                  text: 'Currículo Lattes',
                                  onPressed: () async {
                                    final url = member.lattesUrl;
                                    html.window.open(url, 'new tab');
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
              const SliverToBoxAdapter(child: Footer()),
            ],
          ),
        );
      },
    );
  }

  void setupReactions() {
    reactions = [
      reaction((_) => fetchTeamStore.team, (_) {
        teamMemberNotifier = ValueNotifier(fetchTeamStore.getTeamMemberById(widget.memberId));
      }),
    ];
  }
}
