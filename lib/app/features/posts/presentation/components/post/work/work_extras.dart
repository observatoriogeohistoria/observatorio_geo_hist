import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/posts/presentation/components/post/work/work_info.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Não é um player: o link leva a outro site (Spotify, YouTube…), e uma barra de
/// progresso prometeria algo que a página não toca.
class WorkListenButton extends StatefulWidget {
  const WorkListenButton({super.key, required this.listen, required this.title});

  final WorkListen listen;
  final String title;

  @override
  State<WorkListenButton> createState() => _WorkListenButtonState();
}

class _WorkListenButtonState extends State<WorkListenButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.r14);
    final listen = widget.listen;
    void open() => openUrl(listen.url);

    return Semantics(
      button: true,
      label: 'Ouvir ${widget.title} em outra aba',
      onTap: open,
      excludeSemantics: true,
      child: AppFocusRing(
        borderRadius: radius,
        child: Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: _hovered ? colors.lineStrong : colors.line,
              width: AppTheme.dimensions.stroke.small,
            ),
          ),
          child: InkWell(
            onTap: open,
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: radius,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: components.workListenPaddingH,
                vertical: components.workListenPaddingV,
              ),
              child: Row(
                children: [
                  Container(
                    width: components.workListenPlay,
                    height: components.workListenPlay,
                    decoration: BoxDecoration(
                      color: _hovered ? colors.accentStrong : colors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: components.workListenPlayIcon,
                      color: colors.white,
                    ),
                  ),
                  SizedBox(width: components.workListenGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listen.label,
                            style: styles.workListenTitle.copyWith(color: colors.ink)),
                        if (listen.host.isNotEmpty)
                          Text(
                            listen.host,
                            style: styles.workListenHost.copyWith(color: colors.inkSecondary),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: components.workListenGap),
                  Icon(
                    Icons.open_in_new,
                    size: components.workListenIcon,
                    color: colors.inkSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
