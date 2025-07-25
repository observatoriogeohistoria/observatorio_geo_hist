import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/loading_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
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
  late final _fetchTeamStore = HomeSetup.getIt<FetchTeamStore>();

  List<ReactionDisposer> _reactions = [];
  final ValueNotifier<TeamMemberModel?> _teamMemberNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    _setupReactions();
    _updateData();
  }

  @override
  void didUpdateWidget(covariant TeamMemberPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateData();
  }

  @override
  void dispose() {
    for (final disposer in _reactions) {
      disposer();
    }
    _teamMemberNotifier.dispose();
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
            valueListenable: _teamMemberNotifier,
            builder: (context, member, child) {
              if (member == null) {
                _fetchTeamStore.fetchTeam();
                return const LoadingContent(isSliver: true);
              }

              return SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.getPageHorizontalPadding(context),
                    vertical: AppTheme.dimensions.space.massive.verticalSpacing,
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
                            onPressed: () {
                              if (member.lattesUrl == null) return;
                              openUrl(member.lattesUrl!);
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

  void _setupReactions() {
    _reactions = [
      reaction((_) => _fetchTeamStore.team, (_) => _updateData()),
    ];
  }

  void _updateData() {
    _teamMemberNotifier.value = _fetchTeamStore.getTeamMemberById(widget.memberId);
    if (_teamMemberNotifier.value == null) _fetchTeamStore.fetchTeam();
  }
}
