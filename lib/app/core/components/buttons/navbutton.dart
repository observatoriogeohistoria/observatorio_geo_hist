import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/overlay/navbar_overlay_entry.dart';
import 'package:observatorio_geo_hist/app/core/utils/models/navbutton_item.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class NavButton extends StatefulWidget {
  const NavButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.options,
  });

  final String text;
  final VoidCallback onPressed;
  final List<NavButtonItem>? options;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  final controller = WidgetStatesController();
  final GlobalKey _buttonKey = GlobalKey();

  OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context) {
    final renderBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

    overlayEntry = navbarOverlayEntry(
      buttonPosition: buttonPosition,
      buttonSize: buttonSize,
      options: widget.options ?? [],
      removeOverlay: removeOverlay,
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.dimensions.space.small),
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, states, _) {
          return ElevatedButton(
            key: _buttonKey,
            statesController: controller,
            onPressed: () {},
            onHover: (value) {
              if (widget.options?.isEmpty ?? true) return;
              value ? showOverlay(context) : removeOverlay();
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppTheme.colors.white),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.dimensions.radius.medium),
                ),
              ),
            ),
            child: Text(
              widget.text,
              style: AppTheme.typography.headline.medium,
            ),
          );
        },
      ),
    );
  }
}
