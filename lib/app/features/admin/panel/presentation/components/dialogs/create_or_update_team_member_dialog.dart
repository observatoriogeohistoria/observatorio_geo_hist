import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_image_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_sheet.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

Future<void> showCreateOrUpdateTeamMemberDialog(
  BuildContext context, {
  required Future<String?> Function(TeamMemberModel member) onSave,
  TeamMemberModel? member,
}) {
  return showPanelSheet(
    context,
    builder: (_) => CreateOrUpdateTeamMemberDialog(onSave: onSave, member: member),
  );
}

class CreateOrUpdateTeamMemberDialog extends StatefulWidget {
  const CreateOrUpdateTeamMemberDialog({required this.onSave, this.member, super.key});

  final Future<String?> Function(TeamMemberModel member) onSave;
  final TeamMemberModel? member;

  @override
  State<CreateOrUpdateTeamMemberDialog> createState() => _CreateOrUpdateTeamMemberDialogState();
}

class _CreateOrUpdateTeamMemberDialogState extends State<CreateOrUpdateTeamMemberDialog> {
  late final _nameController = TextEditingController(text: widget.member?.name);
  late final _roleController = TextEditingController(text: widget.member?.role);
  late final _lattesUrlController = TextEditingController(text: widget.member?.lattesUrl);
  late final _descriptionController = TextEditingController(text: widget.member?.description);
  late final _imageUrlController = TextEditingController(text: widget.member?.image?.url);
  final _image = ValueNotifier<FileModel?>(null);

  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _roleKey = GlobalKey<FormFieldState<String>>();
  final _lattesKey = GlobalKey<FormFieldState<String>>();
  final _imageKey = GlobalKey<FormFieldState<FileModel>>();
  final _imageUrlKey = GlobalKey<FormFieldState<String>>();

  final _nameFocus = FocusNode();
  final _roleFocus = FocusNode();
  final _lattesFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  bool get _isUpdate => widget.member != null;

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _roleController,
      _lattesUrlController,
      _descriptionController,
      _imageUrlController,
    ]) {
      controller.dispose();
    }
    for (final node in [
      _nameFocus,
      _roleFocus,
      _lattesFocus,
      _descriptionFocus,
      _imageFocus,
      _imageUrlFocus,
    ]) {
      node.dispose();
    }
    _image.dispose();
    super.dispose();
  }

  Future<String?> _save() {
    final image = _image.value;
    final imageUrl = _imageUrlController.text;

    return widget.onSave(
      TeamMemberModel(
        id: widget.member?.id,
        name: _nameController.text,
        role: _roleController.text,
        lattesUrl: _lattesUrlController.text,
        description: _descriptionController.text,
        image: imageUrl.isNotEmpty || image != null
            ? FileModel(url: imageUrl, bytes: image?.bytes, name: image?.name)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final gap = SizedBox(height: components.formFieldGap);

    return PanelSheet(
      title: _isUpdate ? 'Editar membro' : 'Novo membro',
      onSave: _save,
      fields: [
        PanelSheetField(_nameKey, _nameFocus),
        PanelSheetField(_roleKey, _roleFocus),
        PanelSheetField(_lattesKey, _lattesFocus),
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
              controller: _nameController,
              focusNode: _nameFocus,
              formFieldKey: _nameKey,
              validator: PanelValidators.required,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: submit,
            ),
            gap,
            FormTextField(
              label: 'Função',
              controller: _roleController,
              focusNode: _roleFocus,
              formFieldKey: _roleKey,
              validator: PanelValidators.required,
              textInputAction: TextInputAction.done,
              onSubmitted: submit,
            ),
            gap,
            FormTextField(
              label: 'Currículo Lattes',
              isOptional: true,
              controller: _lattesUrlController,
              focusNode: _lattesFocus,
              formFieldKey: _lattesKey,
              validator: PanelValidators.urlOrEmpty,
              hintText: 'https://lattes.cnpq.br/…',
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: submit,
            ),
            gap,
            FormTextField(
              label: 'Descrição',
              isOptional: true,
              controller: _descriptionController,
              focusNode: _descriptionFocus,
              multiline: true,
              minLines: components.panelDescriptionMinLines,
              maxLines: components.panelDescriptionMaxLines,
              helperText: 'Com descrição, a pessoa ganha página própria no site.',
            ),
            gap,
            PanelImageField(
              label: 'Foto',
              pickText: 'Escolher foto',
              isOptional: true,
              square: true,
              urlController: _imageUrlController,
              file: _image,
              formFieldKey: _imageKey,
              urlFieldKey: _imageUrlKey,
              focusNode: _imageFocus,
              urlFocusNode: _imageUrlFocus,
            ),
          ],
        );
      },
    );
  }
}
