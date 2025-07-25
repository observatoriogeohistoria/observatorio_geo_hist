import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/categories_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/posts_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PostFormDialog extends StatefulWidget {
  const PostFormDialog({
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
  State<PostFormDialog> createState() => _PostFormDialogState();
}

class _PostFormDialogState extends State<PostFormDialog> {
  late final PostsStore postsStore = PanelSetup.getIt<PostsStore>();
  late final CategoriesStore categoriesStore = PanelSetup.getIt<CategoriesStore>();

  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        bool isLoading =
            postsStore.state is CrudLoadingState || categoriesStore.state is CrudLoadingState;

        return RightAlignedDialog(
          width: widget.isFullScreen ? MediaQuery.of(context).size.width : null,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Expanded(
                  // height: MediaQuery.of(context).size.height -
                  //     AppTheme.dimensions.space.gigantic.verticalSpacing -
                  //     AppTheme.dimensions.space.large.verticalSpacing,
                  child: AppScrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: widget.child,
                    ),
                  ),
                ),
                SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isLoading) ...[
                        SecondaryButton.medium(
                          text: 'Cancelar',
                          onPressed: () => GoRouter.of(context).pop(),
                          isDisabled: postsStore.state is CrudLoadingState,
                        ),
                        SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                      ],
                      PrimaryButton.medium(
                        text: isLoading ? 'Aguarde...' : (widget.isUpdate ? 'Atualizar' : 'Criar'),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          widget.onSubmit();
                        },
                        isDisabled: isLoading,
                      ),
                    ],
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
