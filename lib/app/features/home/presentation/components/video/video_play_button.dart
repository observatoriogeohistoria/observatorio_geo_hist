import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/focus/app_focus_ring.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class VideoPlayButton extends StatefulWidget {
  const VideoPlayButton(
      {super.key, required this.onPressed, this.isLoading = false, this.focusNode});

  final VoidCallback onPressed;
  final bool isLoading;

  final FocusNode? focusNode;

  @override
  State<VideoPlayButton> createState() => _VideoPlayButtonState();
}

class _VideoPlayButtonState extends State<VideoPlayButton> {
  bool _hovered = false;

  void _handleTap() {
    if (!widget.isLoading) widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final mobile = ScreenUtils.breakpointOf(context) == Breakpoint.mobile;
    final circle = mobile ? components.videoPlayCircleMobile : components.videoPlayCircle;
    final padding = mobile ? components.videoPlayPaddingMobile : components.videoPlayPadding;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final radius = BorderRadius.circular(AppTheme.dimensions.radii.pill);
    final grow = _hovered && !widget.isLoading && !reduceMotion;
    final text = widget.isLoading ? 'Carregando vídeo' : 'Assistir';
    final textStyle = AppTheme.typography.of(context).regular.copyWith(
          fontWeight: FontWeight.w700,
          color: colors.ink,
        );

    return Semantics(
      button: !widget.isLoading,
      label: widget.isLoading ? text : 'Reproduzir vídeo de apresentação',
      liveRegion: widget.isLoading,
      onTap: widget.isLoading ? null : widget.onPressed,
      excludeSemantics: true,
      child: AnimatedScale(
        scale: grow ? components.videoPlayHoverScale : 1,
        duration: reduceMotion ? Duration.zero : components.videoAnimation,
        child: AppFocusRing(
          borderRadius: radius,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: radius, boxShadow: AppTheme.dimensions.shadows.elevated),
            child: Material(
              color: colors.white,
              borderRadius: radius,
              child: InkWell(
                onTap: _handleTap,
                focusNode: widget.focusNode,
                onHover: (value) => setState(() => _hovered = value),
                borderRadius: radius,
                splashFactory: NoSplash.splashFactory,
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                mouseCursor:
                    widget.isLoading ? SystemMouseCursors.progress : SystemMouseCursors.click,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    padding,
                    padding,
                    mobile ? components.videoPlayPaddingEndMobile : components.videoPlayPaddingEnd,
                    padding,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: circle,
                        height: circle,
                        decoration: BoxDecoration(color: colors.accent, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: _CircleContent(
                            isLoading: widget.isLoading,
                            reduceMotion: reduceMotion,
                            mobile: mobile),
                      ),
                      SizedBox(
                          width: mobile ? components.videoPlayGapMobile : components.videoPlayGap),
                      Flexible(child: Text(text, style: textStyle)),
                    ],
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

class _CircleContent extends StatelessWidget {
  const _CircleContent({required this.isLoading, required this.reduceMotion, required this.mobile});

  final bool isLoading;
  final bool reduceMotion;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    if (!isLoading) {
      return Icon(
        Icons.play_arrow_rounded,
        size: mobile ? components.videoPlayIconMobile : components.videoPlayIcon,
        color: colors.white,
      );
    }
    if (reduceMotion) {
      return Icon(Icons.schedule, size: components.videoLoadingIndicator, color: colors.white);
    }
    return SizedBox.square(
      dimension: components.videoLoadingIndicator,
      child: CircularProgressIndicator(
        strokeWidth: AppTheme.dimensions.stroke.large,
        valueColor: AlwaysStoppedAnimation(colors.white),
      ),
    );
  }
}
