import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/navbar_sub_menu.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/transitions/transitions_builder.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class NavButton extends StatefulWidget {
  const NavButton({
    required this.text,
    required this.onPressed,
    required this.menuChildren,
    this.backgroundColor,
    this.textStyle,
    this.textColor,
    this.textColorOnHover,
    super.key,
  });

  final String text;
  final Function()? onPressed;
  final List<NavButton>? menuChildren;

  final Color? backgroundColor;

  final TextStyle? textStyle;
  final Color? textColor;
  final Color? textColorOnHover;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  final _controller = WidgetStatesController();

  bool get _hasMenu => (widget.menuChildren?.isNotEmpty ?? false);

  void showSubMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Sub Menu',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: TransitionsBuilder.slide,
      pageBuilder: (context, animation, secondaryAnimation) {
        return NavbarSubMenu(
          title: widget.text,
          menuChildren: widget.menuChildren!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: _controller,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.all(AppTheme.dimensions.space.medium.scale),
        ),
        overlayColor: WidgetStateProperty.all(
          !_hasMenu ? Colors.transparent : AppTheme.colors.gray.withValues(alpha: 0.1),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => widget.backgroundColor,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) {
            return states.contains(WidgetState.hovered)
                ? widget.textColorOnHover ?? AppTheme.colors.orange
                : widget.textColor ?? AppTheme.colors.darkGray;
          },
        ),
        textStyle: WidgetStateProperty.resolveWith(
          (states) {
            return (widget.textStyle ??
                    (ScreenUtils.isSmallDesktop(context)
                        ? AppTheme.typography.title.small
                        : AppTheme.typography.title.medium))
                .copyWith(
              color: states.contains(WidgetState.hovered)
                  ? widget.textColorOnHover ?? AppTheme.colors.orange
                  : widget.textColor ?? AppTheme.colors.darkGray,
              fontWeight: FontWeight.w700,
            );
          },
        ),
      ),
      onPressed: () {
        widget.onPressed?.call();
        if (_hasMenu) showSubMenu(context);
      },
      child: Text(widget.text),
    );
  }
}
