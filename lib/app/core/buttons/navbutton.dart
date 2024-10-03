import 'package:flutter/material.dart';
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
  final List<String>? options;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  final controller = WidgetStatesController();
  final GlobalKey _buttonKey = GlobalKey(); // Global key for button position

  OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context) {
    final renderBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: buttonPosition.dy + buttonSize.height,
        left: buttonPosition.dx,
        child: Material(
          elevation: 4,
          child: Container(
              width: 200,
              color: Colors.deepOrange,
              child: Column(
                children: [
                  for (final option in widget.options!)
                    ListTile(
                      title: Text(option),
                      onTap: () {
                        widget.onPressed();
                        removeOverlay();
                      },
                    ),
                ],
              )),
        ),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, states, _) {
          return ElevatedButton(
            key: _buttonKey,
            statesController: controller,
            onPressed: () => showOverlay(context),
            onHover: (value) {
              if (widget.options?.isEmpty ?? true) return;
              value ? showOverlay(context) : removeOverlay();
            },
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
