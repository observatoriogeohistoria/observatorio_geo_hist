import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/page_header.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/listing/library_listing.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/library_listing_store.dart';

/// Página pública da área. O painel continua com a própria página, que tem as ações de edição.
class LibraryAreaPage extends StatefulWidget {
  const LibraryAreaPage({super.key, required this.area});

  final DocumentArea area;

  @override
  State<LibraryAreaPage> createState() => _LibraryAreaPageState();
}

class _LibraryAreaPageState extends State<LibraryAreaPage> {
  late final _store = LibrarySetup.getIt<LibraryListingStore>();

  @override
  void initState() {
    super.initState();
    _store.load(widget.area);
  }

  @override
  void didUpdateWidget(covariant LibraryAreaPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.area != widget.area) _store.load(widget.area);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.area.value;

    // A chave por área volta ao topo e recria os campos ao trocar de área.
    return ReadingPageScaffold(
      key: ValueKey(widget.area),
      header: PageHeader(
        breadcrumbs: [
          const BreadcrumbItem('Início', route: AppRoutes.root),
          const BreadcrumbItem('Biblioteca', route: AppRoutes.library),
          BreadcrumbItem(name),
        ],
        title: name,
        lead: 'Teses e dissertações sobre o ensino de $name, de várias instituições e '
            'pesquisadores.',
      ),
      body: LibraryListing(store: _store, area: widget.area),
    );
  }
}
