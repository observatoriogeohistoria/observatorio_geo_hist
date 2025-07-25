import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/page_error_content.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/loading_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/models/states/crud_states.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/document/library_document_content.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/library/library_navbar.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/library_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryDocumentDetailedPage extends StatefulWidget {
  const LibraryDocumentDetailedPage({
    required this.slug,
    super.key,
  });

  final String slug;

  @override
  State<LibraryDocumentDetailedPage> createState() => _LibraryDocumentDetailedPageState();
}

class _LibraryDocumentDetailedPageState extends State<LibraryDocumentDetailedPage> {
  late final _store = LibrarySetup.getIt<LibraryStore>();

  @override
  void initState() {
    super.initState();
    _store.fetchDocumentBySlug(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: LibraryNavbar()),
          Observer(
            builder: (_) {
              final state = _store.fetchState;

              if (state is CrudLoadingState) {
                return const LoadingContent(isSliver: true);
              }

              if (state is CrudErrorState) {
                return const PageErrorContent(isSliver: true);
              }

              final document = _store.selectedDocument.value;
              if (document == null) {
                return const PageErrorContent(isSliver: true);
              }

              return SliverToBoxAdapter(child: LibraryDocumentContent(document: document));
            },
          ),
          const SliverFillRemaining(hasScrollBody: false, child: SizedBox.shrink()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
