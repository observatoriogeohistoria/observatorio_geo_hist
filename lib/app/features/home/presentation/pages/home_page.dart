import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart' deferred as footer;
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
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
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/states/fetch_team_states.dart';
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

  final _scrollController = ScrollController();
  final _teamKey = GlobalKey();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    if (_fetchTeamStore.needsFetch) _fetchTeamStore.fetchTeam();

    _setupReactions();

    // The reaction only fires when categories change. If they already arrived (coming back from
    // another page) or failed, fetches the highlights now.
    final categoriesSettled = switch (_fetchCategoriesStore.state) {
      FetchCategoriesSuccessState() || FetchCategoriesErrorState() => true,
      _ => false,
    };
    if (categoriesSettled && _highlightsNeedFetch) {
      _fetchHighlights();
    }

    AppRoutes.teamRequest.addListener(_onTeamRequest);
    if (AppRoutes.teamRequest.value) {
      AppRoutes.teamRequest.value = false;
      _scrollToTeam(animate: false);
    }
  }

  @override
  void dispose() {
    AppRoutes.teamRequest.removeListener(_onTeamRequest);
    _scrollController.dispose();
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
        controller: _scrollController,
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
            key: _teamKey,
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

  // Waits for the navigation frame: if it creates another Home, the new one handles it, in initState.
  Future<void> _onTeamRequest() async {
    if (!AppRoutes.teamRequest.value) return;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || !AppRoutes.teamRequest.value) return;
    AppRoutes.teamRequest.value = false;
    _scrollToTeam();
  }

  // Highlights sit above the team: scrolling before they arrive would leave the section out of
  // place when their height changed.
  Future<void> _scrollToTeam({bool animate = true}) async {
    await Future.wait([highlights.loadLibrary(), team.loadLibrary()]);
    await asyncWhen((_) => _highlightsSettled && _teamSettled);
    await WidgetsBinding.instance.endOfFrame;

    final target = _teamKey.currentContext?.findRenderObject();
    if (!mounted || target == null || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    final viewport = RenderAbstractViewport.of(target);
    // The navbar is pinned to the top and would cover the section title.
    final offset =
        (viewport.getOffsetToReveal(target, 0).offset - AppTheme.dimensions.components.navbarHeight)
            .clamp(position.minScrollExtent, position.maxScrollExtent);

    if (!animate || MediaQuery.disableAnimationsOf(context)) {
      position.jumpTo(offset);
    } else {
      await position.animateTo(
        offset,
        duration: AppTheme.dimensions.components.scrollToSectionAnimation,
        curve: Curves.easeInOut,
      );
    }
  }

  void _fetchHighlights() {
    _fetchHighlightsStore.fetchHighlights([
      ...(_fetchCategoriesStore.categories.geography),
      ...(_fetchCategoriesStore.categories.history),
    ]);
  }

  /// Categories are fetched again on every navbar build. Only refetches if it
  /// hasn't fetched yet, if it failed, or if it fetched without categories and now they exist.
  bool get _highlightsNeedFetch {
    return switch (_fetchHighlightsStore.state) {
      FetchHighlightsInitialState() || FetchHighlightsErrorState() => true,
      FetchHighlightsLoadingState() => false,
      FetchHighlightsSuccessState() =>
        _fetchHighlightsStore.fetchedWithoutCategories && _hasCategories,
    };
  }

  bool get _highlightsSettled => switch (_fetchHighlightsStore.state) {
        FetchHighlightsSuccessState() || FetchHighlightsErrorState() => true,
        _ => false,
      };

  bool get _teamSettled => switch (_fetchTeamStore.state) {
        FetchTeamSuccessState() || FetchTeamErrorState() => true,
        _ => false,
      };

  bool get _hasCategories {
    final categories = _fetchCategoriesStore.categories;
    return categories.geography.isNotEmpty || categories.history.isNotEmpty;
  }

  void _setupReactions() {
    _reactions = [
      reaction((_) => _fetchCategoriesStore.categories, (_) {
        if (_highlightsNeedFetch) _fetchHighlights();
      }),
      // If categories fail, highlights are fetched anyway.
      reaction((_) => _fetchCategoriesStore.state, (state) {
        if (state is FetchCategoriesErrorState &&
            _fetchHighlightsStore.state is FetchHighlightsInitialState) {
          _fetchHighlights();
        }
      }),
    ];
  }
}
