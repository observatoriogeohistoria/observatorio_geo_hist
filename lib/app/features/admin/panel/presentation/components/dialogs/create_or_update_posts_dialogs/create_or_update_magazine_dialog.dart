import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/magazine_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateMagazineDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateMagazineDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateMagazineDialog extends StatefulWidget {
  const CreateOrUpdateMagazineDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateMagazineDialog> createState() => _CreateOrUpdateMagazineDialogState();
}

class _CreateOrUpdateMagazineDialogState extends State<CreateOrUpdateMagazineDialog> {
  late final MagazineModel? _initialBody = widget.post.body as MagazineModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageController = TextEditingController(text: _initialBody?.image);
  late final _teaserController = TextEditingController(text: _initialBody?.teaser);
  late final _descriptionController = TextEditingController(text: _initialBody?.description);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  late MagazineCategory? _selectedCategory = _initialBody?.category;

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
            text: _isUpdate ? 'Atualizar revista' : 'Criar revista',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppDropdownField<MagazineCategory>(
            hintText: 'Categoria',
            items: MagazineCategory.values,
            itemToString: (value) => value.portuguese,
            value: _selectedCategory,
            onChanged: (category) {
              if (category == null) return;

              MagazineCategory? selected = MagazineCategory.fromPortuguese(category);
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
          AppTextField(
            controller: _imageController,
            labelText: 'Capa/Imagem (URL)',
            hintText: 'https://',
            validator: Validators.isValidUrl,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _teaserController,
            labelText: 'Chamada',
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _descriptionController,
            labelText: 'Descrição',
            minLines: 6,
            maxLines: 6,
            validator: Validators.isNotEmpty,
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

  void _onCreateOrUpdate() {
    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.magazine,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: MagazineModel(
          category: _selectedCategory!,
          title: _titleController.text,
          image: _imageController.text,
          teaser: _teaserController.text.isEmpty ? null : _teaserController.text,
          description: _descriptionController.text,
          link: _linkController.text,
        ),
      ),
    );
  }
}
