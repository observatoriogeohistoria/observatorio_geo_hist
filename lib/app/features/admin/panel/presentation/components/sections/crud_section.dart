import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/linear_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/crud_store.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CrudSection<T> extends StatefulWidget {
  final String title;
  final bool canEdit;
  final CrudStore<T> store;
  final Widget Function(T item, int index) itemBuilder;
  final VoidCallback onCreatePressed;

  const CrudSection({
    required this.title,
    required this.canEdit,
    required this.store,
    required this.itemBuilder,
    required this.onCreatePressed,
    super.key,
  });

  @override
  State<CrudSection<T>> createState() => _CrudSectionState<T>();
}

class _CrudSectionState<T> extends State<CrudSection<T>> {
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();
  late final ScrollController _scrollController = ScrollController();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    widget.store.getItems();

    _reactions = [
      reaction((_) => widget.store.state, (state) {
        if (state is CrudErrorState) {
          final error = state.failure;
          Messenger.showError(context, error.message);

          if (error is Forbidden) authStore.logout();
        }

        if (state is CrudSuccessState) {
          final message = (state as dynamic).message;

          if (message.isNotEmpty) {
            GoRouter.of(context).pop();
            Messenger.showSuccess(context, message);
          }
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rightPadding = EdgeInsets.only(
      right: AppTheme.dimensions.space.medium.horizontalSpacing,
    );

    return Observer(
      builder: (_) {
        final state = widget.store.state;

        bool isRefreshing = state is CrudLoadingState && state.isRefreshing;
        bool isLoading = state is CrudLoadingState && !state.isRefreshing;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeadline.big(text: widget.title, color: AppTheme.colors.orange),
            if (widget.canEdit) ...[
              SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: rightPadding,
                  child: SecondaryButton.medium(
                    text: 'Criar',
                    onPressed: widget.onCreatePressed,
                  ),
                ),
              ),
            ],
            if (isRefreshing)
              Padding(
                padding: rightPadding,
                child: const LinearLoading(),
              ),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularLoading())
                  : AppScrollbar(
                      controller: _scrollController,
                      child: ListView.separated(
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.only(
                          bottom: AppTheme.dimensions.space.large.verticalSpacing,
                        ),
                        itemCount: widget.store.items.length,
                        separatorBuilder: (_, i) =>
                            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
                        itemBuilder: (_, i) => widget.itemBuilder(widget.store.items[i], i),
                      ),
                    ),
            )
          ],
        );
      },
    );
  }
}
