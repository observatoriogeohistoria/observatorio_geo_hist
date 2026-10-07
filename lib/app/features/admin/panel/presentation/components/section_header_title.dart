import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SectionHeaderTitle extends StatelessWidget {
  const SectionHeaderTitle({
    required this.title,
    required this.onCreate,
    required this.canEdit,
    required this.isLoading,
    super.key,
  });

  final String title;

  final void Function() onCreate;

  final bool canEdit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: AppTheme.dimensions.spacing.s16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              title,
              style: AppTheme.typography.of(context).h2.copyWith(color: AppTheme.colors.accent),
            ),
          ),
          if (canEdit) ...[
            SizedBox(width: AppTheme.dimensions.spacing.s8),
            SecondaryButton.medium(
              text: 'Criar',
              onPressed: onCreate,
              isDisabled: isLoading,
            ),
          ],
        ],
      ),
    );
  }
}
