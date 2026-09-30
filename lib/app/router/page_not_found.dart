import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          const NavbarSliver(),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppHeadline.big(
                        text: '404',
                        color: AppTheme.colors.darkGray,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                      AppTitle.big(
                        text: 'Página não encontrada',
                        color: AppTheme.colors.gray,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                      PrimaryButton.big(
                        text: 'HOME',
                        onPressed: () => GoRouter.of(context).go(AppRoutes.root),
                      ),
                    ],
                  ),
                ),
                const Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
