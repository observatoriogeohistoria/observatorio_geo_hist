import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/partners/partner_logo_grid.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Seção "Realização e apoio" (spec 009): título e grade de logos. A mesma na
/// Home, na Biblioteca e em Colabore.
///
/// Tem respiro de seção em cima e embaixo; na Home, a Equipe acima não soma
/// respiro próprio embaixo, para o espaço não sumir quando ela está escondida.
class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);

    return ColoredBox(
      color: AppTheme.colors.page,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: components.sectionPaddingVertical(breakpoint)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Realização e apoio',
                  style: AppTheme.typography.of(context).h2.copyWith(color: AppTheme.colors.ink),
                ),
              ),
              SizedBox(height: components.sectionHeadGap),
              const PartnerLogoGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
