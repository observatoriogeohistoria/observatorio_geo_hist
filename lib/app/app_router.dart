import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/contact_us_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/home_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/team_member_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/collaborate_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/post_detailed_page.dart';
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
        path: '/team-member/:id',
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'];

          if (id == null) {
            throw Exception('Invalid route');
          }

          return TeamMemberPage(memberId: id);
        },
      ),
      GoRoute(
        path: '/posts/:area/:category',
        builder: (BuildContext context, GoRouterState state) {
          final area = state.pathParameters['area'];
          final categoryKey = state.pathParameters['category'];

          if (area == null || categoryKey == null) {
            throw Exception('Invalid route');
          }

          return PostsPage(
            area: area,
            categoryKey: categoryKey,
          );
        },
      ),
      GoRoute(
        path: '/contact-us',
        builder: (BuildContext context, GoRouterState state) {
          return const ContactUsPage();
        },
      ),
      GoRoute(
        path: '/collaborate',
        builder: (BuildContext context, GoRouterState state) {
          return const CollaboratePage();
        },
      ),
      GoRoute(
        path: '/posts/:area/:category/:id',
        builder: (BuildContext context, GoRouterState state) {
          final area = state.pathParameters['area'];
          final categoryKey = state.pathParameters['category'];
          final id = state.pathParameters['id'];

          if (id == null || area == null || categoryKey == null) {
            throw Exception('Invalid route');
          }

          return PostDetailedPage(
            area: area,
            categoryKey: categoryKey,
            postId: id,
          );
        },
      ),
    ],
  );
}
