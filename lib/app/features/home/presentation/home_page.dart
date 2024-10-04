import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeStore store;

  @override
  void initState() {
    super.initState();

    store = HomeSetup.getIt.get<HomeStore>();
    store.fetchHistoryCategories();
    store.fetchGeographyCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          return Column(
            children: [
              Navbar(
                options: [
                  NavButtonItem(
                    title: 'SOBRE',
                    route: AppRoutes.root,
                  ),
                  NavButtonItem(
                    title: 'EXPOGEO',
                    route: AppRoutes.root,
                  ),
                  NavButtonItem(
                    title: 'HISTÓRIA',
                    route: AppRoutes.root,
                    options: store.historyCategories
                        .map(
                          (e) => NavButtonItem(
                            title: e.title,
                            route: AppRoutes.root,
                          ),
                        )
                        .toList(),
                  ),
                  NavButtonItem(
                    title: 'GEOGRAFIA',
                    route: AppRoutes.root,
                    options: store.geographyCategories
                        .map(
                          (e) => NavButtonItem(
                            title: e.title,
                            route: AppRoutes.root,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
