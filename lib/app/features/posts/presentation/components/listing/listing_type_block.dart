import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/card/post_card_grid.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/stores/states/posts_listing_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

String publicationsCount(int count) => count == 1 ? '1 publicação' : '$count publicações';

class ListingTypeBlock extends StatelessWidget {
  const ListingTypeBlock({
    super.key,
    required this.block,
    required this.count,
    required this.routeFor,
    required this.onLoadMore,
  });

  final PostsTypeBlock block;
  final int? count;
  final String? Function(PostModel post) routeFor;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final plural = block.type.portuguesePlural;
    final count = this.count;
    final moreText = 'Ver mais ${plural.toLowerCase()}';
    const loadingText = 'Carregando…';

    return Padding(
      padding: EdgeInsets.only(
        top: components.listingBlockPaddingTop,
        bottom: components.listingBlockPaddingBottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            headingLevel: 2,
            label: count == null ? plural : '$plural, ${publicationsCount(count)}',
            excludeSemantics: true,
            child: Text.rich(
              TextSpan(
                text: plural,
                children: [
                  if (count != null) ...[
                    WidgetSpan(
                      child: SizedBox(width: components.listingBlockCountGap),
                    ),
                    TextSpan(
                      text: publicationsCount(count),
                      style: styles.small.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors.inkSecondary,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ],
              ),
              style: styles.listingBlockTitle.copyWith(color: colors.ink),
            ),
          ),
          SizedBox(height: components.listingBlockTitleGap),
          PostCardGrid(
            children: [
              for (final post in block.posts)
                if (routeFor(post) case final route?) PostCard(post: post, route: route),
            ],
          ),
          if (block.hasMore || block.loadMoreFailed)
            Padding(
              padding: EdgeInsets.only(
                top: components.listingMorePaddingTop,
                bottom: components.listingMorePaddingBottom,
              ),
              child: Column(
                children: [
                  SecondaryButton.medium(
                    text: block.isLoadingMore ? loadingText : moreText,
                    onPressed: onLoadMore,
                    isDisabled: block.isLoadingMore,
                    reserveTexts: [moreText, loadingText],
                  ),
                  if (block.loadMoreFailed) ...[
                    SizedBox(height: components.listingMoreErrorGap),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        'Não foi possível carregar mais publicações.',
                        textAlign: TextAlign.center,
                        style: styles.small.copyWith(color: colors.error),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
