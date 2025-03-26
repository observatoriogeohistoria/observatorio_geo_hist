import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
import 'package:observatorio_geo_hist/app/core/components/video_player/app_video_player.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/features/admin/panel/infra/models/media_model.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

void showViewImageDialog(
  BuildContext context,
  MediaModel media,
) {
  showDialog(
    context: context,
    builder: (context) {
      return ViewImageDialog(
        media: media,
      );
    },
  );
}

class ViewImageDialog extends StatefulWidget {
  const ViewImageDialog({
    required this.media,
    super.key,
  });

  final MediaModel media;

  @override
  State<ViewImageDialog> createState() => _ViewImageDialogState();
}

class _ViewImageDialogState extends State<ViewImageDialog> {
  @override
  Widget build(BuildContext context) {
    bool isVideo = widget.media.extension == 'mp4';

    return RightAlignedDialog(
      widthFollowsContent: true,
      child: Stack(
        children: [
          _buildMediaContent(isVideo),
          // SingleChildScrollView(
          //   child: _buildMediaContent(isVideo),
          // ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(AppTheme.dimensions.space.small.scale),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => GoRouter.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaContent(bool isVideo) {
    if (widget.media.bytes != null && !isVideo) {
      return Image.memory(
        widget.media.bytes!,
        fit: BoxFit.contain,
      );
    }

    if (widget.media.url != null) {
      if (isVideo) {
        return AppVideoPlayer(url: widget.media.url!);
      }

      return Image.network(
        widget.media.url!,
        fit: BoxFit.contain,
      );
    }

    return const SizedBox();
  }
}
