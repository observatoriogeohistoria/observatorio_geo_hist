import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const root = '/';
  static const ourHistory = '/nossa-historia';
  static const contact = '/contato';
  static const collaborate = '/colaborar';
  static const manifesto = '/manifesto';

  static const memberPattern = '/membro/:id';
  static String member(String id) => '/membro/$id';

  static const publicationsSegment = 'publicacoes';
  static const publications = '/$publicationsSegment';
  static const categoryPattern = '$publications/:area/:category';
  static const postPattern = '$categoryPattern/:id';
  static String category(String areaKey, String categoryKey) => '$publications/$areaKey/$categoryKey';
  static String post(String areaKey, String categoryKey, String postId) =>
      '${category(areaKey, categoryKey)}/$postId';

  static const librarySegment = 'biblioteca';
  static const library = '/$librarySegment';
  static const libraryAreaPattern = '$library/:area';
  static const libraryDocumentPattern = '$libraryAreaPattern/documento/:slug';
  static String libraryArea(String areaKey) => '$library/$areaKey';
  static String libraryDocument(String areaKey, String slug) => '${libraryArea(areaKey)}/documento/$slug';

  static const admin = '/admin';
  static const panel = '$admin/painel';
  static const panelTabPattern = '$panel/:tab';
  static const panelLibraryAreaPattern = '$panel/$librarySegment/:area';

  static const panelPostTypeParam = 'tipo';
  static String panelTab(String tab) => '$panel/$tab';
  static String panelPosts(String postType) => '${panelTab(publicationsSegment)}?$panelPostTypeParam=$postType';
  static String panelLibraryArea(String areaKey) => '${panelTab(librarySegment)}/$areaKey';

  static const legacyManifest = '/manifest';
  static const legacyCategoryPattern = '/posts/:area/:category';
  static const legacyPostPattern = '$legacyCategoryPattern/:id';

  static String currentPath(BuildContext context) {
    return GoRouterState.of(context).uri.toString();
  }

  static bool isCurrentRoute(BuildContext context, String route) => currentPath(context) == route;
}
