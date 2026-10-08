import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/form_validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/admin_setup.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/infra/errors/auth_failure.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/components/back_to_site_link.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/components/login_brand_panel.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/components/login_error_alert.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/components/password_visibility_button.dart';
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
  static const _credentialsMessage =
      'E-mail ou senha não conferem. Confira os dois e tente de novo.';

  late final _authStore = AdminSetup.getIt<AuthStore>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final _emailValidator = FormValidators.email('Informe o e-mail, como nome@exemplo.com.');
  final _passwordValidator = FormValidators.required('Informe a senha.');

  bool _attempted = false;

  // O store guarda o último erro mesmo depois de sair da página; só mostra o que vier desta tela.
  bool _errorVisible = false;

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
      reaction((_) => _authStore.state.loginState, (LoginState state) {
        if (state is LoginStateError) _handleError(state.failure);
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
    _emailFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  bool get _isLoading => _authStore.state.loginState is LoginStateLoading;

  void _submit() {
    if (_isLoading) return;

    setState(() {
      _attempted = true;
      _errorVisible = false;
    });

    if (!_formKey.currentState!.validate()) {
      final emailInvalid = _emailValidator(_emailController.text) != null;
      (emailInvalid ? _emailFocus : _passwordFocus).requestFocus();
      return;
    }

    _authStore.login(_emailController.text.trim(), _passwordController.text);
  }

  // Os campos já passaram na validação; sem desligá-la, apagar a senha mostraria "Informe a senha.".
  void _handleError(AuthFailure failure) {
    setState(() {
      _errorVisible = true;
      _attempted = false;
    });

    if (_isCredentialsFailure(failure)) {
      _passwordController.clear();
      _formKey.currentState?.reset();
      _passwordFocus.requestFocus();
    }
  }

  bool _isCredentialsFailure(AuthFailure failure) =>
      failure is InvalidCredentials || failure is UserNotFound || failure is WrongPassword;

  String? get _errorMessage {
    final state = _authStore.state.loginState;
    if (!_errorVisible || state is! LoginStateError) return null;
    return _isCredentialsFailure(state.failure) ? _credentialsMessage : state.failure.message;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final isMobile = breakpoint == Breakpoint.mobile;

    final formArea = Padding(
      padding: EdgeInsets.fromLTRB(
        components.loginMainPaddingH(breakpoint),
        components.loginMainPaddingTop(breakpoint),
        components.loginMainPaddingH(breakpoint),
        components.loginMainPaddingBottom,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: components.loginCardMaxWidth),
          child: _buildCard(context, breakpoint),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: colors.surface,
      body: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [const LoginBrandPanel(compact: true), formArea],
                      )
                    : IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: components.loginBrandFlex,
                              child: const LoginBrandPanel(),
                            ),
                            Expanded(flex: components.loginFormFlex, child: formArea),
                          ],
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Breakpoint breakpoint) {
    final colors = AppTheme.colors;
    final dimensions = AppTheme.dimensions;
    final components = dimensions.components;
    final styles = AppTheme.typography.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.page,
        borderRadius: BorderRadius.circular(dimensions.radii.r18),
        border: Border.all(color: colors.line, width: dimensions.stroke.small),
        boxShadow: dimensions.shadows.card,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: components.loginCardPaddingH(breakpoint),
          vertical: components.loginCardPaddingV(breakpoint),
        ),
        child: Observer(
          builder: (context) {
            final isLoading = _isLoading;
            final passwordVisible = _authStore.passwordVisible;
            final errorMessage = _errorMessage;

            return Form(
              key: _formKey,
              autovalidateMode: _attempted ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      header: true,
                      child:
                          Text('Entrar', style: styles.loginCardTitle.copyWith(color: colors.ink)),
                    ),
                    SizedBox(height: components.loginCardSubtitleGap),
                    Text(
                      'Use o e-mail e a senha que a administração cadastrou para você.',
                      style: styles.loginLead.copyWith(color: colors.inkSecondary),
                    ),
                    SizedBox(height: components.loginCardFieldsTop),
                    if (errorMessage != null) ...[
                      LoginErrorAlert(message: errorMessage),
                      SizedBox(height: components.formFieldGap),
                    ],
                    FormTextField(
                      label: 'E-mail',
                      hintText: 'nome@exemplo.com',
                      controller: _emailController,
                      focusNode: _emailFocus,
                      validator: _emailValidator,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _submit(),
                    ),
                    SizedBox(height: components.formFieldGap),
                    FormTextField(
                      label: 'Senha',
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      validator: _passwordValidator,
                      obscureText: !passwordVisible,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                      suffix: PasswordVisibilityButton(
                        visible: passwordVisible,
                        onPressed: _authStore.togglePasswordVisibility,
                      ),
                    ),
                    SizedBox(height: components.formFieldGap),
                    PrimaryButton.medium(
                      text: isLoading ? 'Entrando…' : 'Entrar',
                      isLoading: isLoading,
                      expand: true,
                      onPressed: _submit,
                    ),
                    SizedBox(height: components.loginBackLinkTop),
                    const Align(alignment: Alignment.centerLeft, child: BackToSiteLink()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
