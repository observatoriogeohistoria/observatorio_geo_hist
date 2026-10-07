import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_state.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late final _authStore = AdminSetup.getIt<AuthStore>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    _authStore.currentUser();

    _reactions = [
      reaction((_) => _authStore.user, (UserModel? user) {
        if (user != null) {
          GoRouter.of(context).go(AppRoutes.panel);
        }
      }),
      reaction((_) => _authStore.state, (AuthState state) {
        if (state.loginState is LoginStateError) {
          final loginState = state.loginState as LoginStateError;
          Messenger.showError(context, loginState.failure.message);
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction.reaction.dispose();
    }

    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final typography = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);

    return Scaffold(
      backgroundColor: colors.surface,
      body: Observer(builder: (context) {
        final loginState = _authStore.state.loginState;
        final passwordVisible = _authStore.passwordVisible;

        return Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ScreenUtils.contentMargin(breakpoint)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: components.signinCardMaxWidth),
              child: AppCard(
                padding: EdgeInsets.all(components.signinCardPadding(breakpoint)),
                borderColor: colors.lineStrong,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('LOGIN', style: typography.h2.copyWith(color: colors.ink)),
                      SizedBox(height: spacing.s24),
                      AppTextField(
                        controller: _emailController,
                        labelText: 'E-MAIL',
                        hintText: 'exemplo@dominio.com',
                        validator: Validators.isValidEmail,
                      ),
                      SizedBox(height: spacing.s24),
                      AppTextField(
                        controller: _passwordController,
                        labelText: 'SENHA',
                        obscureText: !passwordVisible,
                        validator: Validators.isValidPassword,
                        suffixIcon: AppIconButton(
                          tooltip: passwordVisible ? 'Ocultar senha' : 'Mostrar senha',
                          icon: passwordVisible ? Icons.visibility_off : Icons.visibility,
                          color: colors.inkSecondary,
                          size: components.menuIconSize,
                          onPressed: _authStore.togglePasswordVisibility,
                        ),
                      ),
                      SizedBox(height: spacing.s8),
                      Text(
                        'A senha deve contar com 8 caracteres, sendo pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial.',
                        style: typography.small.copyWith(color: colors.inkSecondary),
                      ),
                      SizedBox(height: spacing.s32),
                      loginState is LoginStateLoading
                          ? const CircularLoading()
                          : PrimaryButton.medium(
                              text: "ENTRAR",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _authStore.login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
