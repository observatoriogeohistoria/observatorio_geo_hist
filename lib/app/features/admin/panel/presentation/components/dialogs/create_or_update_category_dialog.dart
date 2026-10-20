import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/generator/id_generator.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_check_group.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_image_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_sheet.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_switch_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

Future<void> showCreateOrUpdateCategoryDialog(
  BuildContext context, {
  required Future<String?> Function(CategoryModel category) onSave,
  CategoryModel? category,
}) {
  return showPanelSheet(
    context,
    builder: (_) => CreateOrUpdateCategoryDialog(onSave: onSave, category: category),
  );
}

class CreateOrUpdateCategoryDialog extends StatefulWidget {
  const CreateOrUpdateCategoryDialog({required this.onSave, this.category, super.key});

  final Future<String?> Function(CategoryModel category) onSave;
  final CategoryModel? category;

  @override
  State<CreateOrUpdateCategoryDialog> createState() => _CreateOrUpdateCategoryDialogState();
}

class _CreateOrUpdateCategoryDialogState extends State<CreateOrUpdateCategoryDialog> {
  late final _titleController = TextEditingController(text: widget.category?.title);
  late final _keyController =
      TextEditingController(text: widget.category?.key ?? IdGenerator.generate());
  late final _descriptionController = TextEditingController(text: widget.category?.description);
  late final _imageUrlController = TextEditingController(text: widget.category?.backgroundImg.url);
  final _image = ValueNotifier<FileModel?>(null);

  final _titleKey = GlobalKey<FormFieldState<String>>();
  final _descriptionKey = GlobalKey<FormFieldState<String>>();
  final _imageKey = GlobalKey<FormFieldState<FileModel>>();
  final _imageUrlKey = GlobalKey<FormFieldState<String>>();

  final _titleFocus = FocusNode();
  final _keyFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  late List<PostsAreas> _areas = [...?widget.category?.areas];
  late bool _isCollaborate = widget.category?.hasCollaborateOption ?? false;

  bool get _isUpdate => widget.category != null;

  // Nas duas áreas, ou em nenhuma, a dica mostra o link da Geografia.
  PostsAreas get _linkArea => _areas.length == 1 ? _areas.first : PostsAreas.geography;

  @override
  void dispose() {
    for (final controller in [
      _titleController,
      _keyController,
      _descriptionController,
      _imageUrlController,
    ]) {
      controller.dispose();
    }
    for (final node in [_titleFocus, _keyFocus, _descriptionFocus, _imageFocus, _imageUrlFocus]) {
      node.dispose();
    }
    _image.dispose();
    super.dispose();
  }

  Future<String?> _save() {
    final image = _image.value;

    return widget.onSave(
      CategoryModel(
        key: _keyController.text,
        title: _titleController.text,
        description: _descriptionController.text,
        backgroundImg: FileModel(
          url: _imageUrlController.text,
          bytes: image?.bytes,
          name: image?.name,
        ),
        areas: [
          if (_areas.contains(PostsAreas.history)) PostsAreas.history,
          if (_areas.contains(PostsAreas.geography)) PostsAreas.geography,
        ],
        hasCollaborateOption: _isCollaborate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppTheme.dimensions.components.formFieldGap);

    return PanelSheet(
      title: _isUpdate ? 'Editar categoria' : 'Nova categoria',
      onSave: _save,
      fields: [
        PanelSheetField(_titleKey, _titleFocus),
        PanelSheetField(_descriptionKey, _descriptionFocus),
        PanelSheetField(_imageKey, panelPickFocusTarget(_imageFocus, _imageUrlFocus)),
        PanelSheetField(_imageUrlKey, _imageUrlFocus),
      ],
      builder: (context) {
        void submit(String _) => PanelSheet.submitOf(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormTextField(
              label: 'Nome',
              controller: _titleController,
              focusNode: _titleFocus,
              formFieldKey: _titleKey,
              validator: PanelValidators.required,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: submit,
            ),
            gap,
            FormTextField(
              label: 'Endereço',
              controller: _keyController,
              focusNode: _keyFocus,
              readOnly: true,
              helperText: 'Vira o fim do link: '
                  '${AppRoutes.category(_linkArea.key, _keyController.text)}',
            ),
            gap,
            FormTextField(
              label: 'Descrição',
              controller: _descriptionController,
              focusNode: _descriptionFocus,
              formFieldKey: _descriptionKey,
              validator: PanelValidators.required,
              multiline: true,
              minLines: AppTheme.dimensions.components.panelDescriptionMinLines,
              maxLines: AppTheme.dimensions.components.panelDescriptionMaxLines,
              helperText: 'Aparece no topo da página da categoria.',
            ),
            gap,
            PanelImageField(
              label: 'Imagem de fundo',
              pickText: 'Escolher imagem',
              urlController: _imageUrlController,
              file: _image,
              formFieldKey: _imageKey,
              urlFieldKey: _imageUrlKey,
              focusNode: _imageFocus,
              urlFocusNode: _imageUrlFocus,
            ),
            gap,
            PanelCheckGroup<PostsAreas>(
              label: 'Áreas',
              options: const [
                PanelCheckOption(PostsAreas.history, 'História'),
                PanelCheckOption(PostsAreas.geography, 'Geografia'),
              ],
              selected: _areas,
              onChanged: (areas) => setState(() => _areas = areas),
            ),
            gap,
            PanelSwitchField(
              title: 'Aceita colaboração',
              hint: 'Mostra o botão “Colabore” na página da categoria.',
              value: _isCollaborate,
              onChanged: (value) => setState(() => _isCollaborate = value),
            ),
          ],
        );
      },
    );
  }
}
