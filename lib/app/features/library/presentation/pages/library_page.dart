import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/page_header.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/library_setup.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/components/index/library_area_tile.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/stores/library_index_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final _store = LibrarySetup.getIt<LibraryIndexStore>();

  @override
  void initState() {
    super.initState();
    _store.load();
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final mobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;

    return ReadingPageScaffold(
      header: const PageHeader(
        breadcrumbs: [
          BreadcrumbItem('Início', route: AppRoutes.root),
          BreadcrumbItem('Biblioteca'),
        ],
        title: 'Biblioteca',
        lead: 'Produções acadêmicas sobre História e Geografia de várias instituições e '
            'pesquisadores, reunidas em um só lugar. Teses e dissertações para consultar e citar.',
      ),
      body: PageContent(
        child: Padding(
          padding: EdgeInsets.only(
            top: components.areaTilesPaddingTop,
            bottom: components.areaTilesPaddingBottom,
          ),
          child: Observer(
            builder: (context) {
              final loading = _store.status == LibraryIndexStatus.loading;
              final tiles = [
                for (final area in DocumentArea.values)
                  LibraryAreaTile(area: area, counts: _store.counts?[area], loading: loading),
              ];

              if (mobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (index, tile) in tiles.indexed) ...[
                      if (index > 0) SizedBox(height: components.areaTileGridGap),
                      tile,
                    ],
                  ],
                );
              }

              // Os dois cartões ficam com a altura do maior.
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (index, tile) in tiles.indexed) ...[
                      if (index > 0) SizedBox(width: components.areaTileGridGap),
                      Expanded(child: tile),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
