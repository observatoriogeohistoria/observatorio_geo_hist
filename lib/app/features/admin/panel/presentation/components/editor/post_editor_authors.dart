import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_text_button.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostEditorAuthor {
  const PostEditorAuthor(this.controller, this.focusNode, this.fieldKey);

  final TextEditingController controller;
  final FocusNode focusNode;
  final GlobalKey<FormFieldState<String>> fieldKey;
}

class PostEditorAuthors extends StatelessWidget {
  const PostEditorAuthors({
    required this.authors,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<PostEditorAuthor> authors;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final canRemove = authors.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, author) in authors.indexed) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FormTextField(
                  label: 'Autor ${index + 1}',
                  controller: author.controller,
                  focusNode: author.focusNode,
                  formFieldKey: author.fieldKey,
                  validator: PanelValidators.required,
                  hintText: 'Nome de quem escreveu',
                  textInputAction: TextInputAction.next,
                ),
              ),
              if (canRemove)
                Padding(
                  padding: EdgeInsets.only(top: components.editorAuthorRemoveTop),
                  child: AppIconButton(
                    icon: Icons.close,
                    color: colors.inkSecondary,
                    size: components.panelActionIcon,
                    label: 'Remover autor ${index + 1}',
                    tooltip: 'Remover este autor',
                    onPressed: () => onRemove(index),
                  ),
                ),
            ],
          ),
          SizedBox(height: components.editorAuthorsGap),
        ],
        AppTextButton.small(text: 'Adicionar autor', leadingIcon: Icons.add, onPressed: onAdd),
      ],
    );
  }
}
