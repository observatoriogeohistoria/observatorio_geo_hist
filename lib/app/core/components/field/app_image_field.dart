import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/image_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
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
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final secondary = styles.small.copyWith(color: colors.inkSecondary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          labelColor: colors.ink,
          unselectedLabelColor: colors.inkSecondary,
          indicatorColor: colors.accent,
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused)) return colors.accentSoftBorder;
            if (states.contains(WidgetState.hovered)) return colors.accentSoft;
            return null;
          }),
          labelStyle: styles.formLabel,
          unselectedLabelStyle: styles.formLabel,
          controller: _tabController,
          tabs: const [
            Tab(text: 'URL'),
            Tab(text: 'Upload'),
          ],
        ),
        SizedBox(height: AppTheme.dimensions.spacing.s16),
        SizedBox(
          height: components.panelTabViewHeight,
          child: TabBarView(
            controller: _tabController,
            children: [
              AppTextField(
                controller: widget.imageUrlController,
                labelText: 'URL da imagem',
                hintText: 'https://',
                validator: Validators.isValidUrl,
              ),
              if (!AppEnvironment.current.hasStorage)
                Text(
                  'Upload desabilitado no ambiente de testes (sem Storage configurado). '
                  'Use a aba URL.',
                  style: styles.small.copyWith(color: colors.accentStrong),
                )
              else
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryButton.small(
                          text: _isLoading ? 'Carregando...' : 'Selecionar arquivo',
                          onPressed: _pickImageWeb,
                        ),
                        SizedBox(height: AppTheme.dimensions.spacing.s4),
                        if (_uploadedImageBytes == null)
                          Text('Nenhuma imagem selecionada', style: secondary),
                      ],
                    ),
                    if (_uploadedImageBytes != null) ...[
                      SizedBox(width: AppTheme.dimensions.spacing.s8),
                      SizedBox(
                        height: components.panelImagePreviewHeight,
                        child: AspectRatio(
                          aspectRatio: components.panelImagePreviewAspect,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8),
                            child: Image.memory(
                              _uploadedImageBytes!,
                              fit: BoxFit.cover,
                              semanticLabel: _uploadedImageName,
                              errorBuilder: (_, __, ___) => const ImageErrorContent(compact: true),
                            ),
                          ),
                        ),
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
