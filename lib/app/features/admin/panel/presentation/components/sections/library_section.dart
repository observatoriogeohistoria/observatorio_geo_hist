import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/models/image_model.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/confirm_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_footer.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_list_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/list/panel_section_scroll.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/panel_section_header.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/library_filter_bar.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/library_row.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sections/panel_action.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/panel_counts_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/create_or_update_document_dialog.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/filter_documents_store.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/library_store.dart';

class LibrarySection extends StatefulWidget {
  const LibrarySection({required this.area, super.key});

  final DocumentArea area;

  @override
  State<LibrarySection> createState() => _LibrarySectionState();
}

class _LibrarySectionState extends State<LibrarySection> {
  late final _authStore = PanelSetup.getIt<AuthStore>();
  late final _countsStore = PanelSetup.getIt<PanelCountsStore>();
  late final _libraryStore = LibrarySetup.getIt<LibraryStore>();
  late final _filterStore = LibrarySetup.getIt<FilterDocumentsStore>();

  final _pending = PendingPanelAction();
  final _noAction = PendingPanelAction();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _institutionController = TextEditingController();
  List<ReactionDisposer> _reactions = [];

  bool _showMore = false;
  bool _loadingFirstPage = false;
  bool _firstPageFailed = false;
  bool _savePending = false;

  DocumentArea get _area => widget.area;

  bool get _hasFilter {
    final store = _filterStore;
    return store.type != null ||
        store.categories.isNotEmpty ||
        store.title != null ||
        store.author != null ||
        store.institution != null ||
        store.year != null;
  }

  @override
  void initState() {
    super.initState();

    _reactions = [
      reaction((_) => _libraryStore.fetchState, _handleFetchState),
      reaction((_) => _libraryStore.manageState, _handleManageState),
    ];

    _fetch(reset: true);
  }

  @override
  void didUpdateWidget(covariant LibrarySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.area != widget.area) _fetch(reset: true);
  }

  // Sair da Biblioteca zera os filtros; trocar de área, não.
  @override
  void dispose() {
    _filterStore.reset();
    _titleController.dispose();
    _authorController.dispose();
    _institutionController.dispose();
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  void _handleFetchState(CrudState state) {
    if (state is CrudLoadingState) _loadingFirstPage = !state.isRefreshing;

    final isFirstPageError = state is CrudErrorState && _loadingFirstPage;
    if (isFirstPageError) setState(() => _firstPageFailed = true);

    showPanelActionResult(
      context,
      state: state,
      pending: _noAction,
      messages: const {},
      onForbidden: _authStore.logout,
      isFirstPageLoad: isFirstPageError,
    );
  }

  void _handleManageState(CrudState state) {
    showPanelActionResult(
      context,
      state: state,
      pending: _pending,
      messages: const {
        PanelAction.saveInDialog: 'Documento salvo.',
        PanelAction.delete: 'Documento excluído.',
      },
      onForbidden: _authStore.logout,
    );

    if (state is CrudLoadingState) return;
    final reload = _savePending && state is CrudSuccessState;
    _savePending = false;
    if (reload) _fetch(reset: true);
  }

  void _fetch({bool reset = false}) {
    if (_firstPageFailed) setState(() => _firstPageFailed = false);
    final store = _filterStore;
    _libraryStore.fetchDocumentsByArea(
      _area,
      type: store.type,
      categories: store.categories,
      title: store.title,
      author: store.author,
      institution: store.institution,
      year: store.year,
      reset: reset,
    );
  }

  void _clearFilters() {
    _filterStore.reset();
    _titleController.clear();
    _authorController.clear();
    _institutionController.clear();
    _fetch(reset: true);
  }

  void _save(LibraryDocumentModel document, FileModel? file) {
    _pending.start(PanelAction.saveInDialog);
    _savePending = true;
    _libraryStore.createOrUpdateDocument(document, file);
  }

  Future<void> _delete(LibraryDocumentModel document) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Excluir este documento?',
      message: '“${document.title}” sai do site e do painel. Não dá para desfazer.',
    );
    if (!confirmed) return;
    _pending.start(PanelAction.delete);
    _libraryStore.deleteDocument(document);
  }

  void _openForm([LibraryDocumentModel? document]) {
    showCreateOrUpdateLibraryDocumentDialog(
      context,
      area: _area,
      onCreateOrUpdate: _save,
      document: document,
    );
  }

  Widget _body(bool canEdit) {
    final state = _libraryStore.fetchState;
    final documents = _libraryStore.documentsByArea[_area] ?? [];

    if (_firstPageFailed && state is CrudErrorState) {
      return SliverToBoxAdapter(
        child: PanelErrorState(
          message: state.failure.message,
          onRetry: () => _fetch(reset: true),
        ),
      );
    }

    if (state is CrudInitialState || (state is CrudLoadingState && !state.isRefreshing)) {
      return const PanelListSkeleton();
    }

    if (documents.isEmpty) {
      return SliverToBoxAdapter(
        child: _hasFilter
            ? PanelNoResultsState(onClearFilters: _clearFilters)
            : PanelEmptyState(
                info: PanelEmptyInfo(
                  icon: Icons.menu_book_outlined,
                  title: 'Nenhum documento em ${_area.value} ainda',
                  message: 'Cadastre teses e dissertações para que apareçam na biblioteca do site.',
                  actionLabel: canEdit ? 'Novo documento' : null,
                  onAction: _openForm,
                ),
              ),
      );
    }

    final isLoadingMore = state is CrudLoadingState;
    final clear = _hasFilter ? _clearFilters : null;
    final loadMore = _libraryStore.hasMore[_area] == true ? _fetch : null;

    return PanelList(
      itemCount: documents.length,
      footer: PanelListFooter.isNeeded(onClearFilters: clear, onLoadMore: loadMore)
          ? PanelListFooter(
              onClearFilters: clear,
              onLoadMore: loadMore,
              isLoadingMore: isLoadingMore,
            )
          : null,
      itemBuilder: (context, index) {
        final document = documents[index];
        return LibraryRow(
          key: ValueKey(document.id),
          document: document,
          canEdit: canEdit,
          onEdit: () => _openForm(document),
          onDelete: () => _delete(document),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final canEdit = _authStore.user?.permissions.canEditLibrarySection ?? false;
        final count = _countsStore.counts.libraryByArea[_area];

        return PanelSectionScroll(
          header: PanelSectionHeader(
            eyebrow: SidebarItem.library.eyebrow,
            title: SidebarItem.library.title,
            summary: count == null
                ? null
                : '${count == 1 ? '1 documento' : '$count documentos'} em ${_area.value}',
            actionLabel: canEdit ? 'Novo documento' : null,
            onAction: _openForm,
          ),
          filterBar: LibraryFilterBar(
            area: _area,
            onAreaChanged: (area) => GoRouter.of(context).go(
              AppRoutes.panelLibraryArea(area.routeKey),
            ),
            store: _filterStore,
            titleController: _titleController,
            authorController: _authorController,
            institutionController: _institutionController,
            showMore: _showMore,
            onShowMoreChanged: (value) => setState(() => _showMore = value),
            onChanged: () => _fetch(reset: true),
          ),
          body: _body(canEdit),
        );
      },
    );
  }
}
