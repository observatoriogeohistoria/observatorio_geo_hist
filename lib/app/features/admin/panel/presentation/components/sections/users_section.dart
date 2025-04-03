import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/linear_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/scroll/app_scrollbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/panel_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/cards/user_card.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/create_or_update_user_dialog.dart';
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

  final _scrollController = ScrollController();

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

        if (state is ManageUsersSuccessState) {
          GoRouter.of(context).pop();

          if (state.message.isNotEmpty) {
            Messenger.showSuccess(context, state.message);
          }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppHeadline.big(
          text: 'Usuários',
          color: AppTheme.colors.orange,
        ),
        SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
        Align(
          alignment: Alignment.centerRight,
          child: SecondaryButton.medium(
            text: 'Criar usuário',
            onPressed: () {
              showCreateOrUpdateUserDialog(
                context,
                onCreate: (user, password) => usersStore.createUser(user, password),
                onUpdate: (user) => usersStore.updateUser(user),
              );
            },
          ),
        ),
        Observer(
          builder: (context) {
            final state = usersStore.state;

            if (state is ManageUsersLoadingState && state.isRefreshing) {
              return const LinearLoading();
            }

            return const SizedBox.shrink();
          },
        ),
        SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
        Expanded(
          child: Observer(
            builder: (context) {
              final state = usersStore.state;

              if (state is ManageUsersLoadingState && !state.isRefreshing) {
                return const Center(child: CircularLoading());
              }

              final users = usersStore.users;

              return AppScrollbar(
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: AppTheme.dimensions.space.large.verticalSpacing,
                  ),
                  separatorBuilder: (context, index) {
                    final isLast = index == users.length - 1;

                    return isLast
                        ? const SizedBox()
                        : SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing);
                  },
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return UserCard(
                      user: user,
                      index: index + 1,
                      onDelete: () => usersStore.deleteUser(user),
                      onEdit: () {
                        showCreateOrUpdateUserDialog(
                          context,
                          onCreate: (user, password) => usersStore.createUser(user, password),
                          onUpdate: (user) => usersStore.updateUser(user),
                          user: user,
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
