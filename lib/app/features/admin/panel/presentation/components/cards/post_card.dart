import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final PostModel post;
  final void Function() onEdit;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme(context).dimensions.space.medium,
        vertical: AppTheme(context).dimensions.space.small,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTitle.big(
                  text: post.title,
                  color: AppTheme(context).colors.darkGray,
                ),
                SizedBox(height: AppTheme(context).dimensions.space.small),
                AppBody.medium(
                  text: post.subtitle,
                  color: AppTheme(context).colors.gray,
                ),
                SizedBox(height: AppTheme(context).dimensions.space.small),
                const AppDivider(indent: null),
                SizedBox(height: AppTheme(context).dimensions.space.small),
                AppBody.big(
                  text: '${post.area.name} | ${post.category.title}',
                  color: AppTheme(context).colors.gray,
                ),
                SizedBox(height: AppTheme(context).dimensions.space.medium),
                AppLabel.small(
                  text: post.published ? 'Publicado' : 'Não Publicado',
                  color: post.published
                      ? AppTheme(context).colors.green
                      : AppTheme(context).colors.red,
                ),
              ],
            ),
          ),
          SizedBox(width: AppTheme(context).dimensions.space.medium),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: AppTheme(context).colors.orange),
                onPressed: onEdit,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: AppTheme(context).colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
