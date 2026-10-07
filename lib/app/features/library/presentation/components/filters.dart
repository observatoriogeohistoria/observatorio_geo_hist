import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_multiselect_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/form_label.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/filter_documents_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class Filters extends StatefulWidget {
  const Filters({
    required this.onApplyFilters,
    required this.onClearFilters,
    super.key,
  });

  final VoidCallback onApplyFilters;
  final VoidCallback onClearFilters;

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  late final _filterStore = LibrarySetup.getIt<FilterDocumentsStore>();

  final _scrollController = ScrollController();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _institutionController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenUtils.isDesktop(context);
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final fieldGap = SizedBox(height: spacing.s16);

    return Observer(
      builder: (context) {
        return Container(
          width: isDesktop ? components.panelFiltersWidth : double.infinity,
          decoration: BoxDecoration(
            color: colors.surface,
            border: isDesktop
                ? Border(
                    right: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
                  )
                : null,
          ),
          padding: EdgeInsets.fromLTRB(spacing.s24, spacing.s24, spacing.s24, spacing.s16),
          child: Column(
            children: [
              Expanded(
                child: AppScrollbar(
                  controller: _scrollController,
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      if (!isDesktop)
                        Align(
                          alignment: Alignment.centerRight,
                          child: AppIconButton(
                            tooltip: 'Fechar filtros',
                            icon: Icons.close,
                            // O acento comum fica abaixo de 4,5:1 sobre o fundo do painel.
                            color: colors.accentStrong,
                            size: components.panelTopBarIcon,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      Semantics(
                        header: true,
                        child: Text(
                          'Filtros',
                          style: AppTheme.typography.of(context).h3.copyWith(color: colors.ink),
                        ),
                      ),
                      fieldGap,
                      AppTextField(
                        controller: _titleController,
                        labelText: 'Título',
                        onChanged: (value) => _filterStore.setTitle(value),
                      ),
                      fieldGap,
                      AppTextField(
                        controller: _authorController,
                        labelText: 'Autor',
                        onChanged: (value) => _filterStore.setAuthor(value),
                      ),
                      fieldGap,
                      AppTextField(
                        controller: _institutionController,
                        labelText: 'Instituição',
                        onChanged: (value) => _filterStore.setInstitution(value),
                      ),
                      fieldGap,
                      AppTextField(
                        controller: _yearController,
                        labelText: 'Ano',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) => _filterStore.setYear(int.tryParse(value)),
                      ),
                      fieldGap,
                      const FormLabel(text: 'Tipo de Produção'),
                      AppMultiSelectField<DocumentType>(
                        items: DocumentType.values,
                        itemToString: (item) => item.value,
                        selectedItems: _filterStore.type != null ? [_filterStore.type!] : [],
                        onChanged: (types) =>
                            _filterStore.setType(types.isEmpty ? null : types.first),
                        isSingleSelect: true,
                      ),
                      fieldGap,
                      const FormLabel(text: 'Categorias'),
                      AppMultiSelectField<DocumentCategory>(
                        items: DocumentCategory.values,
                        itemToString: (item) => item.value,
                        selectedItems: _filterStore.categories,
                        onChanged: (categories) => _filterStore.setCategories(categories),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing.s16),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PrimaryButton.medium(
                      text: 'Aplicar Filtros',
                      onPressed: widget.onApplyFilters,
                    ),
                    SizedBox(height: spacing.s8),
                    AppTextButton.small(
                      text: 'Limpar Filtros',
                      onPressed: () {
                        _filterStore.reset();
                        widget.onClearFilters();

                        _titleController.clear();
                        _authorController.clear();
                        _institutionController.clear();
                        _yearController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
