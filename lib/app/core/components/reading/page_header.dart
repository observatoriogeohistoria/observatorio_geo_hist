import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/breadcrumbs.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

/// Cabeçalho das páginas de texto (`.page-head`): faixa de superfície com
/// migalhas, título e texto de apoio opcional, alinhados à esquerda.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.breadcrumbs, required this.title, this.lead});

  final List<BreadcrumbItem> breadcrumbs;
  final String title;
  final String? lead;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors;
    final components = AppTheme.dimensions.components;
    final styles = AppTheme.typography.of(context);
    final breakpoint = ScreenUtils.breakpointOf(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.line)),
      ),
      child: PageContent(
        child: Padding(
          padding: EdgeInsets.only(
            top: components.pageHeadPaddingTop,
            bottom: components.pageHeadPaddingBottom(breakpoint),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(alignment: Alignment.centerLeft, child: Breadcrumbs(items: breadcrumbs)),
              SizedBox(height: components.pageHeadTitleGap),
              Semantics(
                header: true,
                headingLevel: 1,
                child: Text(title, style: styles.h1.copyWith(color: colors.ink)),
              ),
              if (lead != null) ...[
                SizedBox(height: components.pageHeadLeadGap),
                Text(lead!, style: styles.lead.copyWith(color: colors.inkSecondary)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
