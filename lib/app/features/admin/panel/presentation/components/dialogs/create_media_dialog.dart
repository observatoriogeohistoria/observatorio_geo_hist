import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_field_frame.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_drop_area.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_image_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_sheet.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

Future<void> showCreateMediaDialog(
  BuildContext context, {
  required Future<String?> Function(MediaModel media) onSave,
}) {
  return showPanelSheet(context, builder: (_) => CreateMediaDialog(onSave: onSave));
}

class CreateMediaDialog extends StatefulWidget {
  const CreateMediaDialog({required this.onSave, super.key});

  final Future<String?> Function(MediaModel media) onSave;

  @override
  State<CreateMediaDialog> createState() => _CreateMediaDialogState();
}

class _CreateMediaDialogState extends State<CreateMediaDialog> {
  final _nameController = TextEditingController();
  final _pickFocus = FocusNode();
  final _nameFocus = FocusNode();

  Uint8List? _selectedFile;

  @override
  void dispose() {
    _nameController.dispose();
    _pickFocus.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'webm'],
    );
    final picked = result?.files.first;
    final bytes = picked?.bytes;
    if (picked == null || bytes == null) return;

    setState(() {
      _selectedFile = bytes;
      _nameController.text = picked.name;
    });
  }

  Future<String?> _save() {
    final name = _nameController.text;

    return widget.onSave(
      MediaModel(
        name: name.split('.').first,
        extension: name.split('.').last,
        bytes: _selectedFile!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final hasStorage = AppEnvironment.current.hasStorage;
    final selected = _selectedFile;
    const pickText = 'Escolher imagem';

    return PanelSheet(
      title: 'Enviar imagem',
      onSave: _save,
      canSave: hasStorage && selected != null,
      fields: const [],
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormFieldFrame(
            label: 'Imagem',
            child: PanelDropArea(
              icon: hasStorage ? Icons.file_upload_outlined : Icons.image_outlined,
              title: hasStorage ? pickText : 'Sem imagem',
              semanticLabel: 'Imagem: ${hasStorage ? pickText : 'Sem imagem'}',
              previewBuilder: selected == null
                  ? null
                  : (placeholder) => LayoutBuilder(
                        builder: (context, constraints) => Image.memory(
                          selected,
                          fit: BoxFit.cover,
                          cacheWidth:
                              (constraints.maxWidth * MediaQuery.devicePixelRatioOf(context))
                                  .ceil(),
                          excludeFromSemantics: true,
                          errorBuilder: (_, __, ___) => placeholder,
                        ),
                      ),
              actionLabel: selected == null ? null : pickText,
              onTap: hasStorage ? _pick : null,
              focusNode: _pickFocus,
              autofocus: true,
            ),
          ),
          if (!hasStorage) ...[
            SizedBox(height: components.formFieldLabelGap),
            Text(
              panelStorageDisabledMessage,
              style: AppTheme.typography.of(context).formHint.copyWith(
                    color: colors.inkSecondary,
                  ),
            ),
          ],
          SizedBox(height: components.formFieldGap),
          FormTextField(
            label: 'Nome do arquivo',
            controller: _nameController,
            focusNode: _nameFocus,
            readOnly: true,
            hintText: hasStorage ? 'Escolha a imagem acima' : null,
          ),
        ],
      ),
    );
  }
}
