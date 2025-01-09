import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class NavButton extends StatefulWidget {
  const NavButton({
    required this.text,
    required this.onPressed,
    required this.menuChildren,
    super.key,
  });

  final String text;
  final Function()? onPressed;
  final List<NavButton>? menuChildren;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  WidgetStatesController controller = WidgetStatesController();
  GlobalKey menuKey = GlobalKey();

  bool isMenuVisible = false;
  bool hasMenu() => (widget.menuChildren?.isNotEmpty ?? false);

  void showMenus(BuildContext context) async {
    final render = menuKey.currentContext!.findRenderObject() as RenderBox;

    setState(() => isMenuVisible = true);

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        render.localToGlobal(Offset.zero).dx,
        render.localToGlobal(Offset.zero).dy + 50,
        double.infinity,
        double.infinity,
      ),
      items: widget.menuChildren!.map((e) {
        return PopupMenuItem(child: e);
      }).toList(),
    ).then((value) {
      setState(() => isMenuVisible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: menuKey,
      padding: EdgeInsets.all(AppTheme.dimensions.space.small),
      child: Row(
        children: [
          TextButton(
            statesController: controller,
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(
                !hasMenu() ? Colors.transparent : AppTheme.colors.gray.withValues(alpha: 0.1),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.small),
                ),
              ),
              foregroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.hovered)
                    ? AppTheme.colors.orange
                    : AppTheme.colors.black,
              ),
            ),
            onPressed: () {
              hasMenu() ? showMenus(context) : widget.onPressed?.call();
            },
            child: Text(widget.text),
          ),
          if (hasMenu())
            Icon(
              isMenuVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: AppTheme.colors.black,
            ),
        ],
      ),
    );
  }
}
