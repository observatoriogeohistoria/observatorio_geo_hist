import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/custom_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/carousel_options/carousel_options.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showHighlightsDialog(
  BuildContext context, {
  required List<PostModel> highlights,
  required VoidCallback onClose,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: HighlightsCarousel(
        highlights: highlights,
        onClose: onClose,
      ),
    ),
  );
}

class HighlightsCarousel extends StatefulWidget {
  const HighlightsCarousel({
    required this.highlights,
    required this.onClose,
    super.key,
  });

  final List<PostModel> highlights;
  final VoidCallback onClose;

  @override
  State<HighlightsCarousel> createState() => _HighlightsCarouselState();
}

class _HighlightsCarouselState extends State<HighlightsCarousel> {
  final _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              widget.onClose();
            },
            child: AppMouseRegion(
              child: Container(
                color: Colors.black.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.getPageHorizontalPadding(context),
            vertical: AppTheme.dimensions.space.massive.verticalSpacing,
          ),
          child: Row(
            children: [
              IntrinsicHeight(
                child: CustomIconButton(
                  icon: Icons.arrow_back_ios_outlined,
                  onTap: () => _carouselController.previousPage(),
                ),
              ),
              SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
              Expanded(
                child: AppCard(
                  isHover: true,
                  borderRadius: AppTheme.dimensions.radius.large,
                  child: CarouselSlider.builder(
                    options: carouselOptions.copyWith(
                      height: isMobile ? MediaQuery.of(context).size.height * 0.3 : null,
                    ),
                    carouselController: _carouselController,
                    itemCount: widget.highlights.length,
                    itemBuilder: (context, index, realIndex) {
                      final highlight = widget.highlights[index];

                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go(
                              '/posts/${highlight.category?.areas.first.key}/${highlight.categoryId}/${highlight.id}');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (highlight.body?.image != null) ...[
                              AppBody.big(
                                text: highlight.body!.title,
                                textAlign: TextAlign.center,
                                color: AppTheme.colors.orange,
                                notSelectable: true,
                              ),
                              SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                            ],
                            if (highlight.body?.image.url != null)
                              AppNetworkImage(
                                imageUrl: highlight.body!.image.url!,
                                noPlaceholder: true,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
              IntrinsicHeight(
                child: CustomIconButton(
                  icon: Icons.arrow_forward_ios_outlined,
                  onTap: () => _carouselController.nextPage(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
