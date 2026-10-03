import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/library_labels.dart';
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
    ].map((fact) => (fact.$1, fact.$2.trim())).where((fact) => fact.$2.isNotEmpty).toList();
    final categories = document.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (type != null) ...[
          SizedBox(height: components.libraryDetailBadgeTop),
          Align(alignment: Alignment.centerLeft, child: LibraryTypeBadge(type.value)),
        ],
        SizedBox(
          height:
              type != null ? components.libraryDetailTitleTop : components.libraryDetailBadgeTop,
        ),
        Semantics(
          header: true,
          headingLevel: 1,
          child: Text(document.title, style: styles.libraryDetailTitle.copyWith(color: colors.ink)),
        ),
        if (facts.isNotEmpty || categories.isNotEmpty) _Facts(facts: facts, categories: categories),
        if (url.isNotEmpty) ...[
          SizedBox(height: components.libraryDetailActionTop),
          _OpenButton(url: url),
        ],
      ],
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.facts, required this.categories});

  final List<(String, String)> facts;
  final List<DocumentCategory> categories;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final line = BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small);

    return Container(
      margin: EdgeInsets.only(top: components.libraryFactsTop),
      padding: EdgeInsets.symmetric(vertical: components.libraryFactsPaddingV),
      decoration: BoxDecoration(border: Border(top: line, bottom: line)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final gap = components.libraryFactsGapH;
          final columns = ((width + gap) / (components.libraryFactsMinColumn + gap))
              .floor()
              .clamp(1, components.libraryFactsMaxColumns);
          final columnWidth = (width - gap * (columns - 1)) / columns;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (facts.isNotEmpty)
                Wrap(
                  spacing: gap,
                  runSpacing: components.libraryFactsGapV,
                  children: [
                    for (final (label, value) in facts)
                      SizedBox(
                        width: columnWidth,
                        child: _Fact(
                          label: label,
                          spokenValue: value,
                          child: Text(
                            value,
                            style: AppTheme.typography
                                .of(context)
                                .libraryFactValue
                                .copyWith(color: colors.ink),
                          ),
                        ),
                      ),
                  ],
                ),
              if (facts.isNotEmpty && categories.isNotEmpty)
                SizedBox(height: components.libraryFactsGapV),
              if (categories.isNotEmpty)
                _Fact(
                  label: 'Categorias',
                  spokenValue: categories.map((category) => category.value).join(', '),
                  child: Wrap(
                    spacing: components.libraryTagGap,
                    runSpacing: components.libraryTagGap,
                    children: [
                      for (final category in categories) LibraryCategoryTag(category.value),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.spokenValue, required this.child});

  final String label;
  final String spokenValue;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$label, $spokenValue',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style:
                AppTheme.typography.of(context).label.copyWith(color: AppTheme.colors.inkSecondary),
          ),
          SizedBox(height: AppTheme.dimensions.components.libraryFactLabelGap),
          child,
        ],
      ),
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
