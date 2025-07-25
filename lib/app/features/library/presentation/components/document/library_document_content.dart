import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/date/date.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/document/library_document_metadata.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/document/library_document_viewer.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryDocumentContent extends StatelessWidget {
  const LibraryDocumentContent({required this.document, super.key});

  final LibraryDocumentModel document;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.massive.verticalSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppHeadline.big(
                text: document.title,
                color: AppTheme.colors.orange,
              ),
              if (document.createdAt != null) ...[
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                AppBody.medium(
                  text:
                      '${document.createdAt!.monthName} de ${document.createdAt!.year} por ${document.author}',
                  color: AppTheme.colors.gray,
                ),
              ]
            ],
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: LibraryDocumentViewer(document: document),
          ),
          SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
          const AppDivider(),
          SizedBox(height: AppTheme.dimensions.space.massive.verticalSpacing),
          LibraryDocumentMetadata(document: document),
        ],
      ),
    );
  }
}
