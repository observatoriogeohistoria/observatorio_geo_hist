import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateMediaDialog(
  BuildContext context, {
  required void Function(MediaModel media) onCreate,
}) {
  showDialog(
    context: context,
    builder: (_) => CreateMediaDialog(
      onCreate: onCreate,
    ),
  );
}

class CreateMediaDialog extends StatefulWidget {
  const CreateMediaDialog({
    required this.onCreate,
    super.key,
  });

  final void Function(MediaModel media) onCreate;

  @override
  State<CreateMediaDialog> createState() => _CreateMediaDialogState();
}

class _CreateMediaDialogState extends State<CreateMediaDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  Uint8List? _selectedFile;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTitle.medium(
              text: 'Criar mídia',
              color: AppTheme(context).colors.orange,
            ),
            SizedBox(height: AppTheme(context).dimensions.space.xlarge),
            AppTextField(
              controller: _nameController,
              labelText: 'Arquivo',
              validator: Validators.isNotEmpty,
              isDisabled: true,
            ),
            SizedBox(height: AppTheme(context).dimensions.space.medium),
            SecondaryButton.small(
              text: _isLoading ? 'Carregando...' : 'Selecionar arquivo',
              onPressed: () async {
                setState(() => _isLoading = true);

                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowMultiple: false,
                  allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'webm'],
                );

                if (result != null) {
                  Uint8List? fileBytes = result.files.first.bytes;

                  if (fileBytes != null) {
                    _selectedFile = fileBytes;
                    _nameController.text = result.files.first.name;
                  }
                }

                setState(() => _isLoading = false);
              },
              isDisabled: _isLoading,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton.medium(
                  text: 'Cancelar',
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: AppTheme(context).dimensions.space.medium),
                PrimaryButton.medium(
                  text: 'Criar',
                  onPressed: _onCreate,
                  isDisabled: _isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCreate() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedFile == null) return;

    String fileName = _nameController.text.split('.').first;
    String fileExtension = _nameController.text.split('.').last;

    widget.onCreate(
      MediaModel(
        name: fileName,
        extension: fileExtension,
        bytes: _selectedFile!,
      ),
    );

    Navigator.of(context).pop();
  }
}
