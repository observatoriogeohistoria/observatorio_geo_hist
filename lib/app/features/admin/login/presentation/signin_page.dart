import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/loading/loading.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
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
    final border = BorderSide(color: AppTheme(context).colors.gray);

    return Scaffold(
      backgroundColor: AppTheme(context).colors.lightGray,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Observer(builder: (context) {
          final loginState = authStore.state.loginState;

          return Center(
            child: Container(
              width: size.width * 0.3,
              height: size.height * 0.7,
              padding: EdgeInsets.all(AppTheme(context).dimensions.space.large),
              decoration: BoxDecoration(
                color: AppTheme(context).colors.white,
                borderRadius: BorderRadius.circular(AppTheme(context).dimensions.radius.large),
                border: Border(
                  top: border,
                  left: border,
                  right: border,
                  bottom: border.copyWith(width: AppTheme(context).dimensions.stroke.xlarge),
                ),
              ),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTitle.big(
                      text: 'LOGIN',
                      color: AppTheme(context).colors.darkGray,
                    ),
                    SizedBox(height: AppTheme(context).dimensions.space.large),
                    AppTextField(
                      controller: emailController,
                      hintText: 'E-MAIL',
                      validator: Validators.isValidEmail,
                    ),
                    SizedBox(height: AppTheme(context).dimensions.space.large),
                    AppTextField(
                      controller: passwordController,
                      hintText: 'SENHA',
                      obscureText: !authStore.passwordVisible,
                      validator: Validators.isValidPassword,
                      suffixIcon: GestureDetector(
                        onTap: authStore.togglePasswordVisibility,
                        child: authStore.passwordVisible
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                    ),
                    SizedBox(height: AppTheme(context).dimensions.space.small),
                    AppLabel.small(
                      text:
                          'A senha deve contar com 8 caracteres, sendo pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial.',
                      color: AppTheme(context).colors.gray,
                    ),
                    SizedBox(height: AppTheme(context).dimensions.space.xlarge),
                    loginState is LoginStateLoading
                        ? const Loading()
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
