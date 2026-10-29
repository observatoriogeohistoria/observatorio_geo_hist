import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AudienceItem extends StatelessWidget {
  const AudienceItem({
    super.key,
    required this.icon,
    required this.name,
    required this.description,
    this.isLast = false,
  });

  final IconData icon;
  final String name;
  final String description;

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final line = BorderSide(color: colors.line, width: AppTheme.dimensions.stroke.small);

    return Semantics(
      label: '$name. $description',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: line, bottom: isLast ? line : BorderSide.none),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: components.audienceItemPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: components.audienceIconBox,
                height: components.audienceIconBox,
                decoration: BoxDecoration(color: colors.accentSoft, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(icon, size: components.audienceIcon, color: colors.accent),
              ),
              SizedBox(width: components.audienceIconGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: styles.listTitle.copyWith(color: colors.ink)),
                    SizedBox(height: components.audienceTextGap),
                    Text(description, style: styles.regular.copyWith(color: colors.inkSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
