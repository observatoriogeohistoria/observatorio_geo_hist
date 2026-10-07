import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
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
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderTitle(
          title: 'Biblioteca',
          onCreate: () {},
          canEdit: false,
          isLoading: false,
        ),
        SizedBox(height: spacing.s32),
        Wrap(
          spacing: spacing.s24,
          runSpacing: spacing.s24,
          children: [
            for (var area in DocumentArea.values)
              AppFocusRing(
                borderRadius: radius,
                child: Material(
                  color: colors.accent,
                  borderRadius: radius,
                  child: InkWell(
                    borderRadius: radius,
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () => GoRouter.of(context).go(AppRoutes.panelLibraryArea(area.routeKey)),
                    child: Padding(
                      padding: EdgeInsets.all(spacing.s24),
                      child: Text(
                        area.value,
                        style: AppTheme.typography.of(context).h3.copyWith(color: colors.white),
                      ),
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
