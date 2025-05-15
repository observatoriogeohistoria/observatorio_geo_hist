import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateSearchDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateSearchDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateSearchDialog extends StatefulWidget {
  const CreateOrUpdateSearchDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateSearchDialog> createState() => _CreateOrUpdateSearchDialogState();
}

class _CreateOrUpdateSearchDialogState extends State<CreateOrUpdateSearchDialog> {
  late final SearchModel? _initialBody = widget.post.body as SearchModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageController = TextEditingController(text: _initialBody?.image);
  late final _imageCaptionController = TextEditingController(text: _initialBody?.imageCaption);
  late final _coordinatorController = TextEditingController(text: _initialBody?.coordinator ?? '');
  late final _researcherController = TextEditingController(text: _initialBody?.researcher ?? '');
  late final _advisorController = TextEditingController(text: _initialBody?.advisor ?? '');
  late final _coAdvisorController = TextEditingController(text: _initialBody?.coAdvisor ?? '');
  late final _descriptionController = TextEditingController(text: _initialBody?.description ?? '');
  late final _membersController = TextEditingController(text: _initialBody?.members ?? '');
  late final _financierController = TextEditingController(text: _initialBody?.financier ?? '');

  late SearchState? _selectedState = _initialBody?.state;

  bool get _isUpdate => widget.post.id != null;

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      onSubmit: _onCreateOrUpdate,
      isUpdate: _isUpdate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitle.medium(
            text: _isUpdate ? 'Atualizar pesquisa' : 'Criar pesquisa',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppTextField(
            controller: _titleController,
            labelText: 'Título da pesquisa',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppDropdownField<SearchState>(
            hintText: 'Estado da pesquisa',
            items: SearchState.values,
            itemToString: (value) => value.portuguese,
            value: _selectedState,
            onChanged: (value) {
              if (value == null) return;

              SearchState? selected = SearchState.fromPortuguese(value);
              setState(() => _selectedState = selected);
            },
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _imageController,
            labelText: 'URL da imagem',
            hintText: 'https://',
            validator: Validators.isValidUrl,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _imageCaptionController,
            labelText: 'Legenda da imagem',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _coordinatorController,
            labelText: 'Coordenador(a)',
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _researcherController,
            labelText: 'Pesquisador(a)',
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _advisorController,
            labelText: 'Orientador(a)',
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _coAdvisorController,
            labelText: 'Coorientador(a)',
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _descriptionController,
            labelText: 'Descrição',
            minLines: 8,
            maxLines: 8,
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _membersController,
            labelText: 'Integrantes',
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _financierController,
            labelText: 'Financiador',
          ),
        ],
      ),
    );
  }

  void _onCreateOrUpdate() {
    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.search,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: SearchModel(
          title: _titleController.text,
          state: _selectedState!,
          image: _imageController.text,
          imageCaption: _imageCaptionController.text,
          coordinator: _coordinatorController.text,
          researcher: _researcherController.text,
          advisor: _advisorController.text,
          coAdvisor: _coAdvisorController.text,
          description: _descriptionController.text,
          members: _membersController.text,
          financier: _financierController.text,
        ),
      ),
    );
  }
}
