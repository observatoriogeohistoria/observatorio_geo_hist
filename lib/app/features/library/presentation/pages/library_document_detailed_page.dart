import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_error_box.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/document/library_document_header.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/document/library_document_pdf_viewer.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/document/library_document_skeleton.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/library_document_store.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/states/library_document_states.dart';
import 'package:observatorio_geo_hist/app/router/page_not_found.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryDocumentDetailedPage extends StatefulWidget {
  const LibraryDocumentDetailedPage({
    required this.area,
    required this.documentKey,
    super.key,
  });

  final DocumentArea area;

  /// Slug do documento ou, quando o slug não serve como endereço, o identificador.
  final String documentKey;

  @override
  State<LibraryDocumentDetailedPage> createState() => _LibraryDocumentDetailedPageState();
}

class _LibraryDocumentDetailedPageState extends State<LibraryDocumentDetailedPage> {
  late final _store = LibrarySetup.getIt<LibraryDocumentStore>();

  @override
  void initState() {
    super.initState();
    _store.fetch(widget.documentKey);
  }

  @override
  void didUpdateWidget(covariant LibraryDocumentDetailedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.documentKey != widget.documentKey) _store.fetch(widget.documentKey);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final state = _store.state;

        final breakpoint = ScreenUtils.breakpointOf(context);
        final components = AppTheme.dimensions.components;

        // Links antigos podem trazer a área errada: as migalhas seguem a do documento.
        final area = state is LibraryDocumentSuccessState ? state.document.area : widget.area;

        final Widget content;
        final double bottom;
        switch (state) {
          case LibraryDocumentInitialState() || LibraryDocumentLoadingState():
            content = const LibraryDocumentSkeleton();
            bottom = components.libraryViewerMarginBottom(breakpoint);
          case LibraryDocumentErrorState():
            content = Padding(
              padding: EdgeInsets.only(top: components.libraryDetailBadgeTop),
              child: StateErrorBox(onRetry: _store.retry),
            );
            bottom = components.readingPaddingBottom(breakpoint);
          case LibraryDocumentSuccessState(:final document):
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LibraryDocumentHeader(document: document),
                SizedBox(height: components.libraryViewerMarginTop),
                LibraryDocumentPdfViewer(url: document.documentUrl),
              ],
            );
            bottom = components.libraryViewerMarginBottom(breakpoint);
          case LibraryDocumentNotFoundState():
            return const PageNotFound();
        }

        // A chave por endereço volta ao topo ao abrir outro documento.
        return ReadingPageScaffold(
          key: ValueKey(widget.documentKey),
          body: _DocumentFrame(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Breadcrumbs(
                    items: [
                      const BreadcrumbItem('Início', route: AppRoutes.root),
                      const BreadcrumbItem('Biblioteca', route: AppRoutes.library),
                      BreadcrumbItem(area.value, route: AppRoutes.libraryArea(area.routeKey)),
                      const BreadcrumbItem('Documento'),
                    ],
                  ),
                  content,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DocumentFrame extends StatelessWidget {
  const _DocumentFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final margin = ScreenUtils.contentMargin(ScreenUtils.breakpointOf(context));

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(top: components.pageHeadPaddingTop),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: components.libraryDetailMaxWidth - 2 * margin),
            child: child,
          ),
        ),
      ),
    );
  }
}
