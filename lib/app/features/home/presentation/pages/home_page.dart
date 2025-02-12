import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/contact_us.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/our_history.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/partners.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/who_we_are.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_team_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FetchTeamStore fetchTeamStore = HomeSetup.getIt<FetchTeamStore>();

  @override
  void initState() {
    super.initState();

    fetchTeamStore.fetchTeam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Navbar(),
            const WhoWeAre(),
            const OurHistory(),
            const AppDivider(),
            Observer(
              builder: (context) {
                if (fetchTeamStore.team.isEmpty) {
                  return const SizedBox.shrink();
                }

                // TODO: Remove this code
                List<T> multiplyListItems<T>(List<T> originalList, int times) {
                  List<T> newList = [];
                  for (var item in originalList) {
                    for (int i = 0; i < times; i++) {
                      newList.add(item);
                    }
                  }
                  return newList;
                }

                return Team(team: multiplyListItems(fetchTeamStore.team, 10));
              },
            ),
            const AppDivider(),
            const Partners(),
            const ContactUs(),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
