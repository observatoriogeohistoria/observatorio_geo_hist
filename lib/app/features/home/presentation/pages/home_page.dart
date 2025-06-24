import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/video_player/app_video_player.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/contact_us.dart';
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
  late final FetchTeamStore fetchTeamStore = HomeSetup.getIt<FetchTeamStore>();
  late final FetchHighlightsStore fetchHighlightsStore = HomeSetup.getIt<FetchHighlightsStore>();

  @override
  void initState() {
    super.initState();

    fetchTeamStore.fetchTeam();
    fetchHighlightsStore.fetchHighlights();
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
                horizontal: DeviceUtils.getPageHorizontalPadding(context),
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
                final team = fetchTeamStore.team;
                return team.isEmpty ? const SizedBox.shrink() : Team(team: fetchTeamStore.team);
              },
            ),
          ),
          const SliverToBoxAdapter(child: AppDivider()),
          const SliverToBoxAdapter(child: Partners()),
          const SliverToBoxAdapter(child: ContactUs()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
