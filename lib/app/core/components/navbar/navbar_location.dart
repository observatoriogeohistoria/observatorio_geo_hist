import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

enum NavbarSection { about, history, geography, library }

class NavbarLocation {
  const NavbarLocation({this.section, this.categoryKey});

  /// Na 404 não há `GoRouterState`, então usa o endereço do roteador.
  factory NavbarLocation.of(BuildContext context) {
    try {
      return NavbarLocation.fromUri(GoRouterState.of(context).uri);
    } catch (_) {
      return NavbarLocation.fromUri(GoRouter.of(context).routeInformationProvider.value.uri);
    }
  }

  factory NavbarLocation.fromUri(Uri uri) {
    final segments = uri.pathSegments;

    if (segments.isEmpty) return const NavbarLocation(section: NavbarSection.about);

    switch (segments.first) {
      case AppRoutes.librarySegment:
        return const NavbarLocation(section: NavbarSection.library);
      case AppRoutes.publicationsSegment:
        if (segments.length < 2) return const NavbarLocation();
        final section = switch (segments[1]) {
          'historia' => NavbarSection.history,
          'geografia' => NavbarSection.geography,
          _ => null,
        };
        return NavbarLocation(
          section: section,
          categoryKey: segments.length > 2 ? segments[2] : null,
        );
      default:
        return const NavbarLocation();
    }
  }

  final NavbarSection? section;

  final String? categoryKey;

  String? categoryKeyFor(PostsAreas area) {
    final expected = area == PostsAreas.history ? NavbarSection.history : NavbarSection.geography;
    return section == expected ? categoryKey : null;
  }
}
