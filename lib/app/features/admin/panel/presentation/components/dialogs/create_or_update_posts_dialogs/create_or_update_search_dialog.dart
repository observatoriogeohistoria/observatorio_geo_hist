import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_image_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/post_form_dialog.dart';
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
  final StreamController<Completer<FileModel?>> _imageController = StreamController();

  late final SearchModel? _initialBody = widget.post.body as SearchModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageUrlController = TextEditingController(text: _initialBody?.image.url);
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

  Future<FileModel?> _getImage() {
    final completer = Completer<FileModel?>();
    _imageController.add(completer);

    return completer.future;
  }

  @override
  void dispose() {
    _imageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PostFormDialog(
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
          AppImageField(
            imageUrlController: _imageUrlController,
            imageController: _imageController,
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

  Future<void> _onCreateOrUpdate() async {
    FileModel? image = await _getImage();

    if ((image?.isNull ?? true) && _imageUrlController.text.isEmpty) {
      _showErrorMessage('Preencha a imagem do post');
      return;
    }

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
          image: FileModel(
            url: _imageUrlController.text,
            bytes: image?.bytes,
            name: image?.name,
          ),
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

  void _showErrorMessage(String message) {
    if (context.mounted) {
      Messenger.showError(context, message);
    }
  }
}
