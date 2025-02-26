import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/app_text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_headline.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/features/home/home_setup.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/stores/fetch_team_store.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  late final FetchTeamStore fetchTeamStore = HomeSetup.getIt<FetchTeamStore>();

  @override
  void initState() {
    super.initState();

    fetchTeamStore.fetchTeam();
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme(context).colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2,
                vertical: 2 * AppTheme(context).dimensions.space.large,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: AppHeadline.medium(
                      text: 'CONTATO',
                      color: AppTheme(context).colors.orange,
                    ),
                  ),
                  SizedBox(height: AppTheme(context).dimensions.space.xlarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            _buildContactField('NOME', nameController),
                            _buildContactField('E-MAIL', emailController),
                            _buildContactField('ASSUNTO', subjectController),
                            _buildContactField(
                              'MENSAGEM',
                              messageController,
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
                        ),
                      ),
                      SizedBox(width: AppTheme(context).dimensions.space.xlarge),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildContactInfo('ENDEREÇO', AppStrings.address),
                            _buildContactInfo('TELEFONES', AppStrings.phones),
                            _buildContactInfo('E-MAIL', AppStrings.email),
                            _buildContactInfo('INSTAGRAM', AppStrings.instagram),
                            _buildContactInfo('FACEBOOK', AppStrings.facebook),
                            _buildContactInfo('YOUTUBE', AppStrings.youtube),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
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
          color: AppTheme(context).colors.orange,
        ),
        SizedBox(height: AppTheme(context).dimensions.space.medium),
        AppBody.big(
          text: value,
          color: AppTheme(context).colors.gray,
        ),
        SizedBox(height: AppTheme(context).dimensions.space.xlarge),
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
          color: AppTheme(context).colors.orange,
        ),
        SizedBox(height: AppTheme(context).dimensions.space.medium),
        AppTextField(
          controller: controller,
          hintText: '',
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,
        ),
        SizedBox(height: AppTheme(context).dimensions.space.xlarge),
      ],
    );
  }
}
