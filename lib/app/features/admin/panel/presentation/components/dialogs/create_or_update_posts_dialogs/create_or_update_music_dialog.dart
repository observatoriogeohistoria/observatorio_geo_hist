import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/editor_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/music_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateMusicDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateMusicDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateMusicDialog extends StatefulWidget {
  const CreateOrUpdateMusicDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateMusicDialog> createState() => _CreateOrUpdateMusicDialogState();
}

class _CreateOrUpdateMusicDialogState extends State<CreateOrUpdateMusicDialog> {
  final StreamController<Completer<String>> _lyricsController = StreamController();

  late final MusicModel? _initialBody = widget.post.body as MusicModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _artistController = TextEditingController(text: _initialBody?.artistName);
  late final _imageController = TextEditingController(text: _initialBody?.image);
  late final _descriptionController = TextEditingController(text: _initialBody?.description);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  late final String? _initialLyrics = _initialBody?.lyrics;

  bool get _isUpdate => widget.post.id != null;

  Future<String> _getLyrics() {
    final complete = Completer<String>();
    _lyricsController.add(complete);
    return complete.future;
  }

  @override
  void dispose() {
    _lyricsController.close();
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
            text: _isUpdate ? 'Atualizar música' : 'Criar música',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppTextField(
            controller: _titleController,
            labelText: 'Nome da música',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _artistController,
            labelText: 'Nome do artista',
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
            controller: _descriptionController,
            labelText: 'Descrição',
            validator: Validators.isNotEmpty,
            maxLines: 3,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          EditorQuill(
            saveController: _lyricsController,
            initialContent: _initialLyrics,
            height: MediaQuery.of(context).size.height * 0.3,
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
    String lyrics = await _getLyrics();

    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.music,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: MusicModel(
          title: _titleController.text,
          artistName: _artistController.text,
          image: _imageController.text,
          description: _descriptionController.text,
          lyrics: lyrics,
          link: _linkController.text,
        ),
      ),
    );
  }
}
