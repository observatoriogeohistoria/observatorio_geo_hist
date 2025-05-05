import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/artist_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateArtistDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateArtistDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateArtistDialog extends StatefulWidget {
  const CreateOrUpdateArtistDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateArtistDialog> createState() => _CreateOrUpdateArtistDialogState();
}

class _CreateOrUpdateArtistDialogState extends State<CreateOrUpdateArtistDialog> {
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  late final ArtistModel? _initialBody = widget.post.body as ArtistModel?;

  late final _nameController = TextEditingController(text: _initialBody?.title);
  late final _imageController = TextEditingController(text: _initialBody?.image);
  late final _descriptionController = TextEditingController(text: _initialBody?.description);
  late final _linkController = TextEditingController(text: _initialBody?.link);

  bool get _isUpdate => widget.post.id != null;

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AppScrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTitle.medium(
                  text: _isUpdate ? 'Atualizar Artista' : 'Criar Artista',
                  color: AppTheme.colors.orange,
                ),
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                AppTextField(
                  controller: _nameController,
                  labelText: 'Nome do Artista',
                  validator: Validators.isNotEmpty,
                ),
                SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                AppTextField(
                  controller: _imageController,
                  labelText: 'URL da Imagem',
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
                AppTextField(
                  controller: _linkController,
                  labelText: 'Link',
                  hintText: 'https://',
                  validator: Validators.isValidUrl,
                ),
                SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SecondaryButton.medium(
                      text: 'Cancelar',
                      onPressed: () => GoRouter.of(context).pop(),
                    ),
                    SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                    PrimaryButton.medium(
                      text: _isUpdate ? 'Atualizar' : 'Criar',
                      onPressed: _onCreateOrUpdate,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onCreateOrUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.artist,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: ArtistModel(
          title: _nameController.text,
          image: _imageController.text,
          description: _descriptionController.text,
          link: _linkController.text,
        ),
      ),
    );
  }
}
