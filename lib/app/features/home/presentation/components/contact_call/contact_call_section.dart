import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Chamada para contato no fim da Home (spec 009, `.cta` do protótipo).
///
/// Quadro laranja suave com título, texto e "Fale com a gente". No desktop o
/// botão fica à direita; abaixo de 1024 px ou com texto ampliado a 130% ou
/// mais, fica abaixo do texto. Só tem respiro de seção embaixo.
class ContactCallSection extends StatelessWidget {
  const ContactCallSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final stacked = breakpoint != Breakpoint.desktop || textScaler.scale(1) >= components.ctaStackTextScale;

    final titleStyle = styles.ctaTitle.copyWith(color: colors.ink);

    final texts = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: textScaler.scale(titleStyle.fontSize!) * components.ctaTitleMaxWidthEm,
          ),
          child: Semantics(
            header: true,
            child: Text('Feito por e para professores, pesquisadores e estudantes.', style: titleStyle),
          ),
        ),
        SizedBox(height: components.ctaTextGap),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: textScaler.scale(components.ctaTextMaxWidth)),
          child: Text(
            'Envie suas contribuições, opiniões e sugestões e ajude a construir este espaço.',
            style: styles.regular.copyWith(color: colors.inkSecondary),
          ),
        ),
      ],
    );

    final button = PrimaryButton.medium(
      text: 'Fale com a gente',
      trailingIcon: Icons.arrow_forward,
      onPressed: () => GoRouter.of(context).go(AppRoutes.contact),
    );

    return PageContent(
      child: Padding(
        padding: EdgeInsets.only(bottom: components.sectionPaddingVertical(breakpoint)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(components.ctaPadding(breakpoint)),
          decoration: BoxDecoration(
            color: colors.accentSoft,
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r20),
          ),
          child: stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [texts, SizedBox(height: components.ctaButtonGap), button],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: texts),
                    SizedBox(width: components.ctaButtonGap),
                    button,
                  ],
                ),
        ),
      ),
    );
  }
}
