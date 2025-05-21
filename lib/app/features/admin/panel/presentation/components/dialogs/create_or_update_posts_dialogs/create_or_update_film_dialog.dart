import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_image_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/editor_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/film_model.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateFilmDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateFilmDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateFilmDialog extends StatefulWidget {
  const CreateOrUpdateFilmDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateFilmDialog> createState() => _CreateOrUpdateFilmDialogState();
}

class _CreateOrUpdateFilmDialogState extends State<CreateOrUpdateFilmDialog> {
  final StreamController<Completer<String>> _synopsisController = StreamController();
  final StreamController<Completer<ImageModel?>> _imageController = StreamController();

  late final FilmModel? _initialBody = widget.post.body as FilmModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageUrlController = TextEditingController(text: _initialBody?.image.url);
  late final _yearController = TextEditingController(text: _initialBody?.releaseYear.toString());
  late final _durationController = TextEditingController(text: _initialBody?.duration);
  late final _directorController = TextEditingController(text: _initialBody?.director);
  late final _countryController = TextEditingController(text: _initialBody?.country);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  late final String? _initialSynopsis = _initialBody?.synopsis;

  late FilmCategory? _selectedCategory = _initialBody?.category;

  bool get _isUpdate => widget.post.id != null;

  Future<String> _getSynopsis() {
    final complete = Completer<String>();
    _synopsisController.add(complete);

    return complete.future;
  }

  Future<ImageModel?> _getImage() {
    final completer = Completer<ImageModel?>();
    _imageController.add(completer);

    return completer.future;
  }

  @override
  void dispose() {
    _synopsisController.close();
    _imageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormDialog(
      onSubmit: _onCreateOrUpdate,
      isUpdate: _isUpdate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitle.medium(
            text: _isUpdate ? 'Atualizar filme' : 'Criar filme',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppDropdownField<FilmCategory>(
            hintText: 'Categoria',
            items: FilmCategory.values,
            itemToString: (value) => value.portuguese,
            value: _selectedCategory,
            onChanged: (category) {
              if (category == null) return;

              FilmCategory? selected = FilmCategory.fromPortuguese(category);
              setState(() => _selectedCategory = selected);
            },
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _titleController,
            labelText: 'Título',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppImageField(
            imageUrlController: _imageUrlController,
            imageController: _imageController,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _yearController,
            labelText: 'Ano de lançamento',
            keyboardType: TextInputType.number,
            validator: Validators.isValidYear,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _durationController,
            labelText: 'Duração',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _directorController,
            labelText: 'Direção',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _countryController,
            labelText: 'País',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          EditorQuill(
            saveController: _synopsisController,
            initialContent: _initialSynopsis,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _linkController,
            labelText: 'Link',
            hintText: 'https://',
            validator: Validators.isValidUrl,
          ),
        ],
      ),
    );
  }

  Future<void> _onCreateOrUpdate() async {
    String synopsis = await _getSynopsis();
    ImageModel? image = await _getImage();

    if (synopsis.isEmpty) {
      _showErrorMessage('Preencha a sinopse do post');
      return;
    }

    if ((image?.isNull ?? true) && _imageUrlController.text.isEmpty) {
      _showErrorMessage('Preencha a imagem do post');
      return;
    }

    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.film,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: FilmModel(
          category: _selectedCategory!,
          title: _titleController.text,
          image: ImageModel(
            url: _imageUrlController.text,
            bytes: image?.bytes,
            name: image?.name,
          ),
          releaseYear: int.parse(_yearController.text),
          duration: _durationController.text,
          director: _directorController.text,
          country: _countryController.text,
          synopsis: synopsis,
          link: _linkController.text,
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
