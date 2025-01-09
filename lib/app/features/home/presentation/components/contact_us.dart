import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colors.gray,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.2,
          vertical: AppTheme.dimensions.space.xlarge,
        ),
        child: Column(
          children: [
            Text(
              'O Observatório do Ensino de História e Geografia é criado por e para professores, pesquisadores e estudantes. Envie suas contribuições, opiniões e sugestões e nos ajude a construir este espaço.',
              textAlign: TextAlign.center,
              style: AppTheme.typography.body.large.copyWith(
                color: AppTheme.colors.white,
              ),
            ),
            SizedBox(height: AppTheme.dimensions.space.xlarge),
            PrimaryButton(
              text: 'FALE COM A GENTE',
              onPressed: () => GoRouter.of(context).go('/contact-us'),
            ),
          ],
        ),
      ),
    );
  }
}
