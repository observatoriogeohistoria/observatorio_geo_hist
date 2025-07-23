import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/document_card.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/fetch_library_store.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/states/fetch_library_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryListPage extends StatefulWidget {
  const LibraryListPage({super.key, required this.area});

  final DocumentArea area;

  @override
  State<LibraryListPage> createState() => _LibraryListPageState();
}

class _LibraryListPageState extends State<LibraryListPage> {
  late final _store = LibrarySetup.getIt<FetchLibraryStore>();

  final _scrollController = ScrollController();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _institutionController = TextEditingController();
  final _yearController = TextEditingController();

  DocumentType? _selectedType;
  DocumentCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  void _fetchDocuments() {
    _store.fetchDocumentsByArea(
      widget.area,
      type: _selectedType,
      category: _selectedCategory,
      title: _titleController.text.isEmpty ? null : _titleController.text,
      author: _authorController.text.isEmpty ? null : _authorController.text,
      institution: _institutionController.text.isEmpty ? null : _institutionController.text,
      year: _yearController.text.isEmpty ? null : int.tryParse(_yearController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppHeadline.big(
          text: widget.area.value,
          color: AppTheme.colors.white,
        ),
        backgroundColor: AppTheme.colors.orange,
        foregroundColor: AppTheme.colors.white,
        elevation: 0,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            color: AppTheme.colors.lighterGray,
            padding: EdgeInsets.symmetric(
              vertical: AppTheme.dimensions.space.medium.verticalSpacing,
              horizontal: AppTheme.dimensions.space.medium.horizontalSpacing,
            ),
            child: ListView(
              children: [
                AppHeadline.medium(
                  text: 'Filtros',
                  color: AppTheme.colors.darkGray,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppTextField(
                  controller: _titleController,
                  labelText: 'Título',
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppDropdownField<DocumentType>(
                  value: _selectedType,
                  items: DocumentType.values,
                  itemToString: (item) => item.value,
                  hintText: 'Tipo de produção',
                  onChanged: (value) => setState(() => _selectedType = DocumentType.fromKey(value)),
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppDropdownField<DocumentCategory>(
                  value: _selectedCategory,
                  items: DocumentCategory.values,
                  itemToString: (item) => item.value,
                  hintText: 'Categoria',
                  onChanged: (value) =>
                      setState(() => _selectedCategory = DocumentCategory.fromKey(value)),
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppTextField(
                  controller: _authorController,
                  labelText: 'Autor',
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppTextField(
                  controller: _institutionController,
                  labelText: 'Instituição',
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppTextField(
                  controller: _yearController,
                  labelText: 'Ano',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                PrimaryButton.medium(
                  text: 'Aplicar Filtros',
                  onPressed: _fetchDocuments,
                ),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppTextButton.small(
                    text: 'Limpar Filtros',
                    onPressed: () {
                      setState(() {
                        _selectedType = null;
                        _selectedCategory = null;
                        _authorController.clear();
                        _institutionController.clear();
                        _yearController.clear();
                        _titleController.clear();
                      });

                      _fetchDocuments();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.dimensions.space.medium.horizontalSpacing,
                vertical: AppTheme.dimensions.space.medium.verticalSpacing,
              ),
              child: Observer(
                builder: (_) {
                  final state = _store.state;

                  if (state is FetchLibraryLoadingState) {
                    if (!state.isRefreshing) return const Center(child: CircularLoading());
                  }

                  if (state is FetchLibraryErrorState) {
                    return Center(
                      child: AppTitle.big(
                        text: state.message,
                        color: AppTheme.colors.darkGray,
                      ),
                    );
                  }

                  final docs = _store.documentsByArea[widget.area.name] ?? [];
                  if (docs.isEmpty) {
                    return Center(
                      child: AppTitle.big(
                        text: 'Nenhum documento encontrado.',
                        color: AppTheme.colors.darkGray,
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppScrollbar(
                          controller: _scrollController,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            controller: _scrollController,
                            itemCount: docs.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final doc = docs[index];
                              return DocumentCard(document: doc);
                            },
                          ),
                        ),
                      ),
                      if (_store.hasMore[widget.area] == true)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: AppTheme.dimensions.space.medium.verticalSpacing,
                            ),
                            child: SecondaryButton.medium(
                              text: _store.state is FetchLibraryLoadingState
                                  ? 'Carregando...'
                                  : 'Carregar mais',
                              onPressed: _fetchDocuments,
                              isDisabled: _store.state is FetchLibraryLoadingState,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
