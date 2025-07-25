import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/linear_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/transitions/transitions_builder.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
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
            GoRouter.of(context).go('/admin');
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
    final isDesktop = ScreenUtils.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: AppHeadline.big(
          text: widget.area.value,
          color: AppTheme.colors.white,
        ),
        backgroundColor: AppTheme.colors.orange,
        foregroundColor: AppTheme.colors.white,
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
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.dimensions.space.medium.horizontalSpacing,
                vertical: AppTheme.dimensions.space.medium.verticalSpacing,
              ),
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
                      child: AppTitle.big(
                        text: fetchState.failure.message,
                        color: AppTheme.colors.darkGray,
                      ),
                    );
                  }

                  final docs = _libraryStore.documentsByArea[widget.area] ?? [];
                  if (docs.isEmpty) {
                    return Center(
                      child: AppTitle.big(
                        text: 'Nenhum documento encontrado.',
                        color: AppTheme.colors.darkGray,
                      ),
                    );
                  }

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
                        SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                      ],
                      if (manageState is CrudLoadingState) ...[
                        const LinearLoading(),
                        SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                      ],
                      Expanded(
                        child: AppScrollbar(
                          controller: _scrollController,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            controller: _scrollController,
                            itemCount: docs.length,
                            separatorBuilder: (_, __) => const Divider(),
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
                        padding: EdgeInsets.only(
                          top: AppTheme.dimensions.space.medium.verticalSpacing,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isDesktop)
                              PrimaryButton.medium(
                                text: 'Filtros',
                                onPressed: () => _showMobileMenu(context),
                              ),
                            SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
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
      barrierLabel: 'Mobile Filters',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: TransitionsBuilder.slide,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          child: Filters(
            onApplyFilters: _fetchDocuments,
            onClearFilters: _fetchDocuments,
          ),
        );
      },
    );
  }
}
