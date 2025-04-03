import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const root = '/';
  static const geoensine = '/geoensine';
  static const geoensineProjeto = '/geoensine/projeto';

  static String currentPath(BuildContext context) {
    return GoRouterState.of(context).uri.toString();
  }

  static bool isCurrentRoute(BuildContext context, String route) => currentPath(context) == route;
}
