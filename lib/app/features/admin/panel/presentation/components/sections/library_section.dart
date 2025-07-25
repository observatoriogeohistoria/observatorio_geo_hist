import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/section_header_title.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibrarySection extends StatefulWidget {
  const LibrarySection({super.key});

  @override
  State<LibrarySection> createState() => _LibrarySectionState();
}

class _LibrarySectionState extends State<LibrarySection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderTitle(
          title: 'Biblioteca',
          onCreate: () {},
          canEdit: false,
          isLoading: false,
        ),
        SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
        Wrap(
          spacing: AppTheme.dimensions.space.large.horizontalSpacing,
          runSpacing: AppTheme.dimensions.space.large.verticalSpacing,
          children: [
            for (var area in DocumentArea.values)
              AppMouseRegion(
                child: GestureDetector(
                  onTap: () => GoRouter.of(context).go('/admin/painel/biblioteca/${area.routeKey}'),
                  child: Container(
                    padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
                    decoration: BoxDecoration(
                      color: AppTheme.colors.orange,
                      borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
                    ),
                    child: AppHeadline.big(
                      text: area.value,
                      color: AppTheme.colors.white,
                      notSelectable: true,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
