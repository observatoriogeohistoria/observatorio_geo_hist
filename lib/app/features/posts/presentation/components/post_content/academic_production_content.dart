import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/secondary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/academic_production_model.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class AcademicProductionContent extends StatelessWidget {
  const AcademicProductionContent({
    required this.post,
    required this.academicProduction,
    super.key,
  });

  final PostModel post;
  final AcademicProductionModel academicProduction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.massive.verticalSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
            child: Column(
              children: [
                if (academicProduction.image.url?.isNotEmpty ?? false)
                  AppNetworkImage(
                    imageUrl: academicProduction.image.url!,
                  ),
                SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
                SizedBox(
                  width: double.maxFinite,
                  child: SecondaryButton.medium(
                    text: "Acesse",
                    onPressed: () => openUrl(academicProduction.link),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppTheme.dimensions.space.massive.horizontalSpacing),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppHeadline.big(
                  text: academicProduction.title.toUpperCase(),
                  textAlign: TextAlign.start,
                  color: AppTheme.colors.orange,
                ),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                const AppDivider(),
                AppTitle.big(
                  text: academicProduction.category.portuguese,
                  color: AppTheme.colors.gray,
                ),
                SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                _buildInfo('Autor(a)', academicProduction.author),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                _buildInfo('Orientador(a)', academicProduction.advisor),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                _buildInfo('Instituição de Ensino Superior', academicProduction.institution),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                _buildInfo('Cidade e ano de publicação', academicProduction.yearAndCity),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                _buildInfo('Resumo', academicProduction.summary),
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                _buildInfo('Palavras-chave', academicProduction.keywords),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(
    String title,
    String text,
  ) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: AppTheme.typography.title.medium.copyWith(color: AppTheme.colors.orange),
        children: [
          TextSpan(
            text: text,
            style: AppTheme.typography.body.big.copyWith(color: AppTheme.colors.darkGray),
          ),
        ],
      ),
    );
  }
}
