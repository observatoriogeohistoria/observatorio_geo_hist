import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/switch_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_academic_production_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_article_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_artist_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_book_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_document_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_event_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_film_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_magazine_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_music_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_podcast_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_posts_dialogs/create_or_update_search_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdatePostDialog(
  BuildContext context, {
  required List<CategoryModel> categories,
  required void Function(PostModel post) onCreateOrUpdate,
  required PostType postType,
  PostModel? post,
}) {
  showDialog(
    context: context,
    builder: (_) => CreateOrUpdatePostDialog(
      categories: categories,
      onCreateOrUpdate: onCreateOrUpdate,
      postType: postType,
      post: post,
    ),
  );
}

class CreateOrUpdatePostDialog extends StatefulWidget {
  const CreateOrUpdatePostDialog({
    required this.categories,
    required this.onCreateOrUpdate,
    required this.postType,
    this.post,
    super.key,
  });

  final List<CategoryModel> categories;
  final void Function(PostModel post) onCreateOrUpdate;
  final PostType postType;
  final PostModel? post;

  @override
  State<CreateOrUpdatePostDialog> createState() => _CreateOrUpdatePostDialogState();
}

class _CreateOrUpdatePostDialogState extends State<CreateOrUpdatePostDialog> {
  bool get isMobile => DeviceUtils.isMobile(context);

  List<PostType> types = PostType.values.toList();

  late bool isHistory = widget.post?.areas.contains(PostsAreas.history) ?? false;
  late bool isGeography = widget.post?.areas.contains(PostsAreas.geography) ?? false;

  late CategoryModel? _selectedCategory = widget.post?.category;

  List<CategoryModel> get _categoryOptions {
    List<CategoryModel> categories = [];

    for (var category in widget.categories) {
      if (isHistory && category.areas.contains(PostsAreas.history)) {
        categories.add(category);
      } else if (isGeography && category.areas.contains(PostsAreas.geography)) {
        categories.add(category);
      }
    }

    return categories;
  }

  @override
  void initState() {
    super.initState();
    types.sort((a, b) => a.portuguese.compareTo(b.portuguese));
  }

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTitle.big(
                    text: 'Área',
                    color: AppTheme.colors.orange,
                  ),
                  SwitchButton(
                    title: 'História',
                    onChanged: (value) => setState(() => isHistory = value),
                    initialValue: isHistory,
                  ),
                  SwitchButton(
                    title: 'Geografia',
                    onChanged: (value) => setState(() => isGeography = value),
                    initialValue: isGeography,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                  AppTitle.big(
                    text: 'Categoria',
                    color: AppTheme.colors.orange,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                  AppDropdownField<CategoryModel>(
                    hintText: 'Selecione',
                    items: _categoryOptions,
                    itemToString: (category) => category.title,
                    value: _selectedCategory,
                    onChanged: (category) {
                      if (category == null) return;

                      CategoryModel? selectedCategory =
                          widget.categories.firstWhereOrNull((value) => value.title == category);

                      setState(() => _selectedCategory = selectedCategory);
                    },
                    validator: Validators.isNotEmpty,
                  ),
                ],
              ),
              SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton.medium(
                    text: 'Cancelar',
                    onPressed: () => GoRouter.of(context).pop(),
                  ),
                  SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                  PrimaryButton.medium(
                    text: 'Avançar',
                    onPressed: _onTap,
                    isDisabled: _selectedCategory == null,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _onTap() {
    GoRouter.of(context).pop();

    PostModel post = PostModel(
      id: widget.post?.id,
      categoryId: _selectedCategory!.key,
      category: _selectedCategory!,
      areas: [
        if (isHistory) PostsAreas.history,
        if (isGeography) PostsAreas.geography,
      ],
      type: widget.postType,
      body: widget.post?.body,
      createdAt: widget.post?.createdAt,
      updatedAt: widget.post?.updatedAt,
      isPublished: widget.post?.isPublished ?? false,
      isHighlighted: widget.post?.isHighlighted ?? false,
    );

    switch (widget.postType) {
      case PostType.article:
        showCreateOrUpdateArticleDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.event:
        showCreateOrUpdateEventDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.academicProduction:
        showCreateOrUpdateAcademicProductionDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.search:
        showCreateOrUpdateSearchDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.document:
        showCreateOrUpdateDocumentDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.book:
        showCreateOrUpdateBookDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.magazine:
        showCreateOrUpdateMagazineDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.film:
        showCreateOrUpdateFilmDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.podcast:
        showCreateOrUpdatePodcastDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.music:
        showCreateOrUpdateMusicDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;

      case PostType.artist:
        showCreateOrUpdateArtistDialog(context,
            onCreateOrUpdate: widget.onCreateOrUpdate, post: post);
        break;
    }
  }
}
