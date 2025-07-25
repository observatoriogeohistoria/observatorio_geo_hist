import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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

    return AppMouseRegion(
      child: GestureDetector(
        onTap: () {
          final path = '/biblioteca/${document.area.routeKey}/documento/${document.slug}';
          GoRouter.of(context).go(path);
        },
        child: Row(
          children: [
            Icon(
              Icons.book_outlined,
              color: AppTheme.colors.gray,
              size: 32.scale,
            ),
            SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTitle.medium(
                    text: document.title,
                    color: AppTheme.colors.darkGray,
                    notSelectable: true,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppBody.medium(
                    text: [document.author, document.institution, document.year.toString()]
                        .where((e) => e != null && e.isNotEmpty)
                        .join(' • '),
                    color: AppTheme.colors.gray,
                    notSelectable: true,
                  ),
                ],
              ),
            ),
            if (enabledEdit || enabledDelete) ...[
              SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
              Column(
                children: [
                  if (enabledEdit) ...[
                    AppIconButton(
                      icon: Icons.edit,
                      color: AppTheme.colors.gray,
                      onPressed: () => onEdit?.call(),
                    ),
                  ],
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  if (enabledDelete) ...[
                    AppIconButton(
                      icon: Icons.delete,
                      color: AppTheme.colors.red,
                      onPressed: () => onDelete?.call(),
                    ),
                  ],
                ],
              )
            ],
          ],
        ),
      ),
    );
  }
}
