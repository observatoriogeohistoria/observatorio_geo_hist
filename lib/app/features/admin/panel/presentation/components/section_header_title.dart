import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
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
        right: AppTheme.dimensions.space.medium.horizontalSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppHeadline.big(
            text: title,
            color: AppTheme.colors.orange,
          ),
          if (canEdit) ...[
            SizedBox(width: AppTheme.dimensions.space.small.verticalSpacing),
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
