import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/image/fitted_network_image.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/strings/strings.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PanelThumbnail extends StatelessWidget {
  const PanelThumbnail({required this.url, super.key});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final url = this.url;

    return SizedBox(
      width: components.panelThumbWidth(ScreenUtils.breakpointOf(context)),
      child: AspectRatio(
        aspectRatio: components.panelThumbAspect,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r8),
          child: url == null || url.isEmpty
              ? const PanelImagePlaceholder()
              : ColoredBox(
                  color: AppTheme.colors.surface,
                  child: FittedNetworkImage(
                    url,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                    errorBuilder: (_, __, ___) => const PanelImagePlaceholder(),
                  ),
                ),
        ),
      ),
    );
  }
}

class PanelImagePlaceholder extends StatelessWidget {
  const PanelImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;

    return Semantics(
      image: true,
      label: 'Sem imagem',
      child: Container(
        color: colors.accentSoft,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          size: AppTheme.dimensions.components.panelThumbIcon,
          color: colors.accent,
        ),
      ),
    );
  }
}

class PanelAvatar extends StatelessWidget {
  const PanelAvatar({required this.name, this.imageUrl, super.key});

  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final size = AppTheme.dimensions.components.panelLeadSize;
    final url = imageUrl;
    final initials = Center(
      child: Text(
        initialsOf(name),
        style: AppTheme.typography.of(context).panelRowInitials.copyWith(
              color: colors.accentStrong,
            ),
      ),
    );

    // Initials sit underneath: with no photo, or if it fails, they're what shows.
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: colors.accentSoft, shape: BoxShape.circle),
        clipBehavior: Clip.antiAlias,
        child: url == null || url.isEmpty
            ? initials
            : Stack(
                fit: StackFit.expand,
                children: [
                  initials,
                  FittedNetworkImage(
                    url,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ],
              ),
      ),
    );
  }
}

class PanelLeadIcon extends StatelessWidget {
  const PanelLeadIcon({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;

    return ExcludeSemantics(
      child: Container(
        width: components.panelLeadSize,
        height: components.panelLeadSize,
        decoration: BoxDecoration(
          color: colors.accentSoft,
          borderRadius: BorderRadius.circular(AppTheme.dimensions.radii.r12),
        ),
        child: Icon(icon, size: components.panelLeadIcon, color: colors.accent),
      ),
    );
  }
}
