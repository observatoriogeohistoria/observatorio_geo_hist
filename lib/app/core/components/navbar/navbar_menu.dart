import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/navbutton.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_dropdown.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

List<Widget> buildNavbarMenu(
  BuildContext context,
  List<NavButtonItem> navButtonItens,
  CategoryModel? categorySelected,
  void Function(CategoryModel?) onCategorySelected,
) {
  bool isMobile = ScreenUtils.isMobile(context);

  return navButtonItens.map(
    (option) {
      bool isFirst = option == navButtonItens.first;
      bool noOptions = (option.options?.isEmpty ?? true);

      // Not evaluated on mobile: the menu is built inside a dialog, which has
      // no GoRouterState above its context.
      final isActive = !isMobile &&
          (((categorySelected?.areas.isNotEmpty ?? false) &&
                  categorySelected!.areas.first == option.area) ||
              (option.route != null && AppRoutes.isCurrentRoute(context, option.route!)));

      if (!isMobile && !noOptions) {
        return Padding(
          padding: EdgeInsets.only(
            left: isFirst ? 0 : AppTheme.dimensions.space.mini.horizontalSpacing,
          ),
          child: NavbarDropdown(
            title: option.title,
            backgroundColor: isActive ? AppTheme.colors.lighterGray : null,
            entries: [
              for (final suboption in option.options!)
                NavbarDropdownEntry(
                  title: suboption.title,
                  isDisabled: suboption.isDisabled,
                  isSelected:
                      suboption.category != null && suboption.category == categorySelected,
                  onTap: () {
                    if (suboption.onTap != null) {
                      suboption.onTap!.call();
                      return;
                    }

                    onCategorySelected.call(suboption.category);
                    GoRouter.of(context).go(
                      '/posts/${suboption.category!.areas.first.key}/${suboption.category!.key}',
                      extra: suboption.category,
                    );
                  },
                ),
            ],
          ),
        );
      }

      return Padding(
        padding: isMobile
            ? EdgeInsets.zero
            : EdgeInsets.only(left: isFirst ? 0 : AppTheme.dimensions.space.mini.horizontalSpacing),
        child: NavButton(
          text: option.title,
          onPressed: () {
            if (option.isDisabled) return;

            if (option.onTap != null) {
              if (isMobile) GoRouter.of(context).pop();
              option.onTap?.call();
              return;
            }

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
                        if (suboption.isDisabled) return;

                        if (suboption.onTap != null) {
                          GoRouter.of(context).pop();
                          suboption.onTap?.call();
                          return;
                        }

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
          backgroundColor: isActive ? AppTheme.colors.lighterGray : null,
          textStyle: isMobile ? AppTheme.typography.headline.big : null,
          textColor: isMobile ? AppTheme.colors.white : null,
          textColorOnHover: isMobile ? AppTheme.colors.darkGray : null,
        ),
      );
    },
  ).toList();
}
