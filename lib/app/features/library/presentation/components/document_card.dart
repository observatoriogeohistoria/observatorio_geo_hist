import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({required this.document, super.key});

  final LibraryDocumentModel document;

  @override
  Widget build(BuildContext context) {
    return AppMouseRegion(
      child: ListTile(
        leading: Icon(Icons.picture_as_pdf, color: AppTheme.colors.gray),
        title: AppTitle.medium(
          text: document.title,
          color: AppTheme.colors.darkGray,
        ),
        subtitle: AppBody.medium(
          text: [document.author, document.institution, document.year.toString()]
              .where((e) => e.isNotEmpty)
              .join(' • '),
          color: AppTheme.colors.gray,
        ),
        trailing: AppBody.medium(
          text: document.year.toString(),
          color: AppTheme.colors.gray,
        ),
        onTap: () {
          // TODO: abrir detalhes do documento
        },
      ),
    );
  }
}
