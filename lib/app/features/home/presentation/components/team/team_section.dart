import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/skeleton/skeleton.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/team_grid.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/team_member_tile.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_team_store.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/states/fetch_team_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Seção "Equipe" da Home (spec 008): todos os membros de uma vez, em grade.
///
/// Carregando: título e esqueleto de uma linha. Erro: título, mensagem e
/// "Tentar de novo". Sem membros: a seção inteira some.
class TeamSection extends StatelessWidget {
  const TeamSection({super.key, required this.store, required this.onRetry});

  final FetchTeamStore store;

  /// Refaz a busca da equipe.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final team = store.team;

        final Widget content;
        switch (store.state) {
          case FetchTeamInitialState() || FetchTeamLoadingState():
            content = const _Loading();
          case FetchTeamErrorState():
            content = _Error(onRetry: onRetry);
          case FetchTeamSuccessState() when team.isEmpty:
            return const SizedBox.shrink();
          case FetchTeamSuccessState():
            content = TeamGrid(
              itemCount: team.length,
              itemBuilder: (context, index) => TeamMemberTile(member: team[index]),
            );
        }

        return _Section(child: content);
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);

    return ColoredBox(
      color: AppTheme.colors.page,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: components.sectionPaddingVertical(breakpoint)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Equipe',
                  style: AppTheme.typography.of(context).h2.copyWith(color: AppTheme.colors.ink),
                ),
              ),
              SizedBox(height: components.sectionHeadGap),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// Esqueleto de uma linha da grade: círculo e duas barras por coluna. Parado.
class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final barRadius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    Widget bar(double widthFactor) => Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: ClipRRect(
              borderRadius: barRadius,
              child: Skeleton(width: null, height: components.memberSkeletonBarHeight),
            ),
          ),
        );

    return Semantics(
      label: 'Carregando equipe',
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, constraints) => TeamGrid(
          itemCount: TeamGrid.columnsFor(context, constraints.maxWidth),
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(child: Skeleton(width: components.memberAvatar, height: components.memberAvatar)),
              SizedBox(height: components.memberAvatarGap),
              bar(components.memberSkeletonNameWidth),
              SizedBox(height: components.memberAvatarGap),
              bar(components.memberSkeletonRoleWidth),
            ],
          ),
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r16),
        border: Border.all(color: colors.line, width: AppTheme.dimensions.stroke.small),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.s24),
        child: Wrap(
          spacing: spacing.s16,
          runSpacing: spacing.s12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Não foi possível carregar a equipe.',
              style: AppTheme.typography.of(context).regular.copyWith(color: colors.inkSecondary),
            ),
            SecondaryButton.small(text: 'Tentar de novo', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
