import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/validators/validators.dart';
import 'package:observatorio_geo_hist/app/features/home/infra/models/team_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showCreateOrUpdateTeamMemberDialog(
  BuildContext context, {
  required void Function(TeamMemberModel member) onCreateOrUpdate,
  TeamMemberModel? member,
}) {
  showDialog(
    context: context,
    builder: (_) => CreateOrUpdateTeamMemberDialog(
      onCreateOrUpdate: onCreateOrUpdate,
      member: member,
    ),
  );
}

class CreateOrUpdateTeamMemberDialog extends StatefulWidget {
  const CreateOrUpdateTeamMemberDialog({
    required this.onCreateOrUpdate,
    this.member,
    super.key,
  });

  final void Function(TeamMemberModel member) onCreateOrUpdate;
  final TeamMemberModel? member;

  @override
  State<CreateOrUpdateTeamMemberDialog> createState() => _CreateOrUpdateTeamMemberDialogState();
}

class _CreateOrUpdateTeamMemberDialogState extends State<CreateOrUpdateTeamMemberDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _nameController = TextEditingController(text: widget.member?.name);
  late final _roleController = TextEditingController(text: widget.member?.role.toString());
  late final _lattesUrlController = TextEditingController(text: widget.member?.lattesUrl);
  late final _descriptionController = TextEditingController(text: widget.member?.description);

  bool get _isUpdate => widget.member != null;

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
              text: _isUpdate ? 'Atualizar membro' : 'Criar membro',
              color: AppTheme.colors.orange,
            ),
            SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
            AppTextField(
              controller: _nameController,
              labelText: 'Nome',
              validator: Validators.isNotEmpty,
            ),
            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
            AppTextField(
              controller: _roleController,
              labelText: 'Papel',
              validator: Validators.isNotEmpty,
            ),
            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
            AppTextField(
              controller: _lattesUrlController,
              labelText: 'URL do Lattes',
              validator: Validators.isValidUrlOrEmpty,
            ),
            SizedBox(height: AppTheme.dimensions.space.medium.verticalSpacing),
            AppTextField(
              controller: _descriptionController,
              labelText: 'Descrição',
              minLines: 10,
              maxLines: 10,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton.medium(
                  text: 'Cancelar',
                  onPressed: () => GoRouter.of(context).pop(),
                ),
                SizedBox(width: AppTheme.dimensions.space.medium.horizontalSpacing),
                PrimaryButton.medium(
                  text: _isUpdate ? 'Atualizar' : 'Criar',
                  onPressed: _onCreateOrUpdate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCreateOrUpdate() {
    if (!_formKey.currentState!.validate()) return;

    widget.onCreateOrUpdate(
      TeamMemberModel(
        id: widget.member?.id,
        name: _nameController.text,
        role: _roleController.text,
        lattesUrl: _lattesUrlController.text,
        description: _descriptionController.text,
      ),
    );

    GoRouter.of(context).pop();
  }
}
