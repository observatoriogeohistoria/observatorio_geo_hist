import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
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

    _reactions = [
      reaction((_) => authStore.user, (user) {
        if (user != null) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }),
    ];
  }

  @override
  void dispose() {
    for (var reaction in _reactions) {
      reaction();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final border = BorderSide(color: AppTheme.colors.gray);

    return Scaffold(
      backgroundColor: AppTheme.colors.lightGray,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Center(
          child: Container(
            width: size.width * 0.3,
            height: size.height * 0.7,
            padding: EdgeInsets.all(AppTheme.dimensions.space.large),
            decoration: BoxDecoration(
              color: AppTheme.colors.white,
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.large),
              border: Border(
                top: border,
                left: border,
                right: border,
                bottom: border.copyWith(width: 4),
              ),
            ),
            child: Observer(
              builder: (context) {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LOGIN',
                        style: AppTheme.typography.title.large.copyWith(
                          color: AppTheme.colors.darkGray,
                        ),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.large),
                      AppTextField(
                        controller: emailController,
                        hintText: 'E-MAIL',
                        validator: (email) => Validators.isValidEmail(email),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.large),
                      AppTextField(
                        controller: passwordController,
                        hintText: 'SENHA',
                        obscureText: !authStore.passwordVisible,
                        validator: (password) => Validators.isValidPassword(password),
                        suffixIcon: GestureDetector(
                          onTap: authStore.togglePasswordVisibility,
                          child: authStore.passwordVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.small),
                      Text(
                        'A senha deve contar com 8 caracteres, sendo pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial.',
                        style: AppTheme.typography.label.small.copyWith(
                          color: AppTheme.colors.gray,
                        ),
                      ),
                      SizedBox(height: AppTheme.dimensions.space.xlarge),
                      PrimaryButton(
                        text: "ENTRAR",
                        onPressed: () {
                          GoRouter.of(context).go('/admin/panel');
                          return;

                          if (formKey.currentState!.validate()) {
                            authStore.login(emailController.text, passwordController.text);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
