import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/video_player/app_video_player.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/contact_us.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/dialog/highlights_dialog_carousel.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/our_history.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/partners.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team.dart';
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
    _fetchHighlightsStore.fetchHighlights([]);

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
            child: AppVideoPlayer(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtils.getPageHorizontalPadding(context),
                vertical: AppTheme.dimensions.space.massive.verticalSpacing,
              ),
              url: AppStrings.presentationVideoUrl,
              startPlaying: true,
              startMuted: true,
            ),
          ),
          const SliverToBoxAdapter(child: OurHistory()),
          const SliverToBoxAdapter(child: AppDivider()),
          SliverToBoxAdapter(
            child: Observer(
              builder: (context) {
                final team = _fetchTeamStore.team;
                return team.isEmpty ? const SizedBox.shrink() : Team(team: _fetchTeamStore.team);
              },
            ),
          ),
          const SliverToBoxAdapter(child: AppDivider()),
          const SliverToBoxAdapter(child: Partners()),
          const SliverToBoxAdapter(child: ContactUs()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
      floatingActionButton: Observer(builder: (context) {
        final highlights = _fetchHighlightsStore.highlights;
        final isOpen = _fetchHighlightsStore.highlightsDialogIsOpen;

        if (highlights.isEmpty || isOpen) return const SizedBox.shrink();

        return PrimaryButton.medium(
          text: "Visualizar Destaques",
          onPressed: _showHighlights,
        );
      }),
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
      reaction((_) => _fetchHighlightsStore.highlights, (_) {
        if (_fetchHighlightsStore.highlightsDialogWasShown) return;

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          if (!mounted) return;

          _fetchHighlightsStore.showHighlights();
          await Future.delayed(const Duration(seconds: 5));

          _showHighlights();
        });
      }),
    ];
  }

  void _showHighlights() {
    showHighlightsDialog(
      context,
      highlights: _fetchHighlightsStore.highlights,
      onClose: _fetchHighlightsStore.hideHighlights,
    );
  }
}
