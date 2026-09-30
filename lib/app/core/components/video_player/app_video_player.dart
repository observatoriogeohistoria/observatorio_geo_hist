import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/app_icon_button.dart';
import 'package:observatorio_geo_hist/app/core/components/loading_content/loading_content.dart';
import 'package:observatorio_geo_hist/app/core/components/mouse_region/app_mouse_region.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({
    required this.url,
    this.padding = EdgeInsets.zero,
    this.startPlaying = false,
    this.startMuted = false,
    this.onInitialized,
    this.onError,
    this.loadingPlaceholder,
    this.shouldStartPlaying,
    this.onAutoplayBlocked,
    this.autofocusControls = false,
    this.showControlsScrim = false,
    super.key,
  });

  final String url;
  final EdgeInsets padding;

  final bool startPlaying;
  final bool startMuted;

  // Ajustes opcionais (spec 006). Sem eles, o player funciona como sempre.

  /// Chamado quando o vídeo fica pronto para tocar.
  final VoidCallback? onInitialized;

  /// Chamado se o vídeo não carregar ou der erro durante a reprodução. Quando
  /// informado, o player também acompanha o estado real do vídeo (por
  /// exemplo, mostra "Reproduzir vídeo" quando ele termina).
  final VoidCallback? onError;

  /// Mostrado no lugar do indicador de carregamento padrão.
  final Widget? loadingPlaceholder;

  /// Avaliada quando o vídeo fica pronto: se devolver `true`, começa a tocar;
  /// senão, fica pausado e pronto.
  final bool Function()? shouldStartPlaying;

  /// Chamado, no lugar de [onError], se o navegador recusar o início
  /// automático pedido por [shouldStartPlaying] (por exemplo, som bloqueado).
  /// O controller fica inutilizável depois disso: quem usa deve montar um
  /// player novo, sem início automático.
  final VoidCallback? onAutoplayBlocked;

  /// Leva o foco do teclado ao botão de reproduzir/pausar quando o vídeo fica pronto.
  final bool autofocusControls;

  /// Desenha um véu escuro atrás dos controles, para ficarem legíveis sobre
  /// qualquer imagem.
  final bool showControlsScrim;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isLoading = true;
  bool _isPlaying = false;
  bool _isMuted = false;

  bool _error = false;

  final FocusNode _playPauseFocus = FocusNode(debugLabel: 'Reproduzir ou pausar vídeo');

  /// Só acompanha o estado do controller quando quem usa quer saber de erros.
  bool get _followsController => widget.onError != null || widget.onAutoplayBlocked != null;

  /// O início automático foi pedido e o vídeo ainda não avançou: um erro
  /// nesse intervalo é o navegador recusando a reprodução.
  bool _autoStartPending = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    if (_followsController) _controller.addListener(_handleControllerChange);

    if (widget.startPlaying) _togglePlayPause();
    if (widget.startMuted) _toggleMute();

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _handleInitialized();
    }).catchError((error) {
      if (!mounted) return;
      _handleError();
    });
  }

  @override
  void dispose() {
    if (_followsController) _controller.removeListener(_handleControllerChange);
    _controller.dispose();
    _playPauseFocus.dispose();
    super.dispose();
  }

  void _handleInitialized() {
    if (!_isPlaying && (widget.shouldStartPlaying?.call() ?? false)) {
      _autoStartPending = true;
      _togglePlayPause();
    }
    widget.onInitialized?.call();

    if (widget.autofocusControls) {
      // Depois do quadro, quando os controles já estão na tela.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _playPauseFocus.requestFocus();
      });
    }
  }

  void _handleError() {
    if (_error) return;
    setState(() => _error = true);
    widget.onError?.call();
  }

  void _handleControllerChange() {
    if (!mounted) return;
    final value = _controller.value;

    if (value.hasError) {
      if (_autoStartPending && widget.onAutoplayBlocked != null) {
        _autoStartPending = false;
        setState(() => _error = true);
        widget.onAutoplayBlocked!();
        return;
      }
      _handleError();
      return;
    }
    if (_autoStartPending && value.position > Duration.zero) _autoStartPending = false;
    if (value.isInitialized && value.isPlaying != _isPlaying) {
      setState(() => _isPlaying = value.isPlaying);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error) return const SizedBox();

    return Padding(
      padding: widget.padding,
      child: FutureBuilder<void>(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (_isLoading) return widget.loadingPlaceholder ?? const LoadingContent(isSliver: false);

          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                // Tocar em qualquer ponto do vídeo reproduz ou pausa; teclado e
                // leitor de tela usam o botão próprio. Fica por cima do vídeo
                // porque, na web, o elemento do vídeo ficaria com o toque.
                Positioned.fill(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      excludeFromSemantics: true,
                      onTap: _togglePlayPause,
                    ),
                  ),
                ),
                if (widget.showControlsScrim) const Positioned(left: 0, right: 0, bottom: 0, child: _ControlsScrim()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    // Com o véu, afasta os botões da borda: o contorno de foco não é cortado.
                    padding: widget.showControlsScrim
                        ? EdgeInsets.only(
                            left: AppTheme.dimensions.components.videoControlsInset,
                            bottom: AppTheme.dimensions.components.videoControlsInset,
                          )
                        : EdgeInsets.zero,
                    child: Row(
                      children: [
                        AppIconButton(
                          tooltip: _isPlaying ? 'Pausar vídeo' : 'Reproduzir vídeo',
                          icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                          focusNode: widget.autofocusControls ? _playPauseFocus : null,
                          onPressed: _togglePlayPause,
                        ),
                        AppIconButton(
                          tooltip: _isMuted ? 'Ativar som' : 'Silenciar',
                          icon: _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 32,
                          onPressed: _toggleMute,
                        ),
                        SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
                        Expanded(
                          child: AppMouseRegion(
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        SizedBox(width: AppTheme.dimensions.space.small.horizontalSpacing),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _togglePlayPause() {
    if (!mounted) return;
    setState(() {
      // O estado muda antes da chamada: o controller avisa os ouvintes ainda
      // dentro de `play()`/`pause()`.
      _isPlaying = !_isPlaying;
      _isPlaying ? _controller.play() : _controller.pause();
    });
  }

  void _toggleMute() {
    if (!mounted) return;
    setState(() {
      _controller.setVolume(_isMuted ? 1 : 0);
      _isMuted = !_isMuted;
    });
  }
}

/// Véu escuro na base do vídeo, atrás dos controles: transparente no topo e
/// com opacidade cheia na faixa dos botões.
class _ControlsScrim extends StatelessWidget {
  const _ControlsScrim();

  @override
  Widget build(BuildContext context) {
    final scrim = AppTheme.colors.imageScrim;
    final components = AppTheme.dimensions.components;
    final solid = scrim.withValues(alpha: components.videoControlsScrimOpacity);

    return IgnorePointer(
      child: SizedBox(
        height: components.videoControlsScrimHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [scrim.withValues(alpha: 0), solid, solid],
              stops: [0, components.videoControlsScrimSolidFrom, 1],
            ),
          ),
        ),
      ),
    );
  }
}
