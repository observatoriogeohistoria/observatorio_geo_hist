import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/common_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({
    required this.category,
    super.key,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: isMobile ? null : MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.huge.verticalSpacing,
      ),
      decoration: BoxDecoration(
        image: (category.backgroundImg.url?.isNotEmpty ?? false)
            ? DecorationImage(
                image: NetworkImage(category.backgroundImg.url!),
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.5),
                  BlendMode.darken,
                ),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonTitle(title: category.title.toUpperCase()),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppBody.big(
            text: category.description,
            textAlign: TextAlign.center,
            color: AppTheme.colors.white,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          if (category.hasCollaborateOption)
            PrimaryButton.medium(
              text: 'COLABORE',
              onPressed: () => GoRouter.of(context).go('/colaborar'),
            ),
        ],
      ),
    );
  }
}
