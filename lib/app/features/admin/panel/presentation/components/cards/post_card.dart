import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.index,
    required this.onPublish,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final PostModel post;
  final int index;
  final void Function() onPublish;
  final void Function() onEdit;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLabel.small(
                    text: '$index',
                    color: AppTheme.colors.gray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.xsmall.verticalSpacing),
                  AppTitle.big(
                    text: post.title,
                    color: AppTheme.colors.darkGray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppBody.medium(
                    text: post.subtitle,
                    color: AppTheme.colors.gray,
                  ),
                  const AppDivider(indent: null),
                  AppBody.big(
                    text: '${post.area.name} | ${post.category.title}',
                    color: AppTheme.colors.gray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                  AppLabel.medium(
                    text: post.published ? 'Publicado' : 'Não Publicado',
                    color: post.published ? AppTheme.colors.green : AppTheme.colors.red,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Tooltip(
                  message: post.published ? 'Despublicar post' : 'Publicar post',
                  child: AppIconButton(
                    icon: post.published ? Icons.public_off : Icons.public,
                    color: AppTheme.colors.orange,
                    onPressed: onPublish,
                  ),
                ),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                AppIconButton(
                  icon: Icons.edit,
                  color: AppTheme.colors.gray,
                  onPressed: onEdit,
                ),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                AppIconButton(
                  icon: Icons.delete,
                  color: AppTheme.colors.red,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
