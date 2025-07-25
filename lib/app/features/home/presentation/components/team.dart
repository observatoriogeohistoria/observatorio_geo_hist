import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/custom_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/components/text/common_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/carousel_options/carousel_options.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
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
  final _carouselController = CarouselSliderController();

  bool get _isMobile => ScreenUtils.isMobile(context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.large.verticalSpacing,
      ),
      child: Column(
        children: [
          CommonTitle(
            title: 'EQUIPE',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          Row(
            children: [
              CustomIconButton(
                icon: Icons.arrow_back_ios_outlined,
                onTap: () => _carouselController.previousPage(),
              ),
              Expanded(
                child: CarouselSlider.builder(
                  options: carouselOptions.copyWith(
                    height: _isMobile ? null : 100.verticalSpacing,
                  ),
                  carouselController: _carouselController,
                  itemCount: widget.team.length,
                  itemBuilder: (context, index, realIndex) {
                    final member = widget.team[index];

                    return AppMouseRegion(
                      child: GestureDetector(
                        onTap: () {
                          if (member.description?.isEmpty ?? true) return;

                          GoRouter.of(context).go(
                            '/membro/${member.id}',
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
                              notSelectable: true,
                            ),
                            AppTitle.medium(
                              text: member.role,
                              textAlign: TextAlign.center,
                              color: AppTheme.colors.gray,
                              notSelectable: true,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              CustomIconButton(
                icon: Icons.arrow_forward_ios_outlined,
                onTap: () => _carouselController.nextPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
