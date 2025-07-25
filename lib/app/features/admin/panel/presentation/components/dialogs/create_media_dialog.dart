import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/post_form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateMediaDialog(
  BuildContext context, {
  required void Function(MediaModel media) onCreate,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
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
  final _nameController = TextEditingController();

  Uint8List? _selectedFile;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PostFormDialog(
      onSubmit: _onCreate,
      isUpdate: false,
      isFullScreen: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitle.medium(
            text: 'Criar mídia',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppTextField(
            controller: _nameController,
            labelText: 'Arquivo',
            validator: Validators.isNotEmpty,
            isDisabled: true,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
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
        ],
      ),
    );
  }

  void _onCreate() {
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
  }
}
