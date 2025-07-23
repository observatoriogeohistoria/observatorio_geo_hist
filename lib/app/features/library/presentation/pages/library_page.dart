import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/partners.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/library_collection_card.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/library_header.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/library_navbar.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: LibraryNavbar()),
          const SliverToBoxAdapter(child: LibraryHeader()),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.getPageHorizontalPadding(context),
                vertical: AppTheme.dimensions.space.huge.verticalSpacing,
              ),
              color: AppTheme.colors.lightGray,
              child: Column(
                children: [
                  AppHeadline.big(
                    text: 'Teses e Dissertações',
                    color: AppTheme.colors.darkGray,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                  AppBody.big(
                    text:
                        "Produções acadêmicas sobre História e Geografia de diversas instituições e pesquisadores, reunidas em um só lugar. De artigos científicos a teses de doutorado, um banco de saberes e conhecimentos construído para você.",
                    color: AppTheme.colors.darkGray,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.massive.verticalSpacing),
                  Wrap(
                    spacing: AppTheme.dimensions.space.small.horizontalSpacing,
                    runSpacing: AppTheme.dimensions.space.small.verticalSpacing,
                    children: DocumentArea.values
                        .map((area) => LibraryCollectionCard(area: area))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Partners()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
