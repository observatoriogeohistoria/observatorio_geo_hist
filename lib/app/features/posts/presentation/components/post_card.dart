import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/network_image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.category,
    required this.post,
    super.key,
  });

  final CategoryModel category;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    bool isMobile = DeviceUtils.isMobile(context);
    bool isTablet = DeviceUtils.isTablet(context);

    return AppMouseRegion(
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).go('/posts/${category.areas.first.key}/${category.key}/${post.id}');
        },
        child: AppCard(
          width: MediaQuery.of(context).size.width * (isMobile ? 1 : (isTablet ? 0.4 : 0.2)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppNetworkImage(
                imageUrl: post.imgUrl,
                radius: AppTheme.dimensions.radius.large,
              ),
              SizedBox(height: AppTheme.dimensions.space.medium),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
                child: AppTitle.big(
                  text: post.title,
                  textAlign: TextAlign.center,
                  color: AppTheme.colors.darkGray,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
                child: AppBody.medium(
                  text: post.subtitle,
                  textAlign: TextAlign.center,
                  color: AppTheme.colors.gray,
                ),
              ),
              SizedBox(height: AppTheme.dimensions.space.small),
            ],
          ),
        ),
      ),
    );
  }
}
