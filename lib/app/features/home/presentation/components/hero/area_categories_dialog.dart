import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar_categories_menu.dart';
import 'package:observatorio_geo_hist/app/core/stores/fetch_categories_store.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/posts_areas.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Quem chama devolve o foco ao elemento que abriu a janela quando o `Future` termina.
Future<void> showAreaCategoriesDialog(
  BuildContext context, {
  required PostsAreas area,
  required FetchCategoriesStore store,
}) {
  final components = AppTheme.dimensions.components;
  final duration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : components.menuAnimation;

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Fechar',
    barrierColor: AppTheme.colors.ink.withValues(alpha: components.scrimOpacity),
    transitionDuration: duration,
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return AreaCategoriesDialog(area: area, store: store);
    },
  );
}

class AreaCategoriesDialog extends StatelessWidget {
  const AreaCategoriesDialog({super.key, required this.area, required this.store});

  final PostsAreas area;
  final FetchCategoriesStore store;

  String get title => 'Categorias de ${area.portuguese}';

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;
    final components = AppTheme.dimensions.components;
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r16);

    void close() => Navigator.of(context).pop();

    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): close},
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(spacing.s16),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: components.categoriesDialogMaxWidth),
              child: Semantics(
                role: SemanticsRole.dialog,
                scopesRoute: true,
                namesRoute: true,
                explicitChildNodes: true,
                label: title,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.page,
                    borderRadius: radius,
                    boxShadow: AppTheme.dimensions.shadows.elevated,
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(spacing.s20, spacing.s12, spacing.s8, spacing.s12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Semantics(
                                  header: true,
                                  child: Text(title, style: AppTheme.typography.of(context).h3),
                                ),
                              ),
                              SizedBox(width: spacing.s8),
                              AppIconButton(
                                tooltip: 'Fechar',
                                icon: Icons.close,
                                color: colors.ink,
                                size: components.menuIconSize,
                                onPressed: close,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: AppTheme.dimensions.stroke.small,
                          thickness: AppTheme.dimensions.stroke.small,
                          color: colors.line,
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(spacing.s8),
                            child: NavbarCategoriesMenu(area: area, store: store, onSelected: close),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
