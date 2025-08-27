import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:observatorio_geo_hist/app/core/components/buttons/primary_button.dart';
import 'package:observatorio_geo_hist/app/core/components/footer/footer.dart';
import 'package:observatorio_geo_hist/app/core/components/navbar/navbar.dart';
import 'package:observatorio_geo_hist/app/core/components/text/app_body.dart';
import 'package:observatorio_geo_hist/app/core/components/text/common_title.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_assets.dart';
import 'package:observatorio_geo_hist/app/core/utils/constants/app_strings.dart';
import 'package:observatorio_geo_hist/app/core/utils/extensions/num_extension.dart';
import 'package:observatorio_geo_hist/app/core/utils/screen/screen_utils.dart';
import 'package:observatorio_geo_hist/app/core/utils/url/url.dart';
import 'package:observatorio_geo_hist/app/features/home/presentation/components/partners.dart';
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
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Navbar()),
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('${AppAssets.images}/collaborate.webp'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.35),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.getPageHorizontalPadding(context),
                  vertical: AppTheme.dimensions.space.large.verticalSpacing,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CommonTitle(title: 'COLABORE'),
                    SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                    AppBody.big(
                      text: firstText,
                      textAlign: TextAlign.center,
                      color: AppTheme.colors.white,
                    ),
                    SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                    PrimaryButton.medium(
                      text: AppStrings.email,
                      onPressed: () => openUrl('mailto:${AppStrings.email}'),
                    ),
                    SizedBox(height: AppTheme.dimensions.space.huge.verticalSpacing),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: secondText,
                            style: AppTheme.typography.body.big.copyWith(
                              color: AppTheme.colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ' clique aqui',
                            style: AppTheme.typography.body.big.copyWith(
                              color: AppTheme.colors.orange,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => openUrl(AppStrings.creativeCommonsUrl),
                          ),
                          TextSpan(
                            text: '.',
                            style: AppTheme.typography.body.big.copyWith(
                              color: AppTheme.colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Partners()),
          const SliverFillRemaining(hasScrollBody: false, child: SizedBox.shrink()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
