import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/dialog/right_aligned_dialog.dart';
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

class ViewImageDialog extends StatelessWidget {
  const ViewImageDialog({
    required this.media,
    super.key,
  });

  final MediaModel media;

  @override
  Widget build(BuildContext context) {
    return RightAlignedDialog(
      widthFollowsContent: true,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Image.memory(
              media.bytes,
              fit: BoxFit.contain,
            ),
          ),
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
}
