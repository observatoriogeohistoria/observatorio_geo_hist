// Generates the pages search engines read. Runs after `flutter build web`:
//
//   fvm flutter test tool/seo/generate_seo.dart --dart-define=APP_ENV=prod
//
// It is a test only because the app models import Flutter; it sits outside `*_test.dart` so
// `flutter test tool/seo` doesn't run it.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:observatorio_geo_hist/app/core/utils/environment/app_environment.dart';
import 'package:observatorio_geo_hist/firebase_options_dev.dart' as dev_options;
import 'package:observatorio_geo_hist/firebase_options_prod.dart' as prod_options;

import 'catalog_reader.dart';
import 'firestore_rest.dart';
import 'seo_exception.dart';
import 'site_pages.dart';
import 'site_writer.dart';

const String _prodOrigin = 'https://observatoriogeohistoria.net.br';
const String _devOrigin = 'https://dev.observatoriogeohistoria.net.br';

void main() {
  test('generates the pages for search engines', () async {
    // flutter test blocks real network by default.
    HttpOverrides.global = null;

    final isProd = AppEnvironment.current.isProd;
    // `currentPlatform` is not defined for the VM the test runs on.
    final options =
        isProd ? prod_options.DefaultFirebaseOptions.web : dev_options.DefaultFirebaseOptions.web;

    final buildDir = Directory('build/web');
    final index = File('${buildDir.path}/index.html');
    if (!index.existsSync()) {
      throw const SeoException('Não achei build/web/index.html: rode `flutter build web` antes.');
    }

    final catalog = await CatalogReader(
      FirestoreRest(projectId: options.projectId, apiKey: options.apiKey),
    ).read();
    final result = writeSite(
      pages: buildSitePages(catalog),
      template: index.readAsStringSync(),
      outDir: buildDir,
      origin: isProd ? _prodOrigin : _devOrigin,
      noIndex: !isProd,
      withSitemap: isProd,
    );

    // ignore: avoid_print
    print([
      'Páginas para o Google (${options.projectId}): ${result.pages} no total',
      for (final kind in PageKind.values) '  ${kind.name}: ${result.pagesByKind[kind] ?? 0}',
      result.sitemap ? '  com sitemap.xml' : '  sem sitemap.xml',
      for (final warning in catalog.warnings) '  aviso: $warning',
    ].join('\n'));
  }, timeout: const Timeout(Duration(minutes: 5)));
}
