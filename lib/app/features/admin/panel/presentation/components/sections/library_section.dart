import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
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
        Observer(
          builder: (_) => PanelSectionHeader(
            eyebrow: SidebarItem.library.eyebrow,
            title: SidebarItem.library.title,
            summary: countSummary(
              PanelSetup.getIt<PanelCountsStore>().counts.libraryTotal,
              'documento',
              'documentos',
            ),
          ),
        ),
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
