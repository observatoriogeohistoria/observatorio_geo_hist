import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/utils/carousel_options/carousel_options.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Team extends StatefulWidget {
  const Team({
    required this.team,
    super.key,
  });

  final List<TeamMemberModel> team;

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  final carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppTheme.dimensions.space.large,
        bottom: AppTheme.dimensions.space.xlarge,
        left: AppTheme.dimensions.space.large,
        right: AppTheme.dimensions.space.large,
      ),
      child: Column(
        children: [
          TitleWidget(
            title: 'EQUIPE',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.large),
          Row(
            children: [
              _buildArrow(
                controller: carouselController,
                isBack: true,
              ),
              Expanded(
                child: CarouselSlider.builder(
                  options: carouselOptions.copyWith(
                    height: 80,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.5,
                  ),
                  carouselController: carouselController,
                  itemCount: widget.team.length,
                  itemBuilder: (context, index, realIndex) {
                    final member = widget.team[index];

                    return AppMouseRegion(
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go(
                            '/team-member/${member.id}',
                            extra: member,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              style: AppTheme.typography.title.medium.copyWith(
                                color: AppTheme.colors.gray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildArrow(
                controller: carouselController,
                isBack: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArrow({
    required CarouselSliderController controller,
    required bool isBack,
  }) {
    return GestureDetector(
      onTap: () => isBack ? controller.previousPage() : controller.nextPage(),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(AppTheme.dimensions.space.small),
        decoration: BoxDecoration(
          color: AppTheme.colors.orange.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
        ),
        child: Center(
          child: Icon(
            isBack ? Icons.arrow_back_ios_outlined : Icons.arrow_forward_ios_outlined,
            color: AppTheme.colors.white,
          ),
        ),
      ),
    );
  }
}
