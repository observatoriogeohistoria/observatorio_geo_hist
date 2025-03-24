import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/general_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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

  bool get isMobile => DeviceUtils.isMobile(context);
  bool get isTablet => DeviceUtils.isTablet(context);
  bool get isDesktop => DeviceUtils.isDesktop(context);

  List<ReactionDisposer> reactions = [];
  ValueNotifier<TeamMemberModel?> teamMemberNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    setupReactions();
    updateData();
  }

  @override
  void didUpdateWidget(covariant TeamMemberPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateData();
  }

  @override
  void dispose() {
    for (final disposer in reactions) {
      disposer();
    }
    teamMemberNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Navbar()),
          ValueListenableBuilder<TeamMemberModel?>(
            valueListenable: teamMemberNotifier,
            builder: (context, member, child) {
              if (member == null) {
                fetchTeamStore.fetchTeam();
                return const LoadingContent(isSliver: true);
              }

              return SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (isDesktop
                            ? AppTheme.dimensions.space.gigantic
                            : (isTablet
                                ? AppTheme.dimensions.space.massive
                                : AppTheme.dimensions.space.large))
                        .horizontalSpacing,
                    vertical: AppTheme.dimensions.space.huge.verticalSpacing,
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
                      if (member.description?.isNotEmpty ?? false) ...[
                        SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                        AppBody.big(
                          text: member.description!,
                          textAlign: TextAlign.justify,
                          color: AppTheme.colors.darkGray,
                        ),
                      ],
                      if (member.lattesUrl?.isNotEmpty ?? false)
                        Container(
                          margin: EdgeInsets.only(
                            top: AppTheme.dimensions.space.massive.verticalSpacing,
                          ),
                          child: PrimaryButton.medium(
                            text: 'Currículo Lattes',
                            onPressed: () async {
                              final url = member.lattesUrl;
                              html.window.open(url!, 'new tab');
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }

  void setupReactions() {
    reactions = [
      reaction((_) => fetchTeamStore.team, (_) => updateData()),
    ];
  }

  void updateData() {
    teamMemberNotifier.value = fetchTeamStore.getTeamMemberById(widget.memberId);
    if (teamMemberNotifier.value == null) fetchTeamStore.fetchTeam();
  }
}
