import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart' deferred as footer;
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/partners/partners_section.dart' deferred as partners;
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/stores/states/fetch_categories_states.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/contact_call/contact_call_section.dart'
    deferred as contact_call;
import 'package:observatorio_geo_hist/app/features/home/presentation/components/hero/home_hero.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/highlights/highlights_section.dart'
    deferred as highlights;
import 'package:observatorio_geo_hist/app/features/home/presentation/components/our_history/our_history_summary_section.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/team_section.dart'
    deferred as team;
import 'package:observatorio_geo_hist/app/features/home/presentation/components/video/presentation_video_section.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/who_we_are/who_we_are_section.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_highlights_store.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/states/fetch_highlights_states.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_team_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _fetchTeamStore = HomeSetup.getIt<FetchTeamStore>();
  late final _fetchHighlightsStore = HomeSetup.getIt<FetchHighlightsStore>();
  late final _fetchCategoriesStore = HomeSetup.getIt<FetchCategoriesStore>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    if (_fetchTeamStore.needsFetch) _fetchTeamStore.fetchTeam();

    _setupReactions();

    // A reação só dispara quando as categorias mudam. Se elas já chegaram (volta
    // de outra página) ou falharam, busca os destaques agora mesmo.
    final categoriesSettled = switch (_fetchCategoriesStore.state) {
      FetchCategoriesSuccessState() || FetchCategoriesErrorState() => true,
      _ => false,
    };
    if (categoriesSettled && _highlightsNeedFetch) {
      _fetchHighlights();
    }
  }

  @override
  void dispose() {
    for (final reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          const NavbarSliver(),
          // Hero e atalhos (spec 004): sem carregamento adiado, aparece junto com a navbar.
          const SliverToBoxAdapter(child: HomeHero()),
          // Destaques (spec 005).
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: highlights.loadLibrary(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return highlights.HighlightsSection(
                  store: _fetchHighlightsStore,
                  onRetry: _fetchHighlights,
                );
              },
            ),
          ),
          // Quem somos (spec 006): estático, aparece junto com a página.
          const SliverToBoxAdapter(child: WhoWeAreSection()),
          // Vídeo de apresentação (spec 006): capa com "Assistir"; o vídeo só é baixado depois do clique.
          const SliverToBoxAdapter(child: PresentationVideoSection()),
          // Nossa história (spec 007): resumo estático, com link para a página completa.
          const SliverToBoxAdapter(child: OurHistorySummarySection()),
          // Equipe (spec 008): grade com todos os membros; some sem membros.
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: team.loadLibrary(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return team.TeamSection(store: _fetchTeamStore, onRetry: _fetchTeamStore.fetchTeam);
              },
            ),
          ),
          // Realização e apoio (spec 009): mesma seção da Biblioteca e de Colabore.
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: partners.loadLibrary(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return partners.PartnersSection();
              },
            ),
          ),
          // Chamada para contato (spec 009).
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: contact_call.loadLibrary(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return contact_call.ContactCallSection();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: footer.loadLibrary(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return footer.Footer();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Busca os destaques com as categorias que já estiverem carregadas (podem
  /// faltar, se a busca de categorias falhou).
  void _fetchHighlights() {
    _fetchHighlightsStore.fetchHighlights([
      ...(_fetchCategoriesStore.categories.geography),
      ...(_fetchCategoriesStore.categories.history),
    ]);
  }

  /// Evita buscas repetidas: as categorias são buscadas de novo a cada navbar
  /// montada (e ao abrir o site, duas vezes). Só busca se ainda não buscou, se a
  /// busca falhou ou se a última busca foi feita sem categorias e agora elas
  /// existem. Busca em andamento não é repetida.
  bool get _highlightsNeedFetch {
    return switch (_fetchHighlightsStore.state) {
      FetchHighlightsInitialState() || FetchHighlightsErrorState() => true,
      FetchHighlightsLoadingState() => false,
      FetchHighlightsSuccessState() => _fetchHighlightsStore.fetchedWithoutCategories && _hasCategories,
    };
  }

  bool get _hasCategories {
    final categories = _fetchCategoriesStore.categories;
    return categories.geography.isNotEmpty || categories.history.isNotEmpty;
  }

  void _setupReactions() {
    _reactions = [
      reaction((_) => _fetchCategoriesStore.categories, (_) {
        if (_highlightsNeedFetch) _fetchHighlights();
      }),
      // Se as categorias falham, os destaques são buscados mesmo assim (sem categorias).
      reaction((_) => _fetchCategoriesStore.state, (state) {
        if (state is FetchCategoriesErrorState && _fetchHighlightsStore.state is FetchHighlightsInitialState) {
          _fetchHighlights();
        }
      }),
    ];
  }
}
