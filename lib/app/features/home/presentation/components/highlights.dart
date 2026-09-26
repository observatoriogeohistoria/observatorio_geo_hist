import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/app_setup.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/custom_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/carousel_options/carousel_options.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_highlights_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Highlights extends StatefulWidget {
  const Highlights({super.key});

  @override
  State<Highlights> createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights> {
  late final _fetchHighlightsStore = AppSetup.getIt.get<FetchHighlightsStore>();

  final _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);

    return Observer(
      builder: (context) {
        final highlights = _fetchHighlightsStore.highlights;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                alignment: Alignment.topCenter,
                child: child,
              ),
            );
          },
          child: highlights.isEmpty
              ? const SizedBox.shrink(key: ValueKey('empty'))
              : Column(
                  key: const ValueKey('content'),
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.dimensions.space.massive.horizontalSpacing,
                        vertical: AppTheme.dimensions.space.medium.verticalSpacing,
                      ),
                      width: double.infinity,
                      color: AppTheme.colors.gray,
                    ),
                    Stack(
                      children: [
                        CarouselSlider.builder(
                          options: carouselOptions.copyWith(
                            autoPlay: highlights.length > 1,
                            height: isMobile
                                ? MediaQuery.of(context).size.height * 0.5
                                : MediaQuery.of(context).size.height * 0.85,
                          ),
                          carouselController: _carouselController,
                          itemCount: highlights.length,
                          itemBuilder: (context, index, realIndex) {
                            final highlight = highlights[index];
                            if (highlight.body == null) return const SizedBox.shrink();

                            return AppMouseRegion(
                              child: GestureDetector(
                                onTap: () {
                                  GoRouter.of(context).go(
                                      '/posts/${highlight.category?.areas.first.key}/${highlight.categoryId}/${highlight.id}');
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    AppNetworkImage(
                                      imageUrl: highlight.body!.image.url!,
                                      noPlaceholder: true,
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withValues(alpha: 0.7),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      child: AppHeadline.big(
                                        text: highlight.body!.title,
                                        textAlign: TextAlign.center,
                                        color: AppTheme.colors.white,
                                        notSelectable: true,
                                      ),
                                    ),
                                    SizedBox(
                                        height: AppTheme.dimensions.space.medium.verticalSpacing),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          left: AppTheme.dimensions.space.small.horizontalSpacing,
                          right: AppTheme.dimensions.space.small.horizontalSpacing,
                          top: 0,
                          bottom: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: AppTheme.dimensions.space.medium.horizontalSpacing,
                              children: [
                                IntrinsicHeight(
                                  child: CustomIconButton(
                                    icon: Icons.arrow_back_ios_outlined,
                                    onTap: () => _carouselController.previousPage(),
                                  ),
                                ),
                                IntrinsicHeight(
                                  child: CustomIconButton(
                                    icon: Icons.arrow_forward_ios_outlined,
                                    onTap: () => _carouselController.nextPage(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.dimensions.space.massive.horizontalSpacing,
                        vertical: AppTheme.dimensions.space.medium.verticalSpacing,
                      ),
                      width: double.infinity,
                      color: AppTheme.colors.gray,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
