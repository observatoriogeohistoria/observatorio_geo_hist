import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/utils/carousel_options/carousel_options.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Team extends StatelessWidget {
  const Team({
    required this.team,
    super.key,
  });

  final List<TeamMemberModel> team;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.dimensions.space.large,
        vertical: AppTheme.dimensions.space.large,
      ),
      child: Column(
        children: [
          TitleWidget(
            title: 'EQUIPE',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.xlarge),
          CarouselSlider.builder(
            options: carouselOptions,
            itemCount: team.length,
            itemBuilder: (context, index, realIndex) {
              final member = team[index];

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    GoRouter.of(context).go(
                      '/team-member/${member.name}',
                      extra: member,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        member.name.toUpperCase(),
                        style: AppTheme.typography.body.large.copyWith(
                          color: AppTheme.colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        member.role,
                        style: AppTheme.typography.headline.medium.copyWith(
                          color: AppTheme.colors.gray,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
