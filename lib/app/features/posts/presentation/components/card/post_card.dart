import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    required this.category,
    required this.post,
    required this.index,
    required this.backgroundColor,
    required this.borderColor,
    super.key,
  });

  final CategoryModel category;
  final PostModel post;
  final int index;

  final Color backgroundColor;
  final Color borderColor;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isHovered = false;

  bool get _isMobile => ScreenUtils.isMobile(context);

  @override
  Widget build(BuildContext context) {
    BorderSide border = BorderSide(color: widget.borderColor);

    return AppMouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: _isHovered ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        padding: EdgeInsets.all(AppTheme.dimensions.space.medium.horizontalSpacing),
        decoration: BoxDecoration(
          color: _isHovered ? widget.backgroundColor : null,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
          border: _isHovered
              ? Border(
                  top: border,
                  left: border,
                  right: border,
                  bottom: border.copyWith(width: AppTheme.dimensions.stroke.huge),
                )
              : null,
        ),
        child: GestureDetector(
          onTap: () {
            GoRouter.of(context).go(
                '/posts/${widget.category.areas.first.key}/${widget.category.key}/${widget.post.id}');
          },
          child: Column(
            children: [
              if (widget.post.body?.image.url?.isNotEmpty ?? false)
                AppNetworkImage(
                  imageUrl: widget.post.body!.image.url!,
                  radius: 0,
                  fit: BoxFit.contain,
                  noPlaceholder: true,
                ),
              SizedBox(height: AppTheme.dimensions.space.large),
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.post.body?.title.isNotEmpty ?? false)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
                        child: AppTitle.big(
                          text: widget.post.body!.title,
                          textAlign: _isMobile ? TextAlign.center : TextAlign.start,
                          notSelectable: true,
                          color: _isHovered ? AppTheme.colors.orange : AppTheme.colors.darkGray,
                        ),
                      ),
                    SizedBox(height: AppTheme.dimensions.space.small),
                    if (_subtitle.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
                        child: AppBody.medium(
                          text: _subtitle,
                          textAlign: _isMobile ? TextAlign.center : TextAlign.start,
                          notSelectable: true,
                          color: AppTheme.colors.gray,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _subtitle {
    if (widget.post.type == PostType.article) return (widget.post.body as ArticleModel).subtitle;

    return '';
  }
}
