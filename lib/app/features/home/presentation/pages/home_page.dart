import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart' deferred as footer;
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/partners/partners_section.dart'
    deferred as partners;
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

    // A reação só dispara quando as categorias mudam. Se já chegaram (volta de outra
    // página) ou falharam, busca os destaques agora.
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
          const SliverToBoxAdapter(child: HomeHero()),
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
          const SliverToBoxAdapter(child: WhoWeAreSection()),
          const SliverToBoxAdapter(child: PresentationVideoSection()),
          const SliverToBoxAdapter(child: OurHistorySummarySection()),
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

  void _fetchHighlights() {
    _fetchHighlightsStore.fetchHighlights([
      ...(_fetchCategoriesStore.categories.geography),
      ...(_fetchCategoriesStore.categories.history),
    ]);
  }

  /// As categorias são buscadas de novo a cada navbar montada. Só refaz a busca se
  /// ainda não buscou, se falhou ou se buscou sem categorias e agora elas existem.
  bool get _highlightsNeedFetch {
    return switch (_fetchHighlightsStore.state) {
      FetchHighlightsInitialState() || FetchHighlightsErrorState() => true,
      FetchHighlightsLoadingState() => false,
      FetchHighlightsSuccessState() =>
        _fetchHighlightsStore.fetchedWithoutCategories && _hasCategories,
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
      // Se as categorias falham, os destaques são buscados mesmo assim.
      reaction((_) => _fetchCategoriesStore.state, (state) {
        if (state is FetchCategoriesErrorState &&
            _fetchHighlightsStore.state is FetchHighlightsInitialState) {
          _fetchHighlights();
        }
      }),
    ];
  }
}
