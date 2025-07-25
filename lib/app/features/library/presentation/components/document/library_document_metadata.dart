import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryDocumentMetadata extends StatelessWidget {
  const LibraryDocumentMetadata({
    required this.document,
    super.key,
  });

  final LibraryDocumentModel document;

  @override
  Widget build(BuildContext context) {
    final isMobile = ScreenUtils.isMobile(context);

    final title = _buildMetadataItem('Título', document.title, isMobile: isMobile);
    final author = _buildMetadataItem('Autor', document.author, isMobile: isMobile);
    final institution = _buildMetadataItem('Instituição', document.institution, isMobile: isMobile);
    final year = _buildMetadataItem('Ano', document.year.toString(), isMobile: isMobile);
    final type = _buildMetadataItem('Tipo de produção', document.type?.value, isMobile: isMobile);
    final categories = _buildMetadataItem(
        'Categorias', document.categories.map((category) => category.value).join(' • '),
        isMobile: isMobile);

    if (isMobile) {
      return Column(
        children: [
          title,
          author,
          institution,
          year,
          type,
          categories,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              author,
              institution,
            ],
          ),
        ),
        SizedBox(width: AppTheme.dimensions.space.huge.horizontalSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              year,
              type,
              categories,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataItem(
    String title,
    String? value, {
    bool isMobile = false,
  }) {
    if (value == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        AppTitle.medium(
          text: title,
          color: AppTheme.colors.darkGray,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
        AppBody.medium(
          text: value,
          color: AppTheme.colors.darkGray,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
      ],
    );
  }
}
