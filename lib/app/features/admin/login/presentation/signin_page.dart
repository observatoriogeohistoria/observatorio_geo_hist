import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/stores/auth_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late AuthStore authStore;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    authStore = AdminSetup.getIt<AuthStore>();
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
            child: Form(
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
                  ),
                  SizedBox(height: AppTheme.dimensions.space.large),
                  AppTextField(
                    controller: passwordController,
                    hintText: 'SENHA',
                    obscureText: true,
                  ),
                  SizedBox(height: AppTheme.dimensions.space.xlarge),
                  PrimaryButton(
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
        ),
      ),
    );
  }
}
