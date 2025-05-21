import 'dart:async';

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_image_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdatePodcastDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdatePodcastDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdatePodcastDialog extends StatefulWidget {
  const CreateOrUpdatePodcastDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdatePodcastDialog> createState() => _CreateOrUpdatePodcastDialogState();
}

class _CreateOrUpdatePodcastDialogState extends State<CreateOrUpdatePodcastDialog> {
  final StreamController<Completer<ImageModel?>> _imageController = StreamController();

  late final PodcastModel? _initialBody = widget.post.body as PodcastModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageUrlController = TextEditingController(text: _initialBody?.image.url);
  late final _descriptionController = TextEditingController(text: _initialBody?.description);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  bool get _isUpdate => widget.post.id != null;

  Future<ImageModel?> _getImage() {
    final completer = Completer<ImageModel?>();
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
    return FormDialog(
      onSubmit: _onCreateOrUpdate,
      isUpdate: _isUpdate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitle.medium(
            text: _isUpdate ? 'Atualizar podcast' : 'Criar podcast',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
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
            controller: _descriptionController,
            labelText: 'Descrição',
            validator: Validators.isNotEmpty,
            maxLines: 5,
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
    ImageModel? image = await _getImage();

    if ((image?.isNull ?? true) && _imageUrlController.text.isEmpty) {
      _showErrorMessage('Preencha a imagem do post');
      return;
    }

    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.podcast,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: PodcastModel(
          title: _titleController.text,
          image: ImageModel(
            url: _imageUrlController.text,
            bytes: image?.bytes,
            name: image?.name,
          ),
          description: _descriptionController.text,
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
