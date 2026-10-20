import 'package:file_picker/file_picker.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_field_frame.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/image/fitted_network_image.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_drop_area.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_sheet.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

const panelStorageDisabledMessage =
    'Upload desabilitado no ambiente de testes (sem Storage configurado).';

/// Sem Storage não há o que escolher: o foco de um erro na imagem vai para o endereço.
FocusNode panelPickFocusTarget(FocusNode pick, FocusNode url) =>
    AppEnvironment.current.hasStorage ? pick : url;

class PanelImageField extends StatefulWidget {
  const PanelImageField({
    required this.label,
    required this.pickText,
    required this.urlController,
    required this.file,
    required this.formFieldKey,
    required this.urlFieldKey,
    required this.focusNode,
    required this.urlFocusNode,
    this.isOptional = false,
    this.square = false,
    this.requiredMessage = 'Escolha uma imagem ou cole o endereço.',
    this.pickHint,
    this.replaceText,
    this.onRemove,
    super.key,
  });

  final String label;
  final String pickText;
  final TextEditingController urlController;
  final ValueNotifier<FileModel?> file;
  final GlobalKey<FormFieldState<FileModel>> formFieldKey;
  final GlobalKey<FormFieldState<String>> urlFieldKey;
  final FocusNode focusNode;
  final FocusNode urlFocusNode;
  final bool isOptional;
  final bool square;
  final String requiredMessage;

  final String? pickHint;

  final String? replaceText;

  /// Com ele, uma imagem escolhida mostra "Remover" e o aviso do corte nos cards.
  final VoidCallback? onRemove;

  @override
  State<PanelImageField> createState() => _PanelImageFieldState();
}

class _PanelImageFieldState extends State<PanelImageField> {
  // A etiqueta de trocar só aparece sobre uma imagem que carregou; na falha, fica o placeholder.
  bool _previewFailed = false;

  static final _url = RegExp(r'^https?://');

  @override
  void initState() {
    super.initState();
    widget.urlController.addListener(_refresh);
    widget.file.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.urlController.removeListener(_refresh);
    widget.file.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() => _previewFailed = false);
  }

  Widget _failed(Widget placeholder) {
    if (!_previewFailed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _previewFailed = true);
      });
    }
    return placeholder;
  }

  Future<void> _pick(FormFieldState<FileModel> field) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'webm'],
    );
    final picked = result?.files.first;
    if (picked == null || picked.bytes == null) return;

    widget.file.value = FileModel(bytes: picked.bytes, name: picked.name);
    widget.urlController.clear();
    field.didChange(widget.file.value);
  }

  Widget? _preview(Widget placeholder) {
    final bytes = widget.file.value?.bytes;
    if (bytes != null) {
      return LayoutBuilder(
        builder: (context, constraints) => Image.memory(
          bytes,
          fit: BoxFit.cover,
          // Uma foto de câmera tem milhares de pixels; decodificar no tamanho da área não trava.
          cacheWidth: (constraints.maxWidth * MediaQuery.devicePixelRatioOf(context)).ceil(),
          excludeFromSemantics: true,
          errorBuilder: (_, __, ___) => _failed(placeholder),
        ),
      );
    }

    final url = widget.urlController.text;
    if (!_url.hasMatch(url)) return null;
    return FittedNetworkImage(
      url,
      fit: BoxFit.cover,
      excludeFromSemantics: true,
      errorBuilder: (_, __, ___) => _failed(placeholder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final hasStorage = AppEnvironment.current.hasStorage;
    final pickedName = widget.file.value?.name;

    return FormField<FileModel>(
      key: widget.formFieldKey,
      validator: (_) {
        if (widget.isOptional) return null;
        final hasImage = widget.file.value != null || widget.urlController.text.isNotEmpty;
        return hasImage ? null : widget.requiredMessage;
      },
      builder: (field) {
        final error = field.errorText;
        final replaceText = widget.replaceText;
        final title = !hasStorage
            ? 'Sem imagem'
            : _previewFailed && replaceText != null
                ? replaceText
                : widget.pickText;
        final hasImage = widget.file.value != null || widget.urlController.text.isNotEmpty;
        final onRemove = widget.onRemove;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            FormFieldFrame(
              label: widget.label,
              isOptional: widget.isOptional,
              errorText: error,
              helperText: pickedName,
              child: Align(
                alignment: Alignment.centerLeft,
                child: PanelDropArea(
                  icon: hasStorage ? Icons.file_upload_outlined : Icons.image_outlined,
                  title: title,
                  subtitle: hasImage ? null : widget.pickHint,
                  semanticLabel:
                      '${FormFieldFrame.semanticLabel(widget.label, isOptional: widget.isOptional)}: '
                      '$title',
                  semanticHint: FormFieldFrame.semanticHint(error: error, helper: pickedName),
                  previewBuilder: _preview,
                  actionLabel: hasStorage && !_previewFailed ? widget.pickText : null,
                  onTap: hasStorage ? () => _pick(field) : null,
                  focusNode: widget.focusNode,
                  square: widget.square,
                  hasError: error != null,
                ),
              ),
            ),
            if (onRemove != null && hasImage) ...[
              SizedBox(height: components.formFieldLabelGap),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Cortada em 16:10 nos cards',
                      style: styles.formHint.copyWith(color: colors.inkSecondary),
                    ),
                  ),
                  AppTextButton.small(
                    text: 'Remover',
                    onPressed: () {
                      onRemove();
                      field.didChange(null);
                    },
                  ),
                ],
              ),
            ],
            if (!hasStorage) ...[
              SizedBox(height: components.formFieldLabelGap),
              Text(
                panelStorageDisabledMessage,
                style: styles.formHint.copyWith(color: colors.inkSecondary),
              ),
            ],
            SizedBox(height: components.panelDropFieldGap),
            FormTextField(
              label: 'Endereço da imagem',
              controller: widget.urlController,
              focusNode: widget.urlFocusNode,
              formFieldKey: widget.urlFieldKey,
              validator: PanelValidators.urlOrEmpty,
              hintText: 'https://',
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => PanelSheet.submitOf(context),
            ),
          ],
        );
      },
    );
  }
}
