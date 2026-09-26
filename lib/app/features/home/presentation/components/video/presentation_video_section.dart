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

/// Seção do vídeo de apresentação da Home (spec 006).
///
/// Nada toca nem é baixado ao abrir a página: aparece a capa com "Assistir".
/// Ao ativar, o player é montado atrás da capa, no mesmo quadro; quando o
/// vídeo fica pronto, a capa sai e ele toca com som (ou fica pausado e pronto,
/// se o navegador não deixar tocar com som). Se falhar, a capa mostra a
/// mensagem de erro e "Tentar de novo".
class PresentationVideoSection extends StatefulWidget {
  const PresentationVideoSection({super.key});

  @override
  State<PresentationVideoSection> createState() => _PresentationVideoSectionState();
}

class _PresentationVideoSectionState extends State<PresentationVideoSection> {
  /// Código do player (pequeno). Começa a baixar já, para "Assistir" não esperar.
  late final Future<void> _playerLibrary = video_player.loadLibrary();

  _VideoState _state = _VideoState.cover;
  bool _playerMounted = false;

  /// Muda a cada tentativa, para "Tentar de novo" criar um player novo.
  int _attempt = 0;

  /// Foco do botão "Assistir". Se ele estava com o foco do teclado ao ser
  /// ativado, o foco segue para "Pausar vídeo" quando o player aparece; com
  /// clique do mouse, o foco fica onde está (sem contorno inesperado).
  final FocusNode _playButtonFocus = FocusNode(debugLabel: 'Assistir');
  bool _focusControls = false;

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
              final height = (width / components.videoAspectRatio(breakpoint)).clamp(0.0, components.videoMaxHeight);

              return ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r18),
                child: ConstrainedBox(
                  // Altura mínima, não fixa: com texto ampliado, o quadro cresce.
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

  /// Fundo escuro com o player centralizado: o vídeo aparece inteiro, com
  /// faixas escuras quando o quadro é mais largo que ele.
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
                shouldStartPlaying: hasUserActivation,
                autofocusControls: _focusControls,
                showControlsScrim: true,
              ),
            ),
    );
  }

  /// Capa por cima do player enquanto o vídeo não está tocando. Tocando, ela
  /// continua no layout (mantém a altura do quadro), invisível e sem toque.
  Widget _coverLayer(BuildContext context) {
    final playing = _state == _VideoState.playing;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final duration = reduceMotion ? Duration.zero : AppTheme.dimensions.components.videoAnimation;

    final Widget overlay = switch (_state) {
      _VideoState.cover || _VideoState.loading => VideoPlayButton(
          isLoading: _state == _VideoState.loading,
          focusNode: _playButtonFocus,
          onPressed: _watch,
        ),
      _VideoState.error => _ErrorBox(onRetry: _watch),
      _VideoState.playing => const SizedBox.shrink(),
    };

    return IgnorePointer(
      ignoring: playing,
      child: ExcludeSemantics(
        excluding: playing,
        child: AnimatedOpacity(
          opacity: playing ? 0 : 1,
          duration: duration,
          child: VideoCover(
            child: AnimatedSwitcher(duration: duration, child: overlay),
          ),
        ),
      ),
    );
  }
}

/// Caixa branca sobre a capa quando o vídeo não carrega.
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
