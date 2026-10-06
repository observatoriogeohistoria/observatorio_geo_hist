import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/error_content/state_message_box.dart';
import 'package:observatorio_geo_hist/app/core/components/page_content/page_content.dart';
import 'package:observatorio_geo_hist/app/core/components/reading/reading_page_scaffold.dart';
import 'package:observatorio_geo_hist/app/core/routes/app_routes.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final components = AppTheme.dimensions.components;
    final breakpoint = ScreenUtils.breakpointOf(context);
    final gap = components.notFoundActionsGap;

    return ReadingPageScaffold(
      body: PageContent(
        child: Padding(
          padding: EdgeInsets.only(
            top: components.readingPaddingTop,
            bottom: components.readingPaddingBottom(breakpoint),
          ),
          child: StateMessageBox(
            leading: Text(
              '404',
              textAlign: TextAlign.center,
              style: AppTheme.typography
                  .of(context)
                  .notFoundCode
                  .copyWith(color: AppTheme.colors.accent),
            ),
            title: 'Não encontramos esta página',
            titleHeadingLevel: 1,
            message: 'O endereço pode ter mudado ou o conteúdo foi removido.',
            // A ordem de leitura da página pulava do primeiro botão para o rodapé.
            action: FocusTraversalGroup(
              policy: WidgetOrderTraversalPolicy(),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: gap,
                runSpacing: gap,
                children: [
                  PrimaryButton.medium(
                    text: 'Ir para o início',
                    onPressed: () => GoRouter.of(context).go(AppRoutes.root),
                  ),
                  SecondaryButton.medium(
                    text: 'Explorar a biblioteca',
                    onPressed: () => GoRouter.of(context).go(AppRoutes.library),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
