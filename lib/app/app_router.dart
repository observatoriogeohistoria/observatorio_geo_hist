import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/models/category_model.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/home_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/team_member_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/posts_page.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/team-member/:name',
        builder: (BuildContext context, GoRouterState state) {
          TeamMemberModel member = state.extra as TeamMemberModel;
          return TeamMemberPage(member: member);
        },
      ),
      GoRoute(
        path: '/posts/:area/:category',
        builder: (BuildContext context, GoRouterState state) {
          CategoryModel category = state.extra as CategoryModel;
          return PostsPage(category: category);
        },
      ),
    ],
  );
}
