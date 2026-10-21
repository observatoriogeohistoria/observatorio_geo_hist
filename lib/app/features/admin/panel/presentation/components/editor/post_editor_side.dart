import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/chips/labels.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/editor/post_editor_form.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_check_group.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_image_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_select_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_switch_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_filter_select.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostEditorSideKeys {
  final areas = GlobalKey<FormFieldState<List<PostsAreas>>>();
  final category = GlobalKey<FormFieldState<CategoryModel>>();
  final image = GlobalKey<FormFieldState<FileModel>>();
  final imageUrl = GlobalKey<FormFieldState<String>>();
  final caption = GlobalKey<FormFieldState<String>>();

  final highlightFocus = FocusNode();
  final areasFocus = FocusNode();
  final categoryFocus = FocusNode();
  final pickFocus = FocusNode();
  final urlFocus = FocusNode();
  final captionFocus = FocusNode();

  FocusNode get imageFocus => panelPickFocusTarget(pickFocus, urlFocus);

  List<PostEditorField> fields({required bool hasCaption}) => [
        PostEditorField(areas, 'Área', areasFocus),
        PostEditorField(category, 'Categoria', categoryFocus),
        PostEditorField(image, 'Imagem', imageFocus),
        PostEditorField(imageUrl, 'Endereço da imagem', urlFocus),
        if (hasCaption) PostEditorField(caption, 'Legenda', captionFocus),
      ];

  void dispose() {
    for (final node in [
      highlightFocus,
      areasFocus,
      categoryFocus,
      pickFocus,
      urlFocus,
      captionFocus,
    ]) {
      node.dispose();
    }
  }
}

class PostEditorSide extends StatelessWidget {
  const PostEditorSide({
    required this.keys,
    required this.isPublished,
    required this.isHighlighted,
    required this.onHighlightChanged,
    required this.areas,
    required this.onAreasChanged,
    required this.categories,
    required this.category,
    required this.onCategoryChanged,
    required this.image,
    required this.hasCaption,
    required this.onRemoveImage,
    this.extra,
    super.key,
  });

  final PostEditorSideKeys keys;
  final bool isPublished;
  final bool isHighlighted;
  final ValueChanged<bool> onHighlightChanged;
  final List<PostsAreas> areas;
  final ValueChanged<List<PostsAreas>> onAreasChanged;
  final List<CategoryModel> categories;
  final CategoryModel? category;
  final ValueChanged<CategoryModel?> onCategoryChanged;
  final PostEditorImage image;
  final bool hasCaption;
  final VoidCallback onRemoveImage;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final gap = SizedBox(height: components.editorCardsGap);
    final extra = this.extra;

    final options = categories
        .where((option) => option.areas.any(areas.contains))
        .map((option) => LibraryFilterOption<CategoryModel?>(option, option.title))
        .toList();
    final emptyLabel = areas.isNotEmpty && options.isEmpty
        ? 'Nenhuma categoria nesta área'
        : 'Escolha a categoria';
    final selected = options.where((option) => option.value?.key == category?.key).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        PostEditorCard(
          eyebrow: 'Situação',
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: components.editorCardEyebrowGap),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'No site',
                        style: styles.meta.copyWith(color: colors.inkSecondary),
                      ),
                    ),
                    isPublished
                        ? const StatusBadge('Publicado', tone: StatusTone.success)
                        : const StatusBadge('Não publicado', tone: StatusTone.neutral),
                  ],
                ),
              ),
            ),
            PanelSwitchField(
              title: 'Destaque na Home',
              hint: 'Entra entre os destaques da página inicial.',
              value: isHighlighted,
              onChanged: onHighlightChanged,
              focusNode: keys.highlightFocus,
            ),
          ],
        ),
        gap,
        PostEditorCard(
          eyebrow: 'Onde aparece',
          children: [
            PanelCheckGroup<PostsAreas>(
              label: 'Área',
              options: const [
                PanelCheckOption(PostsAreas.history, 'História'),
                PanelCheckOption(PostsAreas.geography, 'Geografia'),
              ],
              selected: areas,
              onChanged: onAreasChanged,
              validator: PanelValidators.choice(PanelValidators.areaMessage),
              formFieldKey: keys.areas,
              focusNode: keys.areasFocus,
            ),
            PanelSelectField<CategoryModel>(
              label: 'Categoria',
              options: [LibraryFilterOption(null, emptyLabel), ...options],
              value: selected?.value,
              onSelected: onCategoryChanged,
              validator: PanelValidators.choice(PanelValidators.categoryMessage),
              formFieldKey: keys.category,
              focusNode: keys.categoryFocus,
            ),
          ],
        ),
        gap,
        PostEditorCard(
          eyebrow: 'Imagem',
          children: [
            PanelImageField(
              label: 'Imagem',
              pickText: 'Escolher imagem',
              pickHint: 'JPG ou PNG, de preferência na horizontal',
              replaceText: 'Trocar imagem',
              requiredMessage: PanelValidators.imageMessage,
              urlController: image.url,
              file: image.file,
              formFieldKey: keys.image,
              urlFieldKey: keys.imageUrl,
              focusNode: keys.pickFocus,
              urlFocusNode: keys.urlFocus,
              onRemove: onRemoveImage,
            ),
            if (hasCaption)
              FormTextField(
                label: 'Legenda',
                controller: image.caption,
                focusNode: keys.captionFocus,
                formFieldKey: keys.caption,
                validator: PanelValidators.required,
              ),
          ],
        ),
        if (extra != null) ...[gap, extra],
      ],
    );
  }
}
