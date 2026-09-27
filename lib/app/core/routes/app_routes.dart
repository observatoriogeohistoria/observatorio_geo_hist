import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const root = '/';
  static const library = '/biblioteca';
  static const ourHistory = '/nossa-historia';

  static String currentPath(BuildContext context) {
    return GoRouterState.of(context).uri.toString();
  }

  static bool isCurrentRoute(BuildContext context, String route) => currentPath(context) == route;
}
