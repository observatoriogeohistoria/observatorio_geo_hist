import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/image/app_network_image.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/models/post_model.dart';
import 'package:observatorio_geo_hist/app/core/models/search_model.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class SearchContent extends StatelessWidget {
  const SearchContent({
    required this.post,
    required this.search,
    super.key,
  });

  final PostModel post;
  final SearchModel search;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtils.getPageHorizontalPadding(context),
        vertical: AppTheme.dimensions.space.massive.verticalSpacing,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppHeadline.big(
            text: search.title.toUpperCase(),
            textAlign: TextAlign.start,
            color: AppTheme.colors.orange,
          ),
          SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
          AppTitle.big(
            text: search.state.portuguese,
            color: AppTheme.colors.gray,
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          const AppDivider(),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          if (search.image.url?.isNotEmpty ?? false)
            AppNetworkImage(
              imageUrl: search.image.url!,
            ),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: AppTheme.dimensions.space.small.verticalSpacing),
                AppTitle.small(
                  text: search.imageCaption,
                  textAlign: TextAlign.start,
                  color: AppTheme.colors.gray,
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          _buildInfo('Descrição', search.description),
          SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          if (search.coordinator?.isNotEmpty ?? false) ...[
            _buildInfo('Coordenador(a)', search.coordinator!),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          ],
          if (search.researcher?.isNotEmpty ?? false) ...[
            _buildInfo('Pesquisador(a)', search.researcher!),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          ],
          if (search.advisor?.isNotEmpty ?? false) ...[
            _buildInfo('Orientador(a)', search.advisor!),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          ],
          if (search.coAdvisor?.isNotEmpty ?? false) ...[
            _buildInfo('Coorientador(a)', search.coAdvisor!),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          ],
          if (search.members?.isNotEmpty ?? false) ...[
            _buildInfo('Integrantes', search.members!),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          ],
          if (search.financier?.isNotEmpty ?? false) ...[
            _buildInfo('Financiador(a)', search.financier!),
            SizedBox(height: AppTheme.dimensions.space.large.verticalSpacing),
          ],
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
