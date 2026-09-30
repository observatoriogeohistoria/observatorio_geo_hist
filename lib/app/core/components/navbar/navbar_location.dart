import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';

/// Seções da navbar que podem estar ativas.
enum NavbarSection { about, history, geography, library }

/// Onde a pessoa está, segundo a rota: define o item ativo da navbar e a
/// categoria marcada nos menus.
class NavbarLocation {
  const NavbarLocation({this.section, this.categoryKey});

  /// Localização da rota atual. Na página de erro (404) não há `GoRouterState`,
  /// então cai para o endereço do roteador.
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
      case 'biblioteca':
        return const NavbarLocation(section: NavbarSection.library);
      case 'publicacoes':
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

  /// Chave da categoria aberta (só em rotas de publicações).
  final String? categoryKey;

  /// Chave da categoria marcada no menu de [area], se for a área ativa.
  String? categoryKeyFor(PostsAreas area) {
    final expected = area == PostsAreas.history ? NavbarSection.history : NavbarSection.geography;
    return section == expected ? categoryKey : null;
  }
}
