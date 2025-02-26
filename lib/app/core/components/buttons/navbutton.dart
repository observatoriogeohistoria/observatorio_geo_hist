import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/navbar_menu.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class NavButton extends StatefulWidget {
  const NavButton({
    required this.text,
    required this.onPressed,
    required this.menuChildren,
    this.textStyle,
    this.textColor,
    this.textColorOnHover,
    super.key,
  });

  final String text;
  final Function()? onPressed;
  final List<NavButton>? menuChildren;

  final TextStyle? textStyle;
  final Color? textColor;
  final Color? textColorOnHover;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  final controller = WidgetStatesController();

  bool get hasMenu => (widget.menuChildren?.isNotEmpty ?? false);

  void showMenus(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Menu',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return NavbarMenu(
          title: widget.text,
          menuChildren: widget.menuChildren!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppTheme.dimensions.space.small),
      child: TextButton(
        statesController: controller,
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(
            !hasMenu ? Colors.transparent : AppTheme.colors.gray.withValues(alpha: 0.1),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
            ),
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.hovered)
                ? widget.textColorOnHover ?? AppTheme.colors.orange
                : widget.textColor ?? AppTheme.colors.darkGray,
          ),
          textStyle: WidgetStateProperty.resolveWith(
            (states) => (widget.textStyle ?? AppTheme(context).typography.title.medium).copyWith(
              color: states.contains(WidgetState.hovered)
                  ? widget.textColorOnHover ?? AppTheme.colors.orange
                  : widget.textColor ?? AppTheme.colors.darkGray,
            ),
          ),
        ),
        onPressed: () {
          hasMenu ? showMenus(context) : widget.onPressed?.call();
        },
        child: Text(widget.text),
      ),
    );
  }
}
