import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/book_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateBookDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateBookDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateBookDialog extends StatefulWidget {
  const CreateOrUpdateBookDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateBookDialog> createState() => _CreateOrUpdateBookDialogState();
}

class _CreateOrUpdateBookDialogState extends State<CreateOrUpdateBookDialog> {
  late final BookModel? _initialBody = widget.post.body as BookModel?;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _imageController = TextEditingController(text: _initialBody?.image);
  late final _authorController = TextEditingController(text: _initialBody?.author);
  late final _publisherController = TextEditingController(text: _initialBody?.publisher);
  late final _yearController = TextEditingController(text: _initialBody?.year.toString());
  late final _synopsisController = TextEditingController(text: _initialBody?.synopsis);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  late BookCategory? _selectedCategory = _initialBody?.category;

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
            text: _isUpdate ? 'Atualizar livro' : 'Criar livro',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppDropdownField<BookCategory>(
            hintText: 'Categoria',
            items: BookCategory.values,
            itemToString: (value) => value.portuguese,
            value: _selectedCategory,
            onChanged: (value) {
              if (value == null) return;

              BookCategory? selected = BookCategory.fromPortuguese(value);
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
            labelText: 'Imagem',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _authorController,
            labelText: 'Autor(a)',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _yearController,
            labelText: 'Ano de publicação',
            keyboardType: TextInputType.number,
            validator: Validators.isValidYear,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _publisherController,
            labelText: 'Editora',
            validator: Validators.isNotEmpty,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _synopsisController,
            labelText: 'Chamada/Sinopse',
            minLines: 4,
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
        type: PostType.book,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: BookModel(
          category: _selectedCategory!,
          title: _titleController.text,
          image: _imageController.text,
          author: _authorController.text,
          year: int.parse(_yearController.text),
          publisher: _publisherController.text,
          synopsis: _synopsisController.text,
          link: _linkController.text,
        ),
      ),
    );
  }
}
