import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class WhoWeAre extends StatelessWidget {
  const WhoWeAre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('${AppAssets.images}/who-we-are.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.35),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15,
              vertical: AppTheme.dimensions.space.medium,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TitleWidget(title: 'QUEM SOMOS'),
                SizedBox(height: AppTheme.dimensions.space.xlarge),
                AppBody.big(
                  text:
                      'O Observatório de Ensino de História e Geografia é um espaço digital que possibilita o acesso, compartilhamento, a colaboração e a produção de conhecimentos. Nosso objetivo é oferecer um espaço/tempo que facilite o acesso a uma plataforma que congregue narrativas, dados, documentos, pesquisas, experiências didáticas e materiais diversos sobre o ensino e a aprendizagem de História e Geografia. O Observatório é destinado a professores, pesquisadores e estudantes que queiram conhecer e se aprofundar em discussões sobre práticas e saberes educativos. Nossa missão é promover a divulgação de conhecimentos relevantes e a circulação de saberes que contribuam para a formação permanente de professores e profissionais que atuam no campo do ensino de História, Geografia e áreas afins.',
                  textAlign: TextAlign.center,
                  color: AppTheme.colors.white,
                ),
                SizedBox(height: AppTheme.dimensions.space.xlarge),
                PrimaryButton.medium(
                  text: 'MANIFESTO',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
