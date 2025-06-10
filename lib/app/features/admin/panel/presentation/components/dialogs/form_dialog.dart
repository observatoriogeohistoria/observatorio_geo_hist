import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/posts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class FormDialog extends StatefulWidget {
  const FormDialog({
    required this.onSubmit,
    required this.child,
    required this.isUpdate,
    this.isFullScreen = true,
    super.key,
  });

  final void Function() onSubmit;
  final Widget child;

  final bool isUpdate;
  final bool isFullScreen;

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  late final PostsStore postsStore = PanelSetup.getIt<PostsStore>();
  late final CategoriesStore categoriesStore = PanelSetup.getIt<CategoriesStore>();

  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return RightAlignedDialog(
          width: widget.isFullScreen ? MediaQuery.of(context).size.width : null,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      AppTheme.dimensions.space.gigantic.verticalSpacing -
                      AppTheme.dimensions.space.large.verticalSpacing,
                  child: AppScrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: widget.child,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: AppTheme.dimensions.space.large),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                        SecondaryButton.medium(
                          text: 'Cancelar',
                          onPressed: () => GoRouter.of(context).pop(),
                          isDisabled: postsStore.state is CrudLoadingState,
                        ),
                        SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                        PrimaryButton.medium(
                          text: widget.isUpdate ? 'Atualizar' : 'Criar',
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                            widget.onSubmit();
                          },
                          isDisabled: postsStore.state is CrudLoadingState ||
                              categoriesStore.state is CrudLoadingState,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
