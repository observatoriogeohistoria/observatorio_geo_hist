import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Item da navbar em linha (desktop). Ativo: texto laranja com sublinhado.
/// Quando abre um menu, informa "expandido" ou "recolhido" ao leitor de tela.
class NavbarItem extends StatefulWidget {
  const NavbarItem({
    super.key,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.hasMenu = false,
    this.isExpanded = false,
    this.focusNode,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  /// Mostra a seta e informa o estado de expansão.
  final bool hasMenu;
  final bool isExpanded;
  final FocusNode? focusNode;

  @override
  State<NavbarItem> createState() => _NavbarItemState();
}

class _NavbarItemState extends State<NavbarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r8);
    final highlighted = widget.isActive || _hovered || widget.isExpanded;
    final color = highlighted ? colors.accent : colors.ink;

    return Semantics(
      button: true,
      selected: widget.isActive,
      expanded: widget.hasMenu ? widget.isExpanded : null,
      label: widget.label,
      // Repete a ação do InkWell (excluído da semântica) para o leitor de tela ativar o item.
      onTap: widget.onTap,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: InkWell(
          focusNode: widget.focusNode,
          borderRadius: radius,
          onTap: widget.onTap,
          onHover: (value) => setState(() => _hovered = value),
          hoverColor: Colors.transparent,
          mouseCursor: SystemMouseCursors.click,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.s12 + 2, vertical: spacing.s8 + 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: AppTheme.typography.of(context).regular.copyWith(
                            fontSize: components.navItemText,
                            fontWeight: FontWeight.w600,
                            height: 1.55,
                            color: color,
                          ),
                    ),
                    if (widget.hasMenu) ...[
                      SizedBox(width: spacing.s4),
                      Icon(
                        widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: components.navIcon,
                        color: color,
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.isActive)
                Positioned(
                  left: spacing.s12 + 2,
                  right: spacing.s12 + 2,
                  bottom: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(AppTheme.dimensions.stroke.medium),
                    ),
                    child: SizedBox(height: AppTheme.dimensions.stroke.medium),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
