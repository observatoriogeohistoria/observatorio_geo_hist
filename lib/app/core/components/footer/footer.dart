import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/social_buttons.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/components/logo/app_logo.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Rodapé escuro do site: marca, endereço e redes; links de navegação;
/// contato. 4 colunas no desktop, 2 no tablet e 1 no celular.
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = spacing.s32 + spacing.s4;

    final columns = [
      const _BrandColumn(),
      _LinksColumn(title: 'Explorar', links: [
        _FooterLinkData('Sobre', (context) => context.go(AppRoutes.root)),
        _FooterLinkData('Biblioteca', (context) => context.go(AppRoutes.library)),
      ]),
      _LinksColumn(title: 'Institucional', links: [
        _FooterLinkData('Manifesto', (context) => context.go('/manifest')),
        _FooterLinkData('Nossa história', (context) => context.go(AppRoutes.ourHistory)),
        _FooterLinkData('Equipe', (context) => context.go(AppRoutes.root)),
        _FooterLinkData('Fale com a gente', (context) => context.go('/contato')),
      ]),
      _LinksColumn(title: 'Contato', links: [
        _FooterLinkData(AppStrings.email, (_) => openUrl(AppStrings.emailUrl, sameTab: true)),
        _FooterLinkData(AppStrings.phoneOne, (_) => openUrl(AppStrings.phoneOneUrl, sameTab: true)),
        _FooterLinkData(AppStrings.phoneTwo, (_) => openUrl(AppStrings.phoneTwoUrl, sameTab: true)),
      ]),
    ];

    final Widget grid = switch (breakpoint) {
      Breakpoint.desktop => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Explorar e Institucional ocupam só a largura dos links; marca e
            // contato dividem o resto, para o endereço e o e-mail não quebrarem.
            Expanded(flex: 4, child: columns[0]),
            SizedBox(width: gap),
            columns[1],
            SizedBox(width: gap),
            columns[2],
            SizedBox(width: gap),
            Expanded(flex: 3, child: columns[3]),
          ],
        ),
      // Sem LayoutBuilder: páginas que prendem o rodapé na base medem a altura intrínseca dele.
      Breakpoint.tablet => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < columns.length; i += 2) ...[
              if (i > 0) SizedBox(height: gap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: columns[i]),
                  SizedBox(width: gap),
                  Expanded(child: columns[i + 1]),
                ],
              ),
            ],
          ],
        ),
      Breakpoint.mobile => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final column in columns) ...[
              column,
              if (column != columns.last) SizedBox(height: gap),
            ],
          ],
        ),
    };

    final bottomStyle = styles.small.copyWith(color: colors.footerText);

    return ColoredBox(
      color: colors.footerBackground,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.only(top: spacing.s48 + spacing.s8, bottom: spacing.s24 + spacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              grid,
              SizedBox(height: spacing.s40),
              Divider(height: 1, thickness: 1, color: colors.footerLine),
              SizedBox(height: spacing.s20),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: spacing.s12,
                runSpacing: spacing.s8,
                children: [
                  Text(
                    '© ${DateTime.now().year} Observatório do Ensino de História e Geografia',
                    style: bottomStyle,
                  ),
                  Text(AppStrings.footerLicense, style: bottomStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandColumn extends StatelessWidget {
  const _BrandColumn();

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLogo(onDark: true),
        SizedBox(height: spacing.s16),
        Text(
          AppStrings.footerAddress,
          style: AppTheme.typography.of(context).small.copyWith(
                color: AppTheme.colors.footerText,
                height: 1.7,
              ),
        ),
        SizedBox(height: spacing.s20),
        const SocialButtons(onDark: true),
      ],
    );
  }
}

class _FooterLinkData {
  const _FooterLinkData(this.label, this.onTap);

  final String label;
  final void Function(BuildContext context) onTap;
}

class _LinksColumn extends StatelessWidget {
  const _LinksColumn({required this.title, required this.links});

  final String title;
  final List<_FooterLinkData> links;

  @override
  Widget build(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title.toUpperCase(),
            style: AppTheme.typography.of(context).label.copyWith(color: AppTheme.colors.white),
          ),
        ),
        SizedBox(height: spacing.s12),
        for (final link in links) _FooterLink(label: link.label, onTap: () => link.onTap(context)),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r6);

    return Semantics(
      link: true,
      label: widget.label,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        color: colors.footerHighlight,
        child: InkWell(
          borderRadius: radius,
          onTap: widget.onTap,
          onHover: (value) => setState(() => _hovered = value),
          hoverColor: Colors.transparent,
          mouseCursor: SystemMouseCursors.click,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: AppTheme.dimensions.components.minTapTarget - spacing.s8),
            child: Align(
              alignment: Alignment.centerLeft,
              widthFactor: 1,
              child: Text(
                widget.label,
                style: AppTheme.typography.of(context).small.copyWith(
                      color: _hovered ? colors.footerHighlight : colors.footerText,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
