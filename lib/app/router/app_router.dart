import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/signin_page.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/pages/panel_page.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/contact_us_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/home_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/manifest_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/team_member_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/collaborate_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/post_detailed_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/posts_page.dart';
import 'package:observatorio_geo_hist/app/router/page_not_found.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    errorBuilder: (_, __) => const PageNotFound(),
    redirect: (BuildContext context, GoRouterState state) async {
      bool isLogged = FirebaseAuth.instance.currentUser != null;
      bool isPanel = state.fullPath == '/admin/painel';

      if (isPanel && !isLogged) return '/admin';

      return null;
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/membro/:id',
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'];

          final invalidRoute = id == null;
          if (invalidRoute) return const PageNotFound();

          return TeamMemberPage(memberId: id);
        },
      ),
      GoRoute(
        path: '/posts/:area/:category',
        builder: (BuildContext context, GoRouterState state) {
          final area = state.pathParameters['area'];
          final categoryKey = state.pathParameters['category'];

          final invalidRoute = area == null || categoryKey == null;
          if (invalidRoute) return const PageNotFound();

          return PostsPage(
            area: PostsAreas.fromKey(area),
            categoryKey: categoryKey,
          );
        },
      ),
      GoRoute(
        path: '/posts/:area/:category/:id',
        builder: (BuildContext context, GoRouterState state) {
          final area = state.pathParameters['area'];
          final categoryKey = state.pathParameters['category'];
          final id = state.pathParameters['id'];

          final invalidRoute = id == null || area == null || categoryKey == null;
          if (invalidRoute) return const PageNotFound();

          return PostDetailedPage(
            area: PostsAreas.fromKey(area),
            categoryKey: categoryKey,
            postId: id,
          );
        },
      ),
      GoRoute(
        path: '/contato',
        builder: (BuildContext context, GoRouterState state) {
          return const ContactUsPage();
        },
      ),
      GoRoute(
        path: '/colaborar',
        builder: (BuildContext context, GoRouterState state) {
          return const CollaboratePage();
        },
      ),
      GoRoute(
        path: '/manifest',
        builder: (BuildContext context, GoRouterState state) {
          return const ManifestPage();
        },
      ),
      GoRoute(
        path: '/admin',
        builder: (BuildContext context, GoRouterState state) {
          return const SigninPage();
        },
      ),
      GoRoute(
        path: '/admin/painel',
        redirect: (context, state) => '/admin/painel/usuarios',
      ),
      GoRoute(
        path: '/admin/painel/:tab',
        builder: (BuildContext context, GoRouterState state) {
          final tab = SidebarItem.fromString(state.pathParameters['tab']);

          final invalidRoute = tab == null;
          if (invalidRoute) return const PageNotFound();

          return PanelPage(tab: tab);
        },
      ),
    ],
  );
}
