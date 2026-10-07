import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryDocumentCard extends StatelessWidget {
  const LibraryDocumentCard({
    required this.document,
    this.onEdit,
    this.onDelete,
    this.canEdit = false,
    this.canDelete = false,
    super.key,
  });

  final LibraryDocumentModel document;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  final bool canEdit;
  final bool canDelete;

  @override
  Widget build(BuildContext context) {
    final enabledEdit = canEdit && onEdit != null;
    final enabledDelete = canDelete && onDelete != null;

    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);

    final details = [document.author, document.institution, document.year?.toString()]
        .where((e) => e != null && e.isNotEmpty)
        .join(' • ');

    void openDocument() {
      final path = AppRoutes.libraryDocument(document.area.routeKey, document.id ?? '');
      GoRouter.of(context).go(path);
    }

    return Row(
      children: [
        Expanded(
          child: AppFocusRing(
            borderRadius: radius,
            child: Semantics(
              button: true,
              label: 'Abrir documento: ${document.title}',
              onTap: openDocument,
              excludeSemantics: true,
              child: InkWell(
                borderRadius: radius,
                mouseCursor: SystemMouseCursors.click,
                onTap: openDocument,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.s8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.book_outlined,
                        color: colors.inkSecondary,
                        size: components.panelLibraryDocIcon,
                      ),
                      SizedBox(width: spacing.s16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(document.title, style: styles.h3.copyWith(color: colors.ink)),
                            SizedBox(height: components.panelCardTextGap),
                            Text(details,
                                style: styles.regular.copyWith(color: colors.inkSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (enabledEdit || enabledDelete) ...[
          SizedBox(width: spacing.s16),
          Column(
            children: [
              if (enabledEdit)
                AppIconButton(
                  tooltip: 'Editar documento',
                  icon: Icons.edit,
                  color: colors.accent,
                  onPressed: () => onEdit?.call(),
                ),
              if (enabledEdit && enabledDelete) SizedBox(height: components.panelCardActionsGap),
              if (enabledDelete)
                AppIconButton(
                  tooltip: 'Excluir documento',
                  icon: Icons.delete,
                  color: colors.error,
                  onPressed: () => onDelete?.call(),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
