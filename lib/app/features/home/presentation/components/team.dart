import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/carousel_options/carousel_options.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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

  bool get isMobile => DeviceUtils.isMobile(context);
  bool get isTablet => DeviceUtils.isTablet(context);
  bool get isDesktop => DeviceUtils.isDesktop(context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: (isDesktop
                ? AppTheme.dimensions.space.gigantic
                : (isTablet ? AppTheme.dimensions.space.massive : AppTheme.dimensions.space.large))
            .horizontalSpacing,
        vertical: AppTheme.dimensions.space.large.verticalSpacing,
      ),
      child: Column(
        children: [
          TitleWidget(
            title: 'EQUIPE',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          Row(
            children: [
              _buildArrow(
                controller: carouselController,
                isBack: true,
              ),
              Expanded(
                child: CarouselSlider.builder(
                  options: carouselOptions.copyWith(
                    height: isMobile ? null : 100.verticalSpacing,
                  ),
                  carouselController: carouselController,
                  itemCount: widget.team.length,
                  itemBuilder: (context, index, realIndex) {
                    final member = widget.team[index];

                    return AppMouseRegion(
                      child: GestureDetector(
                        onTap: () {
                          if (member.description?.isEmpty ?? true) return;

                          GoRouter.of(context).go(
                            '/team-member/${member.id}',
                            extra: member,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppBody.big(
                              text: member.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              color: AppTheme.colors.orange,
                            ),
                            AppTitle.medium(
                              text: member.role,
                              textAlign: TextAlign.center,
                              color: AppTheme.colors.gray,
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
        padding: isMobile ? EdgeInsets.zero : EdgeInsets.all(AppTheme.dimensions.space.small.scale),
        decoration: BoxDecoration(
          color: AppTheme.colors.orange.withOpacity(0.35),
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
