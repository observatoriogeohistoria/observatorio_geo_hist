import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/video_player/app_video_player.dart'
    deferred as video_player;
import 'package:observatorio_geo_hist/app/core/utils/browser/user_activation.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/video/video_cover.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/video/video_play_button.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

enum _VideoState { cover, loading, playing, error }

/// Nada é baixado ao abrir a página: o player só é montado depois de "Assistir".
class PresentationVideoSection extends StatefulWidget {
  const PresentationVideoSection({super.key});

  @override
  State<PresentationVideoSection> createState() => _PresentationVideoSectionState();
}

class _PresentationVideoSectionState extends State<PresentationVideoSection> {
  /// O código do player começa a baixar já, para "Assistir" não esperar.
  late final Future<void> _playerLibrary = video_player.loadLibrary();

  _VideoState _state = _VideoState.cover;
  bool _playerMounted = false;

  /// Muda a cada tentativa, para "Tentar de novo" criar um player novo.
  int _attempt = 0;

  /// Se "Assistir" foi ativado pelo teclado, o foco segue para os controles do player.
  final FocusNode _playButtonFocus = FocusNode(debugLabel: 'Assistir');
  bool _focusControls = false;

  /// O navegador recusou tocar sozinho: o player volta pausado, esperando um clique.
  bool _autoplayBlocked = false;

  @override
  void initState() {
    super.initState();
    // Erro no código do player só importa depois de "Assistir".
    _playerLibrary.ignore();
  }

  @override
  void dispose() {
    _playButtonFocus.dispose();
    super.dispose();
  }

  Future<void> _watch() async {
    setState(() {
      _focusControls = _playButtonFocus.hasFocus;
      _autoplayBlocked = false;
      _state = _VideoState.loading;
      _attempt++;
    });

    try {
      await _playerLibrary;
    } catch (_) {
      _handleError();
      return;
    }
    if (!mounted || _state != _VideoState.loading) return;
    setState(() => _playerMounted = true);
  }

  void _handleReady() {
    if (!mounted || _state != _VideoState.loading) return;
    setState(() => _state = _VideoState.playing);
  }

  void _handleAutoplayBlocked() {
    if (!mounted) return;
    setState(() {
      _autoplayBlocked = true;
      _attempt++;
    });
  }

  void _handleError() {
    if (!mounted) return;
    setState(() {
      _state = _VideoState.error;
      _playerMounted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);

    return ColoredBox(
      color: AppTheme.colors.page,
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: components.sectionPaddingVertical(breakpoint)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = (width / components.videoAspectRatio(breakpoint))
                  .clamp(0.0, components.videoMaxHeight);

              return ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: width, maxWidth: width, minHeight: height),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Positioned.fill(child: _playerLayer()),
                      _coverLayer(context),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _playerLayer() {
    return ColoredBox(
      color: AppTheme.colors.videoBackdrop,
      child: !_playerMounted
          ? const SizedBox.shrink()
          : Center(
              child: video_player.AppVideoPlayer(
                key: ValueKey(_attempt),
                url: AppStrings.presentationVideoUrl,
                loadingPlaceholder: const SizedBox.shrink(),
                onInitialized: _handleReady,
                onError: _handleError,
                onAutoplayBlocked: _handleAutoplayBlocked,
                shouldStartPlaying: _autoplayBlocked ? null : hasUserActivation,
                autofocusControls: _focusControls,
                showControlsScrim: true,
              ),
            ),
    );
  }

  Widget _coverLayer(BuildContext context) {
    final playing = _state == _VideoState.playing;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : AppTheme.dimensions.components.videoAnimation;

    final Widget action = switch (_state) {
      _VideoState.cover || _VideoState.loading => VideoPlayButton(
          isLoading: _state == _VideoState.loading,
          focusNode: _playButtonFocus,
          onPressed: _watch,
        ),
      _VideoState.error || _VideoState.playing => const SizedBox.shrink(),
    };
    final Widget centered =
        _state == _VideoState.error ? _ErrorBox(onRetry: _watch) : const SizedBox.shrink();

    return IgnorePointer(
      ignoring: playing,
      child: ExcludeSemantics(
        excluding: playing,
        child: AnimatedOpacity(
          opacity: playing ? 0 : 1,
          duration: duration,
          child: VideoCover(
            action: AnimatedSwitcher(duration: duration, child: action),
            child: AnimatedSwitcher(duration: duration, child: centered),
          ),
        ),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final spacing = AppTheme.dimensions.spacing;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: AppTheme.dimensions.components.videoErrorMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r14),
          boxShadow: AppTheme.dimensions.shadows.elevated,
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.s20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                liveRegion: true,
                child: Text(
                  'Não foi possível carregar o vídeo.',
                  textAlign: TextAlign.center,
                  style: AppTheme.typography.of(context).regular.copyWith(color: colors.ink),
                ),
              ),
              SizedBox(height: spacing.s12),
              SecondaryButton.small(text: 'Tentar de novo', onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
