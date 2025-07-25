import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_dropdown_field.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_model.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/user_role.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/presentation/components/dialogs/post_form_dialog.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateUserDialog(
  BuildContext context, {
  required void Function(UserModel user, String password) onCreate,
  required void Function(UserModel user) onUpdate,
  UserModel? user,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CreateOrUpdateUserDialog(
      onCreate: onCreate,
      onUpdate: onUpdate,
      user: user,
    ),
  );
}

class CreateOrUpdateUserDialog extends StatefulWidget {
  const CreateOrUpdateUserDialog({
    required this.onCreate,
    required this.onUpdate,
    this.user,
    super.key,
  });

  final void Function(UserModel user, String password) onCreate;
  final void Function(UserModel user) onUpdate;
  final UserModel? user;

  @override
  State<CreateOrUpdateUserDialog> createState() => _CreateOrUpdateUserDialogState();
}

class _CreateOrUpdateUserDialogState extends State<CreateOrUpdateUserDialog> {
  late final _nameController = TextEditingController(text: widget.user?.name);
  late final _emailController = TextEditingController(text: widget.user?.email);
  final _passwordController = TextEditingController();

  late UserRole? _selectedRole = widget.user?.role;

  bool get _isUpdate => widget.user != null;

  @override
  Widget build(BuildContext context) {
    return PostFormDialog(
      onSubmit: _onCreateOrUpdate,
      isUpdate: _isUpdate,
      isFullScreen: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTitle.medium(
            text: _isUpdate ? 'Atualizar usuário' : 'Criar usuário',
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
          AppTextField(
            controller: _nameController,
            labelText: 'Nome',
            validator: Validators.isNotEmpty,
            isDisabled: _isUpdate,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          AppTextField(
            controller: _emailController,
            labelText: 'E-mail',
            validator: Validators.isValidEmail,
            isDisabled: _isUpdate,
          ),
          SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          if (!_isUpdate) ...[
            AppTextField(
              controller: _passwordController,
              labelText: 'Senha',
              validator: Validators.isValidPassword,
            ),
            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
          ],
          AppDropdownField<UserRole>(
            hintText: 'Selecione um papel',
            items: UserRole.values,
            itemToString: (role) => role.toString(),
            value: _selectedRole,
            onChanged: (role) {
              if (role == null) return;
              setState(() => _selectedRole = UserRole.fromString(role));
            },
            validator: Validators.isNotEmpty,
          ),
        ],
      ),
    );
  }

  void _onCreateOrUpdate() {
    if (_isUpdate) {
      widget.onUpdate(
        widget.user!.copyWith(
          name: _nameController.text,
          email: _emailController.text,
          role: _selectedRole,
        ),
      );
    } else {
      widget.onCreate(
        UserModel(
          name: _nameController.text,
          email: _emailController.text,
          role: _selectedRole!,
        ),
        _passwordController.text,
      );
    }
  }
}
