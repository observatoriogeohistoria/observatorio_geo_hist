import 'dart:html' as html;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/common/title_widget.dart';
import 'package:observatorio_geo_hist/app/theme/app_theme.dart';

class CollaboratePage extends StatelessWidget {
  const CollaboratePage({super.key});

  @override
  Widget build(BuildContext context) {
    const firstText =
        'O Observatório do Ensino de História e Geografia é uma plataforma digital colaborativa. Valorizamos e incentivamos a participação de professores, pesquisadores e estudantes na construção deste espaço coletivo. Gostaria de publicar artigos de opinião, compartilhar relatos de experiência, divulgar produções acadêmicas ou sugerir a inclusão de materiais? Envie um e-mail para:';

    const secondText = '''
Aceitamos qualquer tipo de arquivo, como texto, áudio e vídeo. Utilize extensões de uso consagrado, como .pdf, .doc, .odt, .mp3, .mp4 e .jpg. Caso inclua criações de terceiros no seu conteúdo, lembre-se de verificar se os termos de uso e compartilhamento permitem a redistribuição. Por fim, não se esqueça de se identificar (nome completo do autor, e-mail e, se for o caso, Instituição de Ensino Superior). Após avaliação, o material será publicado no Observatório.

Exceto quando expressamente indicado, todo o conteúdo publicado no Observatório do Ensino de História e Geografia é licenciado sob os termos da Creative Commons - Atribuição-NãoComercial-CompartilhaIgual 4.0 Internacional, o que significa que os materiais podem ser compartilhados e remixados, desde que a distribuição ocorra sob termos idênticos, com atribuição de autoria e para fins não comerciais. Para conhecer mais sobre as licenças Creative Commons,''';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('${AppAssets.images}/collaborate.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withValues(alpha: .35),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15,
                      vertical: AppTheme.dimensions.space.medium,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TitleWidget(title: 'COLABORE'),
                        SizedBox(height: AppTheme.dimensions.space.xlarge),
                        AppBody.big(
                          text: firstText,
                          textAlign: TextAlign.center,
                          color: AppTheme.colors.white,
                        ),
                        SizedBox(height: AppTheme.dimensions.space.xlarge),
                        PrimaryButton.medium(
                          text: AppStrings.email,
                          onPressed: () {},
                        ),
                        SizedBox(height: AppTheme.dimensions.space.xlarge),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: secondText,
                                style: AppTheme(context).typography.body.big.copyWith(
                                      color: AppTheme.colors.white,
                                    ),
                              ),
                              TextSpan(
                                text: ' clique aqui',
                                style: AppTheme(context).typography.body.big.copyWith(
                                      color: AppTheme.colors.orange,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    const url = AppStrings.creativeCommonsUrl;
                                    html.window.open(url, 'new tab');
                                  },
                              ),
                              TextSpan(
                                text: '.',
                                style: AppTheme(context).typography.body.big.copyWith(
                                      color: AppTheme.colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
}
