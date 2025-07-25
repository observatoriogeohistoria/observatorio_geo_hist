import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_multiselect_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
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

    return Observer(
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.2,
          color: AppTheme.colors.lighterGray,
          padding: EdgeInsets.only(
            left: AppTheme.dimensions.space.medium.horizontalSpacing,
            right: AppTheme.dimensions.space.medium.horizontalSpacing,
            top: AppTheme.dimensions.space.medium.verticalSpacing,
            bottom: AppTheme.dimensions.space.small.verticalSpacing,
          ),
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
                            icon: Icons.close,
                            color: AppTheme.colors.orange,
                            size: 32,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      AppHeadline.medium(
                        text: 'Filtros',
                        color: AppTheme.colors.darkGray,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                      AppTextField(
                        controller: _titleController,
                        labelText: 'Título',
                        onChanged: (value) => _filterStore.setTitle(value),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                      AppTextField(
                        controller: _authorController,
                        labelText: 'Autor',
                        onChanged: (value) => _filterStore.setAuthor(value),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                      AppTextField(
                        controller: _institutionController,
                        labelText: 'Instituição',
                        onChanged: (value) => _filterStore.setInstitution(value),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                      AppTextField(
                        controller: _yearController,
                        labelText: 'Ano',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) => _filterStore.setYear(int.tryParse(value)),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                      AppTitle.medium(
                        text: "Tipo de Produção",
                        color: AppTheme.colors.orange,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                      AppMultiSelectField<DocumentType>(
                        items: DocumentType.values,
                        itemToString: (item) => item.value,
                        selectedItems: _filterStore.type != null ? [_filterStore.type!] : [],
                        onChanged: (types) =>
                            _filterStore.setType(types.isEmpty ? null : types.first),
                        isSingleSelect: true,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                      AppTitle.medium(
                        text: "Categorias",
                        color: AppTheme.colors.orange,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
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
              SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PrimaryButton.medium(
                      text: 'Aplicar Filtros',
                      onPressed: widget.onApplyFilters,
                    ),
                    SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
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
