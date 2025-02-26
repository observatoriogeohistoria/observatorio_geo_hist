import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateUserDialog(
  BuildContext context, {
  required void Function(String name, String email, String password) onCreate,
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

  final void Function(String name, String email, String password) onCreate;

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              validator: (email) => Validators.isValidEmail(email),
            ),
            SizedBox(height: AppTheme(context).dimensions.space.medium),
            AppTextField(
              controller: _passwordController,
              hintText: 'Senha',
              validator: (password) => Validators.isValidPassword(password),
            ),
            SizedBox(height: AppTheme(context).dimensions.space.medium),
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
                      _nameController.text,
                      _emailController.text,
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
