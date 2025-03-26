import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/card/app_card.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/circular_loading.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/messenger/messenger.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_state.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late final AuthStore authStore = AdminSetup.getIt<AuthStore>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<ReactionDisposer> _reactions = [];

  @override
  void initState() {
    super.initState();

    authStore.currentUser();

    _reactions = [
      reaction((_) => authStore.state, (AuthState state) {
        if (state.user != null) {
          GoRouter.of(context).go('/admin/painel');
        }

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    bool isMobile = DeviceUtils.isMobile(context);
    bool isTablet = DeviceUtils.isTablet(context);

    return Scaffold(
      backgroundColor: AppTheme.colors.lightGray,
      body: SizedBox(
        width: size.width,
        child: Observer(builder: (context) {
          final loginState = authStore.state.loginState;

          return Center(
            child: AppCard(
              width: size.width * (isMobile ? 1 : (isTablet ? 0.5 : 0.3)),
              padding: EdgeInsets.all(AppTheme.dimensions.space.large.scale),
              margin: isMobile
                  ? EdgeInsets.symmetric(
                      horizontal: AppTheme.dimensions.space.medium.horizontalSpacing,
                    )
                  : EdgeInsets.zero,
              borderColor: AppTheme.colors.gray,
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTitle.big(
                      text: 'LOGIN',
                      color: AppTheme.colors.darkGray,
                    ),
                    SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                    AppTextField(
                      controller: emailController,
                      labelText: 'E-MAIL',
                      hintText: 'exemplo@dominio.com',
                      validator: Validators.isValidEmail,
                    ),
                    SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                    AppTextField(
                      controller: passwordController,
                      labelText: 'SENHA',
                      obscureText: !authStore.passwordVisible,
                      validator: Validators.isValidPassword,
                      suffixIcon: GestureDetector(
                        onTap: authStore.togglePasswordVisibility,
                        child: authStore.passwordVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                    ),
                    SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                    AppLabel.small(
                      text:
                          'A senha deve contar com 8 caracteres, sendo pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial.',
                      color: AppTheme.colors.gray,
                    ),
                    SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                    loginState is LoginStateLoading
                        ? const CircularLoading()
                        : PrimaryButton.medium(
                            text: "ENTRAR",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                authStore.login(emailController.text, passwordController.text);
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
