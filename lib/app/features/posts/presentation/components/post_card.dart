import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/image_from_url/image_from_url.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/models/post_model.dart';
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
    final border = BorderSide(color: AppTheme.colors.lightGray);

    return AppMouseRegion(
      child: GestureDetector(
        onTap: () => GoRouter.of(context).go('/posts/${category.area}/${category.key}/${post.id}'),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          padding: EdgeInsets.all(AppTheme.dimensions.space.small),
          decoration: BoxDecoration(
            color: AppTheme.colors.white,
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
            border: Border(
              top: border,
              left: border,
              right: border,
              bottom: border.copyWith(width: 4),
            ),
          ),
          child: Column(
            children: [
              ImageFromUrl(
                imageUrl: post.imgUrl,
                radius: AppTheme.dimensions.radius.large,
              ),
              SizedBox(height: AppTheme.dimensions.space.medium),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
                child: Text(
                  post.title,
                  textAlign: TextAlign.center,
                  style: AppTheme.typography.title.medium,
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
