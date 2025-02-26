import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/users_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class UsersSection extends StatefulWidget {
  const UsersSection({super.key});

  @override
  State<UsersSection> createState() => _UsersSectionState();
}

class _UsersSectionState extends State<UsersSection> {
  late final UsersStore usersStore = PanelSetup.getIt<UsersStore>();

  @override
  void initState() {
    super.initState();
    usersStore.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppTheme.dimensions.space.xlarge,
        right: AppTheme.dimensions.space.xlarge,
        left: AppTheme.dimensions.space.xlarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usuários',
            style: AppTheme(context).typography.headline.small.copyWith(
                  color: AppTheme.colors.orange,
                ),
          ),
          SizedBox(height: AppTheme.dimensions.space.xlarge),
          Observer(
            builder: (context) {
              final users = usersStore.users;

              return Wrap(
                children: [
                  for (var user in users)
                    ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
