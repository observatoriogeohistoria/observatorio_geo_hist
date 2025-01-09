import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/field/text_field.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
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
  late FetchTeamStore fetchTeamStore;

  @override
  void initState() {
    super.initState();

    fetchTeamStore = HomeSetup.getIt<FetchTeamStore>();
    fetchTeamStore.fetchTeam();
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2,
                vertical: 2 * AppTheme.dimensions.space.large,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'CONTATO',
                      style: AppTheme.typography.headline.large.copyWith(
                        color: AppTheme.colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(height: AppTheme.dimensions.space.xlarge),
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
                              child: PrimaryButton(
                                text: 'ENVIAR',
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppTheme.dimensions.space.xlarge),
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
        Text(
          label,
          style: AppTheme.typography.title.medium.copyWith(
            color: AppTheme.colors.orange,
          ),
        ),
        SizedBox(height: AppTheme.dimensions.space.medium),
        Text(
          value,
          style: AppTheme.typography.body.large.copyWith(
            color: AppTheme.colors.gray,
          ),
        ),
        SizedBox(height: AppTheme.dimensions.space.xlarge),
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
        Text(
          label,
          style: AppTheme.typography.title.medium.copyWith(
            color: AppTheme.colors.orange,
          ),
        ),
        SizedBox(height: AppTheme.dimensions.space.medium),
        AppTextField(
          controller: controller,
          hintText: '',
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: TextInputType.multiline,
        ),
        SizedBox(height: AppTheme.dimensions.space.xlarge),
      ],
    );
  }
}
