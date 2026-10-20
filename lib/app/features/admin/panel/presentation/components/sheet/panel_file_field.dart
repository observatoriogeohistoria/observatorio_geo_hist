import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_field_frame.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_drop_area.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_image_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_sheet.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Como a imagem: enviar o arquivo ([file]) ou colar o endereço.
class PanelFileField extends StatefulWidget {
  const PanelFileField({
    required this.label,
    required this.urlController,
    required this.file,
    required this.formFieldKey,
    required this.urlFieldKey,
    required this.focusNode,
    required this.urlFocusNode,
    super.key,
  });

  final String label;
  final TextEditingController urlController;
  final ValueNotifier<FileModel?> file;
  final GlobalKey<FormFieldState<FileModel>> formFieldKey;
  final GlobalKey<FormFieldState<String>> urlFieldKey;
  final FocusNode focusNode;
  final FocusNode urlFocusNode;

  @override
  State<PanelFileField> createState() => _PanelFileFieldState();
}

class _PanelFileFieldState extends State<PanelFileField> {
  String? _pickedName;

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
    if (mounted) setState(() {});
  }

  Future<void> _pick(FormFieldState<FileModel> field) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'],
    );
    final picked = result?.files.first;
    if (picked == null || picked.bytes == null) return;

    final parts = picked.name.split('.');
    widget.file.value = FileModel(
      bytes: picked.bytes,
      name: parts.first,
      extension: parts.length > 1 ? parts.last : null,
    );
    _pickedName = picked.name;
    widget.urlController.clear();
    field.didChange(widget.file.value);
  }

  String? get _currentName {
    if (widget.file.value != null) return _pickedName;
    final url = widget.urlController.text;
    if (url.isEmpty) return null;
    // No Storage o nome vem codificado no fim do caminho ("biblioteca%2Fnome.pdf").
    final last = Uri.tryParse(url)?.pathSegments.lastOrNull ?? url;
    return last.split('/').last;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final hasStorage = AppEnvironment.current.hasStorage;
    final locked = PanelSheet.isSavingOf(context);
    final name = _currentName;

    return FormField<FileModel>(
      key: widget.formFieldKey,
      validator: (_) {
        final hasFile = widget.file.value != null || widget.urlController.text.isNotEmpty;
        return hasFile ? null : 'Escolha o PDF ou cole o endereço.';
      },
      builder: (field) {
        final error = field.errorText;
        final title = hasStorage ? 'Escolher PDF' : 'Sem arquivo';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            FormFieldFrame(
              label: widget.label,
              errorText: error,
              child: PanelDropArea(
                icon: hasStorage ? Icons.file_upload_outlined : Icons.description_outlined,
                title: title,
                subtitle: name,
                semanticLabel: '${widget.label}: $title',
                semanticHint: FormFieldFrame.semanticHint(error: error, helper: name),
                onTap: hasStorage && !locked ? () => _pick(field) : null,
                focusNode: widget.focusNode,
                hasError: error != null,
              ),
            ),
            if (!hasStorage) ...[
              SizedBox(height: components.formFieldLabelGap),
              Text(
                panelStorageDisabledMessage,
                style: styles.formHint.copyWith(color: colors.inkSecondary),
              ),
            ],
            SizedBox(height: components.panelDropFieldGap),
            FormTextField(
              label: 'Endereço do arquivo',
              controller: widget.urlController,
              focusNode: widget.urlFocusNode,
              formFieldKey: widget.urlFieldKey,
              validator: PanelValidators.urlOrEmpty,
              hintText: 'https://',
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              readOnly: locked,
              onSubmitted: (_) => PanelSheet.submitOf(context),
            ),
          ],
        );
      },
    );
  }
}
