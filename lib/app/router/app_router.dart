import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_selection_area.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/signin_page.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/pages/panel_page.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/pages/post_editor_page.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/enums/sidebar_item.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/contact_us_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/home_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/manifest_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/our_history_page.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/pages/team_member_page.dart';
import 'package:observatorio_geo_hist/app/features/library/infra/models/library_document_model.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/pages/library_area_page.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/pages/library_document_detailed_page.dart';
import 'package:observatorio_geo_hist/app/features/library/presentation/pages/library_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/all_posts_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/collaborate_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/post_detailed_page.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/pages/posts_page.dart';
import 'package:observatorio_geo_hist/app/router/page_not_found.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.root,
    errorBuilder: (_, __) => _selectable(const PageNotFound()),
    redirect: (BuildContext context, GoRouterState state) async {
      bool isLogged = FirebaseAuth.instance.currentUser != null;
      bool isPanel = state.fullPath == AppRoutes.panel;

      if (isPanel && !isLogged) return AppRoutes.admin;

      return null;
    },
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) => _selectable(child),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutes.root,
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
          ),
          GoRoute(
            path: AppRoutes.memberPattern,
            builder: (BuildContext context, GoRouterState state) {
              final id = state.pathParameters['id'];

              final invalidRoute = id == null;
              if (invalidRoute) return const PageNotFound();

              return TeamMemberPage(memberId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.publications,
            builder: (BuildContext context, GoRouterState state) {
              return const AllPostsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.categoryPattern,
            builder: (BuildContext context, GoRouterState state) {
              final area = state.pathParameters['area'];
              final categoryKey = state.pathParameters['category'];

              final postsArea = area == null ? null : PostsAreas.tryFromKey(area);
              final invalidRoute = postsArea == null || categoryKey == null;
              if (invalidRoute) return const PageNotFound();

              return PostsPage(area: postsArea, categoryKey: categoryKey);
            },
          ),
          GoRoute(
            path: AppRoutes.postPattern,
            builder: (BuildContext context, GoRouterState state) {
              final area = state.pathParameters['area'];
              final categoryKey = state.pathParameters['category'];
              final id = state.pathParameters['id'];

              final postsArea = area == null ? null : PostsAreas.tryFromKey(area);
              final invalidRoute = id == null || postsArea == null || categoryKey == null;
              if (invalidRoute) return const PageNotFound();

              return PostDetailedPage(
                area: postsArea,
                categoryKey: categoryKey,
                postId: id,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.contact,
            builder: (BuildContext context, GoRouterState state) {
              return const ContactUsPage();
            },
          ),
          GoRoute(
            path: AppRoutes.collaborate,
            builder: (BuildContext context, GoRouterState state) {
              return const CollaboratePage();
            },
          ),
          GoRoute(
            path: AppRoutes.manifesto,
            builder: (BuildContext context, GoRouterState state) {
              return const ManifestPage();
            },
          ),
          GoRoute(
            path: AppRoutes.ourHistory,
            builder: (BuildContext context, GoRouterState state) {
              return const OurHistoryPage();
            },
          ),
          GoRoute(
            path: AppRoutes.library,
            builder: (BuildContext context, GoRouterState state) {
              return const LibraryPage();
            },
          ),
          GoRoute(
            path: AppRoutes.libraryAreaPattern,
            builder: (BuildContext context, GoRouterState state) {
              final area = DocumentArea.fromRouteKey(
                state.pathParameters['area'],
              );

              final invalidRoute = area == null;
              if (invalidRoute) return const PageNotFound();

              return LibraryAreaPage(area: area);
            },
          ),
          GoRoute(
            path: AppRoutes.libraryDocumentPattern,
            builder: (BuildContext context, GoRouterState state) {
              final area = DocumentArea.fromRouteKey(state.pathParameters['area']);
              final documentKey = state.pathParameters['id'];

              final invalidRoute = area == null || documentKey == null || documentKey.isEmpty;
              if (invalidRoute) return const PageNotFound();

              return LibraryDocumentDetailedPage(area: area, documentKey: documentKey);
            },
          ),
        ],
      ),
      // Old English URLs, kept so links already shared don't break.
      GoRoute(
        path: AppRoutes.legacyManifest,
        redirect: (context, state) => AppRoutes.manifesto,
      ),
      GoRoute(
        path: AppRoutes.legacyCategoryPattern,
        redirect: (context, state) => AppRoutes.category(
          state.pathParameters['area']!,
          state.pathParameters['category']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.legacyPostPattern,
        redirect: (context, state) => AppRoutes.post(
          state.pathParameters['area']!,
          state.pathParameters['category']!,
          state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.admin,
        builder: (BuildContext context, GoRouterState state) {
          return const AppSelectionArea(child: SigninPage());
        },
      ),
      GoRoute(
        path: AppRoutes.panel,
        redirect: (context, state) => AppRoutes.panelTab(SidebarItem.categories.value),
      ),
      GoRoute(
        path: AppRoutes.panelPostNewPattern,
        onExit: (context, state) => PostEditorPage.confirmLeave(context),
        pageBuilder: (BuildContext context, GoRouterState state) {
          final type = PostType.fromString(
            state.uri.queryParameters[AppRoutes.panelPostTypeParam],
          );

          final invalidRoute = type == null;
          if (invalidRoute) return _editorPage(const PageNotFound());

          return _editorPage(PostEditorPage.create(type: type));
        },
      ),
      GoRoute(
        path: AppRoutes.panelPostEditPattern,
        onExit: (context, state) => PostEditorPage.confirmLeave(context),
        pageBuilder: (BuildContext context, GoRouterState state) {
          return _editorPage(
            PostEditorPage.edit(
              categoryKey: state.pathParameters['categoria']!,
              postId: state.pathParameters['id']!,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.panelTabPattern,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final tab = SidebarItem.fromString(state.pathParameters['tab']);
          final postType = PostType.fromString(
            state.uri.queryParameters[AppRoutes.panelPostTypeParam],
          );

          final invalidRoute = tab == null;
          if (invalidRoute) return _panelPage(const PageNotFound());

          return _panelPage(PanelPage(tab: tab, postType: postType));
        },
      ),
      GoRoute(
        path: AppRoutes.panelLibraryAreaPattern,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final area = DocumentArea.fromRouteKey(state.pathParameters['area']);

          final invalidRoute = area == null;
          if (invalidRoute) return _panelPage(const PageNotFound());

          return _panelPage(PanelPage(tab: SidebarItem.library, libraryArea: area));
        },
      ),
    ],
  );

  // The same key on every panel route: switching section or area updates the page
  // in place, without recreating the frame or losing focus.
  static Page<void> _panelPage(Widget child) {
    return MaterialPage(key: const ValueKey('painel'), child: AppSelectionArea(child: child));
  }

  // The same key on both editor routes: saving a new post switches the URL to the
  // edit one without losing what's on screen.
  static Page<void> _editorPage(Widget child) {
    return MaterialPage(key: const ValueKey('editor'), child: AppSelectionArea(child: child));
  }

  static Widget _selectable(Widget page) => AppSelectionArea(child: page);
}
