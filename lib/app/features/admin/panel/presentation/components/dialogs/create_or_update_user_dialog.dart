import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/form/form_text_field.dart';
import 'package:observatorio_geo_hist/app/features/admin/login/presentation/components/password_visibility_button.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_role.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_choice_cards.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_sheet.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/sheet/panel_validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/sidebar/presentation/labels/user_role_label.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

Future<void> showCreateOrUpdateUserDialog(
  BuildContext context, {
  required Future<String?> Function(UserModel user, String password) onCreate,
  required Future<String?> Function(UserModel user) onUpdate,
  UserModel? user,
}) {
  return showPanelSheet(
    context,
    builder: (_) => CreateOrUpdateUserDialog(onCreate: onCreate, onUpdate: onUpdate, user: user),
  );
}

class CreateOrUpdateUserDialog extends StatefulWidget {
  const CreateOrUpdateUserDialog({
    required this.onCreate,
    required this.onUpdate,
    this.user,
    super.key,
  });

  final Future<String?> Function(UserModel user, String password) onCreate;
  final Future<String?> Function(UserModel user) onUpdate;
  final UserModel? user;

  @override
  State<CreateOrUpdateUserDialog> createState() => _CreateOrUpdateUserDialogState();
}

class _CreateOrUpdateUserDialogState extends State<CreateOrUpdateUserDialog> {
  late final _nameController = TextEditingController(text: widget.user?.name);
  late final _emailController = TextEditingController(text: widget.user?.email);
  final _passwordController = TextEditingController();

  final _nameKey = GlobalKey<FormFieldState<String>>();
  final _emailKey = GlobalKey<FormFieldState<String>>();
  final _passwordKey = GlobalKey<FormFieldState<String>>();
  final _roleKey = GlobalKey<FormFieldState<UserRole>>();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _roleFocus = FocusNode();

  late UserRole? _role = widget.user?.role;
  bool _passwordVisible = false;

  bool get _isUpdate => widget.user != null;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    for (final node in [_nameFocus, _emailFocus, _passwordFocus, _roleFocus]) {
      node.dispose();
    }
    super.dispose();
  }

  Future<String?> _save() {
    if (_isUpdate) {
      return widget.onUpdate(
        widget.user!.copyWith(
          name: _nameController.text,
          email: _emailController.text,
          role: _role,
        ),
      );
    }

    return widget.onCreate(
      UserModel(name: _nameController.text, email: _emailController.text, role: _role!),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: AppTheme.dimensions.components.formFieldGap);

    return PanelSheet(
      title: _isUpdate ? 'Editar usuário' : 'Novo usuário',
      onSave: _save,
      fields: [
        PanelSheetField(_nameKey, _nameFocus),
        PanelSheetField(_emailKey, _emailFocus),
        if (!_isUpdate) PanelSheetField(_passwordKey, _passwordFocus),
        PanelSheetField(_roleKey, _roleFocus),
      ],
      builder: (context) {
        void submit(String _) => PanelSheet.submitOf(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FormTextField(
              label: 'Nome',
              controller: _nameController,
              focusNode: _nameFocus,
              formFieldKey: _nameKey,
              validator: PanelValidators.required,
              autofocus: true,
              readOnly: _isUpdate,
              textInputAction: TextInputAction.done,
              onSubmitted: submit,
            ),
            gap,
            FormTextField(
              label: 'E-mail',
              controller: _emailController,
              focusNode: _emailFocus,
              formFieldKey: _emailKey,
              validator: PanelValidators.email,
              keyboardType: TextInputType.emailAddress,
              readOnly: _isUpdate,
              textInputAction: TextInputAction.done,
              onSubmitted: submit,
            ),
            gap,
            if (!_isUpdate) ...[
              FormTextField(
                label: 'Senha inicial',
                controller: _passwordController,
                focusNode: _passwordFocus,
                formFieldKey: _passwordKey,
                validator: PanelValidators.password,
                obscureText: !_passwordVisible,
                helperText: '8 caracteres ou mais, com letra maiúscula, minúscula, número e '
                    'caractere especial. Envie à pessoa por um canal seguro.',
                textInputAction: TextInputAction.done,
                onSubmitted: submit,
                suffix: PasswordVisibilityButton(
                  visible: _passwordVisible,
                  onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
              gap,
            ],
            PanelChoiceCards<UserRole>(
              label: 'Papel',
              options: [
                for (final role in UserRole.values) PanelChoice(role, role.label, role.description),
              ],
              value: _role,
              formFieldKey: _roleKey,
              focusNode: _roleFocus,
              validator: PanelValidators.choice('Escolha um papel.'),
              onChanged: (role) => setState(() => _role = role),
            ),
          ],
        );
      },
    );
  }
}
