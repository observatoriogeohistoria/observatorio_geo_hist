import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/image_from_url/image_from_url.dart';
import 'package:observatorio_geo_hist/app/features/posts/infra/models/post_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    super.key,
  });

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      padding: EdgeInsets.all(AppTheme.dimensions.space.small),
      decoration: BoxDecoration(
        color: AppTheme.colors.white,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ImageFromUrl(
            imageUrl: post.imgUrl,
            radius: AppTheme.dimensions.radius.large,
          ),
          SizedBox(height: AppTheme.dimensions.space.small),
          Text(
            post.title,
            style: AppTheme.typography.headline.medium,
          ),
        ],
      ),
    );
  }
}
