import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/components/sidebar_navigation.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/stores/sidebar_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  late final SidebarStore sidebarStore = PanelSetup.getIt<SidebarStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppTheme.colors.white),
        backgroundColor: AppTheme.colors.orange,
        title: Text(
          'PAINEL ADMINISTRATIVO',
          style: AppTheme.typography.headline.small.copyWith(
            color: AppTheme.colors.white,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
