import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';
import 'package:observatorio_geo_hist/app/core/components/image/fitted_network_image.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({super.key, required this.name, this.imageUrl});

  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final size = AppTheme.dimensions.components.memberAvatar;
    final url = imageUrl?.trim() ?? '';

    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(
                color: colors.accentSoft,
                child: Center(
                  child: Text(
                    initialsOf(name),
                    maxLines: 1,
                    // O círculo tem tamanho fixo; ampliar as iniciais as faria vazar.
                    textScaler: TextScaler.noScaling,
                    style: AppTheme.typography
                        .of(context)
                        .memberInitials
                        .copyWith(color: colors.accentStrong),
                  ),
                ),
              ),
              if (url.isNotEmpty)
                FittedNetworkImage(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
