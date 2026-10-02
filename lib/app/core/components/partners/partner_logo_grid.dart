import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/partners/partner_logo.dart';
import 'package:observatorio_geo_hist/app/core/utils/enums/partner.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PartnerLogoGrid extends StatelessWidget {
  const PartnerLogoGrid({super.key, this.minColumnWidth});

  final double? minColumnWidth;

  static int columnsFor(double width, double minColumnWidth) {
    final gap = AppTheme.dimensions.components.partnerGap;
    return math.max(1, ((width + gap) / (minColumnWidth + gap)).floor());
  }

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    const partners = Partner.values;

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = ScreenUtils.breakpointOf(context) == Breakpoint.mobile
            ? components.partnerColumnsMobile
            : columnsFor(constraints.maxWidth, minColumnWidth ?? components.partnerColumnMinWidth);
        final rows = (partners.length / columns).ceil();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var row = 0; row < rows; row++) ...[
              if (row > 0) SizedBox(height: components.partnerGap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) SizedBox(width: components.partnerGap),
                    Expanded(
                      child: row * columns + column < partners.length
                          ? PartnerLogo(partner: partners[row * columns + column])
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
