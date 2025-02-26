import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme(context).colors.gray,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2,
          vertical: AppTheme(context).dimensions.space.xlarge,
        ),
        child: Column(
          children: [
            AppBody.big(
              text:
                  'O Observatório do Ensino de História e Geografia é criado por e para professores, pesquisadores e estudantes. Envie suas contribuições, opiniões e sugestões e nos ajude a construir este espaço.',
              textAlign: TextAlign.center,
              color: AppTheme(context).colors.white,
            ),
            SizedBox(height: AppTheme(context).dimensions.space.xlarge),
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
