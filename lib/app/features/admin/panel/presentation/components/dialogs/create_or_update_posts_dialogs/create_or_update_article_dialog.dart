import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/quill/editor_quill.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/article_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/formatters/mont_year_input_formatter.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateArticleDialog(
  BuildContext context, {
  required void Function(PostModel post) onCreateOrUpdate,
  required PostModel post,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateArticleDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      post: post,
    ),
  );
}

class CreateOrUpdateArticleDialog extends StatefulWidget {
  const CreateOrUpdateArticleDialog({
    required this.onCreateOrUpdate,
    required this.post,
    super.key,
  });

  final void Function(PostModel post) onCreateOrUpdate;
  final PostModel post;

  @override
  State<CreateOrUpdateArticleDialog> createState() => _CreateOrUpdateArticleDialogState();
}

class _CreateOrUpdateArticleDialogState extends State<CreateOrUpdateArticleDialog> {
  final _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();

  final StreamController<Completer<String>> _contentController = StreamController();
  final StreamController<Completer<String>> _observationController = StreamController();

  late final ArticleModel? _initialBody = widget.post.body as ArticleModel?;

  late final String? _initialContent = _initialBody?.content;
  late final String? _initialObservation = _initialBody?.observation;

  late final _titleController = TextEditingController(text: _initialBody?.title);
  late final _subtitleController = TextEditingController(text: _initialBody?.subtitle);
  late final _imageUrlController = TextEditingController(text: _initialBody?.image);
  late final _dateController = TextEditingController(text: _initialBody?.date);
  late final _imageCaptionController = TextEditingController(text: _initialBody?.imageCaption);

  late final List<TextEditingController> _authorsControllers =
      _initialBody?.authors.map((author) => TextEditingController(text: author)).toList() ??
          [TextEditingController()];

  bool get _isUpdate => widget.post.id != null;

  Future<String> _getContent() async {
    final complete = Completer<String>();
    _contentController.add(complete);

    return await complete.future;
  }

  Future<String> _getObservation() {
    final complete = Completer<String>();
    _observationController.add(complete);

    return complete.future;
  }

  @override
  void dispose() {
    _contentController.close();
    _observationController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      width: MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: AppScrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTitle.medium(
                    text: _isUpdate ? 'Atualizar post' : 'Criar post',
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
                    controller: _subtitleController,
                    labelText: 'Subtítulo',
                    validator: Validators.isNotEmpty,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                  AppTextField(
                    controller: _imageUrlController,
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
                    controller: _dateController,
                    labelText: 'Data',
                    hintText: 'MM/yyyy',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                      MonthYearInputFormatter(),
                    ],
                    validator: Validators.isValidMonthAndYear,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                  _buildLabel('Autores'),
                  for (var i = 0; i < _authorsControllers.length; i++)
                    Column(
                      children: [
                        AppTextField(
                          controller: _authorsControllers[i],
                          validator: Validators.isNotEmpty,
                        ),
                        SizedBox(
                          height: AppTheme.dimensions.space.mini.verticalSpacing,
                        ),
                      ],
                    ),
                  SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () =>
                            setState(() => _authorsControllers.add(TextEditingController())),
                        icon: Icon(Icons.add, color: AppTheme.colors.orange),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_authorsControllers.length == 1) return;
                          setState(() => _authorsControllers.removeLast());
                        },
                        icon: Icon(Icons.remove, color: AppTheme.colors.orange),
                      ),
                    ],
                  ),
                  SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                  _buildLabel('Conteúdo'),
                  EditorQuill(
                    saveController: _contentController,
                    initialContent: _initialContent,
                    height: MediaQuery.of(context).size.height * 0.7,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                  _buildLabel('Observação'),
                  EditorQuill(
                    saveController: _observationController,
                    initialContent: _initialObservation,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
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
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Column(
      children: [
        AppLabel.medium(
          text: text,
          color: AppTheme.colors.darkGray,
        ),
        SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
      ],
    );
  }

  Future<void> _onCreateOrUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    String content = await _getContent();
    String observation = await _getObservation();

    widget.onCreateOrUpdate(
      widget.post.copyWith(
        id: widget.post.id,
        type: PostType.article,
        createdAt: widget.post.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: widget.post.isPublished,
        isHighlighted: widget.post.isHighlighted,
        body: ArticleModel(
          title: _titleController.text,
          image: _imageUrlController.text,
          subtitle: _subtitleController.text,
          authors: _authorsControllers.map((controller) => controller.text).toList(),
          date: _dateController.text,
          imageCaption: _imageCaptionController.text,
          content: content,
          observation: observation,
        ),
      ),
    );
  }
}
