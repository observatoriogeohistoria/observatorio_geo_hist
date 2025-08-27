import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart' deferred as footer;
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/video_player/app_video_player.dart'
    deferred as video_player;
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/contact_us.dart'
    deferred as contact_us;
import 'package:observatorio_geo_hist/app/features/home/presentation/components/our_history.dart'
    deferred as our_history;
import 'package:observatorio_geo_hist/app/features/home/presentation/components/partners.dart'
    deferred as partners;
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team.dart'
    deferred as team;
import 'package:observatorio_geo_hist/app/features/home/presentation/components/who_we_are.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_highlights_store.dart';
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

    _fetchTeamStore.fetchTeam();

    _setupReactions();
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
          const SliverToBoxAdapter(child: Navbar()),
          const SliverToBoxAdapter(child: WhoWeAre()),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: video_player.loadLibrary(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }

                return video_player.AppVideoPlayer(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtils.getPageHorizontalPadding(context),
                    vertical: AppTheme.dimensions.space.massive.verticalSpacing,
                  ),
                  url: AppStrings.presentationVideoUrl,
                  startPlaying: true,
                  startMuted: true,
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: our_history.loadLibrary(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return our_history.OurHistory();
              },
            ),
          ),
          const SliverToBoxAdapter(child: AppDivider()),
          SliverToBoxAdapter(
            child: Observer(
              builder: (context) {
                final teamList = _fetchTeamStore.team;
                if (teamList.isEmpty) return const SizedBox.shrink();

                return FutureBuilder(
                  future: team.loadLibrary(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox.shrink();
                    }
                    return team.Team(team: teamList);
                  },
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: AppDivider()),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: partners.loadLibrary(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return partners.Partners();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: contact_us.loadLibrary(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                return contact_us.ContactUs();
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

  void _setupReactions() {
    _reactions = [
      reaction((_) => _fetchCategoriesStore.categories, (_) {
        _fetchHighlightsStore.fetchHighlights([
          ...(_fetchCategoriesStore.categories.geography),
          ...(_fetchCategoriesStore.categories.history),
        ]);
      }),
    ];
  }
}
