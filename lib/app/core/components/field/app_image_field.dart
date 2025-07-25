import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppImageField extends StatefulWidget {
  const AppImageField({
    required this.imageUrlController,
    required this.imageController,
    super.key,
  });

  final TextEditingController imageUrlController;
  final StreamController<Completer<FileModel?>> imageController;

  @override
  State<AppImageField> createState() => _AppImageFieldState();
}

class _AppImageFieldState extends State<AppImageField> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Uint8List? _uploadedImageBytes;
  String? _uploadedImageName;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    widget.imageController.stream.listen((event) {
      if (_uploadedImageBytes != null && _uploadedImageName != null) {
        event.complete(FileModel(
          bytes: _uploadedImageBytes,
          name: _uploadedImageName,
        ));
      } else {
        event.complete(null);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          labelColor: AppTheme.colors.darkGray,
          unselectedLabelColor: AppTheme.colors.gray,
          indicatorColor: AppTheme.colors.orange,
          overlayColor: WidgetStateProperty.all(AppTheme.colors.lightOrange.withValues(alpha: 0.2)),
          labelStyle: AppTheme.typography.label.big,
          controller: _tabController,
          tabs: const [
            Tab(text: 'URL'),
            Tab(text: 'Upload'),
          ],
        ),
        SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
        SizedBox(
          height: 72,
          child: TabBarView(
            controller: _tabController,
            children: [
              AppTextField(
                controller: widget.imageUrlController,
                labelText: 'URL da imagem',
                hintText: 'https://',
                validator: Validators.isValidUrl,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryButton.small(
                        text: _isLoading ? 'Carregando...' : 'Selecionar arquivo',
                        onPressed: _pickImageWeb,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
                      if (_uploadedImageBytes == null)
                        AppLabel.small(
                          text: 'Nenhuma imagem selecionada',
                          color: AppTheme.colors.gray,
                        ),
                    ],
                  ),
                  if (_uploadedImageBytes != null) ...[
                    SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
                    Image.memory(
                      _uploadedImageBytes!,
                      height: 120.verticalSpacing,
                      fit: BoxFit.cover,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageWeb() async {
    setState(() => _isLoading = true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'webm'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;

      _uploadedImageBytes = fileBytes;
      _uploadedImageName = result.files.first.name;

      widget.imageUrlController.clear();
    }

    setState(() => _isLoading = false);
  }
}
