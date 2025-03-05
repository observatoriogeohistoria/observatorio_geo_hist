import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateUserDialog(
  BuildContext context, {
  required void Function(UserModel user, String password) onCreate,
}) {
  showDialog(
    context: context,
    builder: (_) => CreateUserDialog(
      onCreate: onCreate,
    ),
  );
}

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({
    required this.onCreate,
    super.key,
  });

  final void Function(UserModel user, String password) onCreate;

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRole? selectedRole;

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTitle.medium(
              text: 'Criar usuário',
              color: AppTheme(context).colors.orange,
            ),
            SizedBox(height: AppTheme(context).dimensions.space.xlarge),
            AppTextField(
              controller: _nameController,
              hintText: 'Nome',
            ),
            SizedBox(height: AppTheme(context).dimensions.space.medium),
            AppTextField(
              controller: _emailController,
              hintText: 'E-mail',
              validator: Validators.isValidEmail,
            ),
            SizedBox(height: AppTheme(context).dimensions.space.medium),
            AppTextField(
              controller: _passwordController,
              hintText: 'Senha',
              validator: Validators.isValidPassword,
            ),
            SizedBox(height: AppTheme(context).dimensions.space.medium),
            AppDropdownField<UserRole>(
              hintText: 'Selecione um papel',
              items: UserRole.values,
              itemToString: (role) => role.toString(),
              value: selectedRole,
              onChanged: (role) {
                if (role == null) return;
                setState(() => selectedRole = UserRole.fromString(role));
              },
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton.medium(
                  text: 'Cancelar',
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: AppTheme(context).dimensions.space.medium),
                PrimaryButton.medium(
                  text: 'Criar',
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    widget.onCreate(
                      UserModel(
                        name: _nameController.text,
                        email: _nameController.text,
                        role: selectedRole!,
                      ),
                      _passwordController.text,
                    );

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
