import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/image_from_url/image_from_url.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
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
    return AppMouseRegion(
      child: GestureDetector(
        onTap: () =>
            GoRouter.of(context).go('/posts/${category.area.key}/${category.key}/${post.id}'),
        child: AppCard(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Column(
            children: [
              ImageFromUrl(
                imageUrl: post.imgUrl,
                radius: AppTheme(context).dimensions.radius.large,
              ),
              SizedBox(height: AppTheme(context).dimensions.space.medium),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTheme(context).dimensions.space.small),
                child: AppTitle.small(
                  text: post.title,
                  textAlign: TextAlign.center,
                  color: AppTheme(context).colors.darkGray,
                ),
              ),
              SizedBox(height: AppTheme(context).dimensions.space.small),
            ],
          ),
        ),
      ),
    );
  }
}
