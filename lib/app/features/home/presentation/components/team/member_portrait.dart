import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';
import 'package:observatorio_geo_hist/app/core/components/image/fitted_network_image.dart';

class MemberPortrait extends StatelessWidget {
  const MemberPortrait({super.key, required this.name, this.imageUrl});

  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final url = imageUrl?.trim() ?? '';

    final portrait = AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: colors.accentSoft,
              child: Center(
                child: Text(
                  initialsOf(name),
                  maxLines: 1,
                  // O quadrado tem tamanho fixo; ampliar as iniciais as faria vazar.
                  textScaler: TextScaler.noScaling,
                  style: AppTheme.typography
                      .of(context)
                      .memberPageInitials
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
    );

    if (url.isEmpty) return ExcludeSemantics(child: portrait);
    return Semantics(image: true, label: 'Foto de $name', child: ExcludeSemantics(child: portrait));
  }
}
