import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    required this.category,
    required this.post,
    required this.index,
    super.key,
  });

  final CategoryModel category;
  final PostModel post;
  final int index;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    bool isEven = widget.index.isEven;
    double sectionWidth =
        (MediaQuery.of(context).size.width - 2 * DeviceUtils.getPageHorizontalPadding(context)) /
                2 -
            AppTheme.dimensions.space.large;

    return AppMouseRegion(
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).go(
              '/posts/${widget.category.areas.first.key}/${widget.category.key}/${widget.post.id}');
        },
        child: Row(
          children: [
            if (isEven) ...[
              _buildImage(sectionWidth, isEven),
              SizedBox(width: AppTheme.dimensions.space.large),
            ],
            SizedBox(
              width: sectionWidth,
              child: Column(
                crossAxisAlignment: isEven ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  if (widget.post.body?.title.isNotEmpty ?? false)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
                      child: AppTitle.big(
                        text: widget.post.body!.title,
                        textAlign: isEven ? TextAlign.start : TextAlign.end,
                        notSelectable: true,
                        color: AppTheme.colors.darkGray,
                      ),
                    ),
                  SizedBox(height: AppTheme.dimensions.space.small),
                  if (_subtitle.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
                      child: AppBody.medium(
                        text: _subtitle,
                        textAlign: isEven ? TextAlign.start : TextAlign.end,
                        notSelectable: true,
                        color: AppTheme.colors.gray,
                      ),
                    ),
                ],
              ),
            ),
            if (!isEven) ...[
              SizedBox(width: AppTheme.dimensions.space.large),
              _buildImage(sectionWidth, isEven),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage(
    double sectionWidth,
    bool isEven,
  ) {
    if (widget.post.body?.image.url?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return AppCard(
      width: sectionWidth,
      child: AppNetworkImage(
        imageUrl: widget.post.body!.image.url!,
        radius: AppTheme.dimensions.radius.large,
        fit: BoxFit.contain,
      ),
    );
  }

  String get _subtitle {
    if (widget.post.type == PostType.article) return (widget.post.body as ArticleModel).subtitle;

    return '';
  }
}
