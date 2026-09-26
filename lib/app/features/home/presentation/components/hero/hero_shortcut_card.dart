import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Disposição do cartão de atalho: em linha (ícone, textos, seta) ou com o
/// ícone acima do título e da descrição (tablet).
enum HeroShortcutLayout { horizontal, vertical }

/// Cartão de atalho do hero (História, Geografia, Biblioteca).
///
/// No hover ganha borda laranja, sobe 2 px e ganha sombra suave; com
/// movimento reduzido, só muda borda e sombra, sem subida nem transição.
/// Ícone e seta são decorativos: o leitor de tela lê o [semanticLabel].
class HeroShortcutCard extends StatefulWidget {
  const HeroShortcutCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.semanticLabel,
    required this.onTap,
    this.isLink = false,
    this.layout = HeroShortcutLayout.horizontal,
    this.focusNode,
  });

  final IconData icon;
  final String title;
  final String description;

  /// Nome acessível completo (título, descrição e o que acontece ao ativar).
  final String semanticLabel;
  final VoidCallback onTap;

  /// Leva a outra página (lido como link); senão, é um botão.
  final bool isLink;
  final HeroShortcutLayout layout;

  /// Para devolver o foco ao cartão depois de fechar uma janela aberta por ele.
  final FocusNode? focusNode;

  @override
  State<HeroShortcutCard> createState() => _HeroShortcutCardState();
}

class _HeroShortcutCardState extends State<HeroShortcutCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r14);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final lift = _hovered && !reduceMotion ? components.shortcutHoverLift : 0.0;

    return Semantics(
      button: !widget.isLink,
      link: widget.isLink,
      label: widget.semanticLabel,
      // Repete a ação do InkWell (excluído da semântica) para o leitor de tela ativar o cartão.
      onTap: widget.onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        // Mantém a altura imposta pela linha de cartões (todos da mesma altura).
        fit: StackFit.passthrough,
        child: AnimatedContainer(
          duration: reduceMotion ? Duration.zero : components.shortcutAnimation,
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, -lift, 0),
          decoration: BoxDecoration(
            color: colors.page,
            borderRadius: radius,
            border: Border.all(
              color: _hovered ? colors.accent : colors.line,
              width: AppTheme.dimensions.stroke.small,
            ),
            boxShadow: _hovered ? AppTheme.dimensions.shadows.soft : null,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              focusNode: widget.focusNode,
              borderRadius: radius,
              onTap: widget.onTap,
              onHover: (value) => setState(() => _hovered = value),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              mouseCursor: SystemMouseCursors.click,
              child: Padding(
                padding: EdgeInsets.all(spacing.s20),
                child: switch (widget.layout) {
                  HeroShortcutLayout.horizontal => _horizontal(context),
                  HeroShortcutLayout.vertical => _vertical(context),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _horizontal(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;

    return Row(
      children: [
        _IconBox(icon: widget.icon),
        SizedBox(width: spacing.s16),
        Expanded(child: _Texts(title: widget.title, description: widget.description)),
        SizedBox(width: spacing.s12),
        const _Arrow(),
      ],
    );
  }

  Widget _vertical(BuildContext context) {
    final spacing = AppTheme.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconBox(icon: widget.icon),
        SizedBox(height: spacing.s16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _Title(widget.title)),
            SizedBox(width: spacing.s8),
            const _Arrow(),
          ],
        ),
        SizedBox(height: spacing.s4),
        _Description(widget.description),
      ],
    );
  }
}

/// Quadro laranja suave com o ícone da área.
class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return Container(
      width: components.shortcutIconBox,
      height: components.shortcutIconBox,
      decoration: BoxDecoration(
        color: colors.accentSoft,
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: components.shortcutIcon, color: colors.accent),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Title(title),
        SizedBox(height: AppTheme.dimensions.spacing.s4),
        _Description(description),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTheme.typography.of(context).h3.copyWith(color: AppTheme.colors.ink));
  }
}

class _Description extends StatelessWidget {
  const _Description(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTheme.typography.of(context).small.copyWith(color: AppTheme.colors.inkSecondary));
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward,
      size: AppTheme.dimensions.components.navIcon,
      color: AppTheme.colors.inkSecondary,
    );
  }
}
