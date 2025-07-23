import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryCollectionCard extends StatelessWidget {
  const LibraryCollectionCard({required this.area, super.key});

  final DocumentArea area;

  @override
  Widget build(BuildContext context) {
    return AppMouseRegion(
      child: GestureDetector(
        onTap: () => GoRouter.of(context).go('/biblioteca/${area.routeKey}'),
        child: Container(
          padding: EdgeInsets.all(AppTheme.dimensions.space.medium.scale),
          decoration: BoxDecoration(
            color: AppTheme.colors.orange,
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
          ),
          child: AppHeadline.medium(
            text: area.value,
            color: AppTheme.colors.white,
            notSelectable: true,
          ),
        ),
      ),
    );
  }
}
