import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/team/sort_team.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Foto redonda do membro da equipe (spec 008). As iniciais ficam sempre por
/// baixo: aparecem enquanto a foto carrega, quando não há foto ou quando ela
/// falha, sem mudar o tamanho. Decorativa para o leitor de tela.
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
                    memberInitials(name),
                    maxLines: 1,
                    // O círculo tem tamanho fixo; ampliar as iniciais as faria vazar.
                    textScaler: TextScaler.noScaling,
                    style: AppTheme.typography.of(context).memberInitials.copyWith(color: colors.accentStrong),
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
      ),
    );
  }
}
