import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Navbar(),
    );
  }
}
