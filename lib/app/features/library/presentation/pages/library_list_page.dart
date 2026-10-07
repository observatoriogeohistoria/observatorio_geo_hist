import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_error_inline.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/linear_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/transitions/transitions_builder.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/empty_list_message.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/create_or_update_document_dialog.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/document/library_document_card.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/filters.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/filter_documents_store.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/library_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryListPage extends StatefulWidget {
  const LibraryListPage({super.key, required this.area});

  final DocumentArea area;

  @override
  State<LibraryListPage> createState() => _LibraryListPageState();
}

class _LibraryListPageState extends State<LibraryListPage> {
  late final _libraryStore = LibrarySetup.getIt<LibraryStore>();
  late final _filterStore = LibrarySetup.getIt<FilterDocumentsStore>();
  late final _authStore = AdminSetup.getIt<AuthStore>();

  final _scrollController = ScrollController();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    _authStore.currentUser();
    _fetchDocuments();

    _reactions = [
      reaction(
        (_) => _authStore.user,
        (UserModel? user) {
          if (user == null) {
            GoRouter.of(context).go(AppRoutes.admin);
          }
        },
      ),
      reaction(
        (_) => _libraryStore.manageState,
        (state) {
          if (state is CrudErrorState) {
            final error = state.failure;
            Messenger.showError(context, error.message);

            if (error is Forbidden) _authStore.logout();
          }

          if (state is CrudSuccessState) {
            if (state.message.isNotEmpty) {
              GoRouter.of(context).pop();
              Messenger.showSuccess(context, state.message);
            }
          }
        },
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _filterStore.reset();

    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final isDesktop = ScreenUtils.isDesktop(context);
    final contentPadding = components.panelContentPadding(ScreenUtils.breakpointOf(context));

    return Scaffold(
      backgroundColor: colors.page,
      appBar: AppBar(
        leading: AppIconButton(
          tooltip: 'Voltar',
          icon: Icons.arrow_back,
          color: colors.white,
          focusRingColor: colors.white,
          size: components.panelTopBarIcon,
          onPressed: () {
            final router = GoRouter.of(context);
            final isAdminRoute = GoRouterState.of(context).uri.path.startsWith(AppRoutes.admin);
            router.canPop()
                ? router.pop()
                : router.go(isAdminRoute
                    ? AppRoutes.panelTab(AppRoutes.librarySegment)
                    : AppRoutes.library);
          },
        ),
        title: Text(
          widget.area.value,
          style: AppTheme.typography.of(context).h3.copyWith(color: colors.white),
        ),
        backgroundColor: colors.accent,
        foregroundColor: colors.white,
        elevation: 0,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            Filters(
              onApplyFilters: _fetchDocuments,
              onClearFilters: _fetchDocuments,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Observer(
                builder: (_) {
                  final fetchState = _libraryStore.fetchState;
                  final manageState = _libraryStore.manageState;

                  final canEdit = _authStore.user?.permissions.canEditLibrarySection == true;

                  if (fetchState is CrudLoadingState) {
                    if (!fetchState.isRefreshing) return const Center(child: CircularLoading());
                  }

                  if (fetchState is CrudErrorState) {
                    return Center(
                      child: StateErrorInline(
                        message: fetchState.failure.message,
                        onRetry: _fetchDocuments,
                      ),
                    );
                  }

                  final docs = _libraryStore.documentsByArea[widget.area] ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (canEdit) ...[
                        Align(
                          alignment: Alignment.centerRight,
                          child: PrimaryButton.medium(
                            text: 'Criar documento',
                            onPressed: () => showCreateOrUpdateLibraryDocumentDialog(
                              context,
                              area: widget.area,
                              onCreateOrUpdate: (document, file) =>
                                  _libraryStore.createOrUpdateDocument(document, file),
                            ),
                          ),
                        ),
                        SizedBox(height: spacing.s24),
                      ],
                      if (manageState is CrudLoadingState) ...[
                        const LinearLoading(),
                        SizedBox(height: spacing.s8),
                      ],
                      Expanded(
                        child: docs.isEmpty
                            ? const EmptyListMessage(text: 'Nenhum documento encontrado.')
                            : AppScrollbar(
                                controller: _scrollController,
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  controller: _scrollController,
                                  itemCount: docs.length,
                                  separatorBuilder: (_, __) => const AppDivider(),
                                  itemBuilder: (context, index) {
                                    final doc = docs[index];

                                    return LibraryDocumentCard(
                                      document: doc,
                                      onEdit: () => showCreateOrUpdateLibraryDocumentDialog(
                                        context,
                                        area: widget.area,
                                        onCreateOrUpdate: (document, file) =>
                                            _libraryStore.createOrUpdateDocument(document, file),
                                        document: doc,
                                      ),
                                      onDelete: () => _libraryStore.deleteDocument(doc),
                                      canEdit: canEdit,
                                      canDelete: canEdit,
                                    );
                                  },
                                ),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: spacing.s16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isDesktop)
                              PrimaryButton.medium(
                                text: 'Filtros',
                                onPressed: () => _showMobileMenu(context),
                              ),
                            SizedBox(width: spacing.s16),
                            if (_libraryStore.hasMore[widget.area] == true)
                              SecondaryButton.medium(
                                text: fetchState is CrudLoadingState
                                    ? 'Carregando...'
                                    : 'Carregar mais',
                                onPressed: _fetchDocuments,
                                isDisabled: fetchState is CrudLoadingState,
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _fetchDocuments() {
    _libraryStore.fetchDocumentsByArea(
      widget.area,
      type: _filterStore.type,
      categories: _filterStore.categories,
      title: _filterStore.title,
      author: _filterStore.author,
      institution: _filterStore.institution,
      year: _filterStore.year,
    );
  }

  void _showMobileMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar filtros',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: TransitionsBuilder.slide,
      pageBuilder: (context, animation, secondaryAnimation) {
        final width = MediaQuery.sizeOf(context).width;
        final maxWidth = AppTheme.dimensions.components.mobileMenuMaxWidth;

        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: width < maxWidth ? width : maxWidth,
            height: double.infinity,
            child: Material(
              child: Filters(
                onApplyFilters: _fetchDocuments,
                onClearFilters: _fetchDocuments,
              ),
            ),
          ),
        );
      },
    );
  }
}
