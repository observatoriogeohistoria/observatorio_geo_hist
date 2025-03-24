import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/divider/divider.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/device/device_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  bool get isMobile => DeviceUtils.isMobile(context);
  bool get isTablet => DeviceUtils.isTablet(context);
  bool get isDesktop => DeviceUtils.isDesktop(context);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = (isDesktop
            ? AppTheme.dimensions.space.gigantic
            : (isTablet ? AppTheme.dimensions.space.massive : AppTheme.dimensions.space.large))
        .horizontalSpacing;

    double width = MediaQuery.of(context).size.width -
        2 * horizontalPadding -
        AppTheme.dimensions.space.massive.horizontalSpacing;

    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Navbar()),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppTheme.dimensions.space.huge.verticalSpacing,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: AppHeadline.medium(
                      text: 'CONTATO',
                      color: AppTheme.colors.orange,
                    ),
                  ),
                  const AppDivider(),
                  SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                  isMobile
                      ? Column(
                          children: [
                            _buildFields(),
                            SizedBox(height: AppTheme.dimensions.space.massive.verticalSpacing),
                            _buildInfos(),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: _buildFields(),
                            ),
                            SizedBox(width: AppTheme.dimensions.space.massive.horizontalSpacing),
                            SizedBox(
                              width: width / 2,
                              child: _buildInfos(),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          const SliverFillRemaining(hasScrollBody: false, child: SizedBox.shrink()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        _buildContactField('NOME', _nameController),
        _buildContactField('E-MAIL', _emailController),
        _buildContactField('ASSUNTO', _subjectController),
        _buildContactField(
          'MENSAGEM',
          _messageController,
          minLines: 5,
          maxLines: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton.medium(
            text: 'ENVIAR',
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildInfos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactInfo('ENDEREÇO', AppStrings.address),
        _buildContactInfo('TELEFONES', AppStrings.phones),
        _buildContactInfo('E-MAIL', AppStrings.email),
        _buildContactInfo('INSTAGRAM', AppStrings.instagram),
        _buildContactInfo('FACEBOOK', AppStrings.facebook),
        _buildContactInfo('YOUTUBE', AppStrings.youtube),
      ],
    );
  }

  Widget _buildContactInfo(
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTitle.small(
          text: label,
          color: AppTheme.colors.orange,
        ),
        SizedBox(height: AppTheme.dimensions.space.medium),
        AppBody.big(
          text: value,
          color: AppTheme.colors.gray,
        ),
        SizedBox(height: AppTheme.dimensions.space.huge),
      ],
    );
  }

  Widget _buildContactField(
    String label,
    TextEditingController controller, {
    int? minLines,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTitle.small(
          text: label,
          color: AppTheme.colors.orange,
        ),
        SizedBox(height: AppTheme.dimensions.space.medium),
        AppTextField(
          controller: controller,
          // minLines: minLines,
          // maxLines: maxLines,
          keyboardType: TextInputType.multiline,
        ),
        SizedBox(height: AppTheme.dimensions.space.huge),
      ],
    );
  }
}
