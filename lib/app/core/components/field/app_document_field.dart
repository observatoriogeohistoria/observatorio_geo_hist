import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AppDocumentField extends StatefulWidget {
  const AppDocumentField({
    required this.documentUrlController,
    required this.documentController,
    super.key,
  });

  final TextEditingController documentUrlController;
  final StreamController<Completer<FileModel?>> documentController;

  @override
  State<AppDocumentField> createState() => _AppDocumentFieldState();
}

class _AppDocumentFieldState extends State<AppDocumentField> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Uint8List? _uploadedDocumentBytes;
  String? _uploadedDocumentName;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    widget.documentController.stream.listen((event) {
      if (_uploadedDocumentBytes != null && _uploadedDocumentName != null) {
        final split = _uploadedDocumentName!.split('.');
        final name = split.isNotEmpty ? split.first : _uploadedDocumentName;
        final extension = split.length > 1 ? split.last : null;

        event.complete(FileModel(
          bytes: _uploadedDocumentBytes,
          name: name,
          extension: extension,
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
                controller: widget.documentUrlController,
                labelText: 'URL do arquivo',
                hintText: 'https://',
                validator: Validators.isValidUrl,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryButton.small(
                        text: _isLoading ? 'Carregando...' : 'Selecionar arquivo',
                        onPressed: _pickDocumentWeb,
                      ),
                      SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
                      if (_uploadedDocumentBytes == null)
                        AppLabel.small(
                          text: 'Nenhum arquivo selecionado',
                          color: AppTheme.colors.gray,
                        ),
                    ],
                  ),
                  if (_uploadedDocumentName != null) ...[
                    SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
                    AppTitle.small(
                      text: _uploadedDocumentName!,
                      color: AppTheme.colors.darkGray,
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

  Future<void> _pickDocumentWeb() async {
    setState(() => _isLoading = true);

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;

      _uploadedDocumentBytes = fileBytes;
      _uploadedDocumentName = result.files.first.name;

      widget.documentUrlController.clear();
    }

    setState(() => _isLoading = false);
  }
}
