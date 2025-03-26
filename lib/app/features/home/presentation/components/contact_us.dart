import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = DeviceUtils.isTablet(context);
    bool isDesktop = DeviceUtils.isDesktop(context);

    return Container(
      color: AppTheme.colors.gray,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (isDesktop
                  ? (2 * AppTheme.dimensions.space.gigantic)
                  : (isTablet
                      ? AppTheme.dimensions.space.gigantic
                      : AppTheme.dimensions.space.large))
              .horizontalSpacing,
          vertical: AppTheme.dimensions.space.massive.verticalSpacing,
        ),
        child: Column(
          children: [
            AppBody.big(
              text:
                  'O Observatório do Ensino de História e Geografia é criado por e para professores, pesquisadores e estudantes. Envie suas contribuições, opiniões e sugestões e nos ajude a construir este espaço.',
              textAlign: TextAlign.center,
              color: AppTheme.colors.white,
            ),
            SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
            PrimaryButton.medium(
              text: 'FALE COM A GENTE',
              onPressed: () => GoRouter.of(context).go('/contact-us'),
            ),
          ],
        ),
      ),
    );
  }
}
