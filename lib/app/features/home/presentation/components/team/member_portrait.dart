import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/sort_team.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Foto quadrada da página da pessoa (`.portrait`). As iniciais ficam por
/// baixo: aparecem enquanto a foto carrega, quando não há foto ou quando ela
/// falha, sem mudar o tamanho.
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
                  memberInitials(name),
                  maxLines: 1,
                  // O quadrado tem tamanho fixo; ampliar as iniciais as faria vazar.
                  textScaler: TextScaler.noScaling,
                  style: AppTheme.typography.of(context).memberPageInitials.copyWith(color: colors.accentStrong),
                ),
              ),
            ),
            if (url.isNotEmpty)
              Image.network(
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
