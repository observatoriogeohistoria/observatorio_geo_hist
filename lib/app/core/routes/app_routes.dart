import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Endereços do site, sempre em português (inclusive os do painel).
abstract class AppRoutes {
  static const root = '/';
  static const library = '/biblioteca';
  static const ourHistory = '/nossa-historia';
  static const contact = '/contato';
  static const manifesto = '/manifesto';
  static const publications = '/publicacoes';

  static String category(String areaKey, String categoryKey) => '$publications/$areaKey/$categoryKey';

  static String post(String areaKey, String categoryKey, String postId) =>
      '${category(areaKey, categoryKey)}/$postId';

  static String currentPath(BuildContext context) {
    return GoRouterState.of(context).uri.toString();
  }

  static bool isCurrentRoute(BuildContext context, String route) => currentPath(context) == route;
}
