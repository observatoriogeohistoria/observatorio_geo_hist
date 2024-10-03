import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
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

    HomeSetup.getIt.isReady<HomeStore>().then((_) {
      store = HomeSetup.getIt.get<HomeStore>();
      store.fetchGeographyCategories();
      store.fetchHistoryCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Navbar(),
        ],
      ),
    );
  }
}
