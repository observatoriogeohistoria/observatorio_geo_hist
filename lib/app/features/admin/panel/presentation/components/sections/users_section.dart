import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/user_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_user_dialog.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/states/users_states.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/stores/users_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class UsersSection extends StatefulWidget {
  const UsersSection({super.key});

  @override
  State<UsersSection> createState() => _UsersSectionState();
}

class _UsersSectionState extends State<UsersSection> {
  late final UsersStore usersStore = PanelSetup.getIt<UsersStore>();
  late final AuthStore authStore = PanelSetup.getIt<AuthStore>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();
    usersStore.getUsers();

    _reactions = [
      reaction((_) => usersStore.state, (state) {
        if (state is ManageUsersErrorState) {
          final error = state.failure;
          Messenger.showError(context, error.message);

          if (error is Forbidden) authStore.logout();
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: AppTheme(context).dimensions.space.xlarge,
        right: AppTheme(context).dimensions.space.xlarge,
        left: AppTheme(context).dimensions.space.xlarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeadline.big(
            text: 'Usuários',
            color: AppTheme(context).colors.orange,
          ),
          SizedBox(height: AppTheme(context).dimensions.space.xlarge),
          Align(
            alignment: Alignment.centerRight,
            child: SecondaryButton.small(
              text: 'Criar usuário',
              onPressed: () {
                showCreateUserDialog(
                  context,
                  onCreate: (name, email, password) {
                    usersStore.createUser(
                      UserModel(name: name, email: email, role: UserRole.editor),
                      password,
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Observer(
              builder: (context) {
                final users = usersStore.users;

                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: AppTheme(context).dimensions.space.large,
                  ),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isLast = index == users.length - 1;

                    return Column(
                      children: [
                        UserCard(
                          user: user,
                          onDelete: () => usersStore.deleteUser(user),
                        ),
                        if (!isLast) SizedBox(height: AppTheme(context).dimensions.space.medium),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
