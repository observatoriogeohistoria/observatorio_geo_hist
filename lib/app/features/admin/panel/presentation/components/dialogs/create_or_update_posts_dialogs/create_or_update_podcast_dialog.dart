import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/podcast_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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
  late final PodcastModel? _initialBody = widget.post.body as PodcastModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageController = TextEditingController(text: _initialBody?.image);
  late final _descriptionController = TextEditingController(text: _initialBody?.description);
  late final _linkController = TextEditingController(text: _initialBody?.link);

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
          image: _imageController.text,
          description: _descriptionController.text,
          link: _linkController.text,
        ),
      ),
    );
  }
}
