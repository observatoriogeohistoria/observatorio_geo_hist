import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_label.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/event_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    required this.body,
    required this.index,
    super.key,
  });

  final EventModel body;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLabel.small(
          text: '$index',
          color: AppTheme.colors.gray,
        ),
        SizedBox(height: AppTheme.dimensions.space.mini.verticalSpacing),
        AppTitle.big(
          text: body.title,
          color: AppTheme.colors.darkGray,
        ),
      ],
    );
  }
}
