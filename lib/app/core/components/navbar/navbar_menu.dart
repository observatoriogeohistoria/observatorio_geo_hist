import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

List<Widget> buildNavbarMenu(
  BuildContext context,
  List<NavButtonItem> navButtonItens,
  CategoryModel? categorySelected,
  void Function(CategoryModel?) onCategorySelected,
) {
  bool isMobile = DeviceUtils.isMobile(context);

  return navButtonItens.map(
    (option) {
      bool isFirst = option == navButtonItens.first;
      bool noOptions = (option.options?.isEmpty ?? true);

      return Padding(
        padding: isMobile
            ? EdgeInsets.zero
            : EdgeInsets.only(left: isFirst ? 0 : AppTheme.dimensions.space.mini.horizontalSpacing),
        child: NavButton(
          text: option.title,
          onPressed: () {
            if (!noOptions) return;
            if (isMobile) GoRouter.of(context).pop();

            onCategorySelected.call(null);
            GoRouter.of(context).replace(option.route!);
          },
          menuChildren: noOptions
              ? null
              : option.options!.map(
                  (suboption) {
                    return NavButton(
                      text: suboption.title,
                      onPressed: () {
                        onCategorySelected.call(suboption.category);
                        if (isMobile) GoRouter.of(context).pop();

                        GoRouter.of(context).pop();
                        GoRouter.of(context).go(
                          '/posts/${suboption.category!.areas.first.key}/${suboption.category!.key}',
                          extra: suboption.category,
                        );
                      },
                      menuChildren: const [],
                    );
                  },
                ).toList(),
          backgroundColor: isMobile
              ? null
              : ((categorySelected?.areas.isNotEmpty ?? false) &&
                          categorySelected!.areas.first == option.area) ||
                      (option.route != null && AppRoutes.isCurrentRoute(context, option.route!))
                  ? AppTheme.colors.lighterGray
                  : null,
          textStyle: isMobile ? AppTheme.typography.headline.big : null,
          textColor: isMobile ? AppTheme.colors.white : null,
          textColorOnHover: isMobile ? AppTheme.colors.darkGray : null,
        ),
      );
    },
  ).toList();
}
