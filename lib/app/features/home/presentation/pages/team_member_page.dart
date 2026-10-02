import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_error_box.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_blocks.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/member_page_layout.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/member_page_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/member_portrait.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/sort_team.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_team_store.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/states/fetch_team_states.dart';
import 'package:observatorio_geo_hist/app/router/page_not_found.dart';
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

  @override
  void initState() {
    super.initState();
    // Busca só aqui: buscar no build ou numa reação repetia leituras na 404.
    if (_fetchTeamStore.needsFetch) _fetchTeamStore.fetchTeam();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final state = _fetchTeamStore.state;
        final member = _fetchTeamStore.getTeamMemberById(widget.memberId);

        final Widget body;
        switch (state) {
          case FetchTeamInitialState() || FetchTeamLoadingState():
            body = const MemberPageSkeleton();
          case FetchTeamErrorState():
            body = StateErrorBox(onRetry: _fetchTeamStore.fetchTeam);
          case FetchTeamSuccessState() when member == null || !memberHasPage(member):
            return const PageNotFound();
          case FetchTeamSuccessState():
            body = _MemberContent(member: member!);
        }

        return ReadingPageScaffold(body: _MemberFrame(child: body));
      },
    );
  }
}

class _MemberFrame extends StatelessWidget {
  const _MemberFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(
            top: components.pageHeadPaddingTop, bottom: components.memberPageBottomGap),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.memberPageMaxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _MemberContent extends StatelessWidget {
  const _MemberContent({required this.member});

  final TeamMemberModel member;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final lattesUrl = member.lattesUrl?.trim() ?? '';
    final paragraphs = [
      for (final line in member.description!.split('\n'))
        if (line.trim().isNotEmpty) line.trim(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Breadcrumbs(
            items: [
              const BreadcrumbItem('Início', route: AppRoutes.root),
              const BreadcrumbItem('Equipe', route: AppRoutes.root),
              BreadcrumbItem(member.name),
            ],
          ),
        ),
        SizedBox(height: components.memberPageTopGap),
        MemberPageLayout(
          portrait: MemberPortrait(name: member.name, imageUrl: member.image?.url),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member.role.toUpperCase(),
                  style: styles.label.copyWith(color: colors.accentStrong)),
              SizedBox(height: components.memberNameTopGap),
              Semantics(
                header: true,
                headingLevel: 1,
                child: Text(member.name, style: styles.memberPageName.copyWith(color: colors.ink)),
              ),
              SizedBox(height: components.memberNameBottomGap),
              for (final paragraph in paragraphs) ReadingParagraph(paragraph),
              if (lattesUrl.isNotEmpty) ...[
                SizedBox(height: components.memberLattesGap - components.readingParagraphGap),
                SecondaryButton.medium(
                  text: 'Currículo Lattes',
                  trailingIcon: Icons.open_in_new,
                  onPressed: () => openUrl(lattesUrl),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
