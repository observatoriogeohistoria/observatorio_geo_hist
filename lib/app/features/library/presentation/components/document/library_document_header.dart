import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/fact_sheet.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryDocumentHeader extends StatelessWidget {
  const LibraryDocumentHeader({super.key, required this.document});

  final LibraryDocumentModel document;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final type = document.type;
    final url = document.documentUrl?.trim() ?? '';

    final facts = [
      ('Autor', document.author),
      ('Instituição', document.institution ?? ''),
      ('Ano', document.year?.toString() ?? ''),
      ('Tipo de produção', type?.value ?? ''),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (type != null) ...[
          SizedBox(height: components.libraryDetailBadgeTop),
          Align(alignment: Alignment.centerLeft, child: TypeBadge(type.value)),
        ],
        SizedBox(
          height:
              type != null ? components.libraryDetailTitleTop : components.libraryDetailBadgeTop,
        ),
        Semantics(
          header: true,
          headingLevel: 1,
          child: Text(document.title, style: styles.detailTitle.copyWith(color: colors.ink)),
        ),
        FactSheet(
          facts: facts,
          tagsLabel: 'Categorias',
          tags: [for (final category in document.categories) category.value],
        ),
        if (url.isNotEmpty) ...[
          SizedBox(height: components.libraryDetailActionTop),
          _OpenButton(url: url),
        ],
      ],
    );
  }
}

class _OpenButton extends StatelessWidget {
  const _OpenButton({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    void open() => openUrl(url);
    final mobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    final button = Semantics(
      button: true,
      label: 'Abrir documento em outra aba',
      onTap: open,
      excludeSemantics: true,
      child: PrimaryButton.medium(
        text: 'Abrir documento',
        trailingIcon: Icons.open_in_new,
        expand: mobile,
        onPressed: open,
      ),
    );

    if (mobile) return button;
    return Align(alignment: Alignment.centerLeft, child: button);
  }
}
