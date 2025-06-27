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
    super.key,
  });

  final String url;
  final EdgeInsets padding;

  final bool startPlaying;
  final bool startMuted;

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

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    if (widget.startPlaying) _togglePlayPause();
    if (widget.startMuted) _toggleMute();

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() => _isLoading = false);
    }).catchError((error) {
      setState(() => _error = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) return const SizedBox();

    return Padding(
      padding: widget.padding,
      child: FutureBuilder<void>(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (_isLoading) return const LoadingContent(isSliver: false);

          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      AppIconButton(
                        icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                        onPressed: _togglePlayPause,
                      ),
                      AppIconButton(
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
              ],
            ),
          );
        },
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying ? _controller.pause() : _controller.play();
      _isPlaying = !_isPlaying;
    });
  }

  void _toggleMute() {
    setState(() {
      _controller.setVolume(_isMuted ? 1 : 0);
      _isMuted = !_isMuted;
    });
  }
}
