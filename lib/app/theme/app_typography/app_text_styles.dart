part of '../app_theme.dart';

// Valores lidos do CSS do protótipo (aba "Fundamentos" e telas). O espaçamento
// entre letras está em em (fração do tamanho da fonte); a altura de linha é
// multiplicador do tamanho.
//
// | Estilo   | Família             | Peso | Altura | Espaçamento | Origem no protótipo        |
// |----------|---------------------|------|--------|-------------|----------------------------|
// | display  | Bricolage Grotesque | 800  | 1,12   | -0,035 em   | `.hero h1`                 |
// | h1       | Bricolage Grotesque | 800  | 1,12   | -0,03 em    | `.page-head h1`            |
// | h2       | Bricolage Grotesque | 700  | 1,12   | -0,02 em    | `.section-head h2`         |
// | h3       | Bricolage Grotesque | 700  | 1,20   | -0,01 em    | `.area b`                  |
// | destaque | Bricolage Grotesque | 700  | 1,12   | -0,02 em    | `.feat.big h3`             |
// | destaque menor | Bricolage     | 700  | 1,20   | -0,01 em    | `.feat h3`                 |
// | título em colunas | Bricolage | 700  | 1,12   | -0,02 em    | `.split h2`                |
// | item de lista | Bricolage      | 700  | 1,30   | 0           | `.for b`                   |
// | legenda de vídeo | Bricolage   | 600  | 1,20   | 0           | `.video-cap`               |
// | nome de membro | Bricolage     | 700  | 1,30   | 0           | `.member b`                |
// | chamada  | Bricolage Grotesque | 700  | 1,12   | -0,02 em    | `.cta h2`                  |
// | iniciais | Bricolage Grotesque | 700  | 1,00   | 0           | `.avatar`                  |
// | função de membro | Figtree     | 400  | 1,45   | 0           | `.member span`             |
// | leitura  | Figtree             | 400  | 1,75   | 0           | `.prose`                   |
// | item numerado | Figtree        | 400  | 1,65   | 0           | `.manifest-list li`        |
// | número do item | Figtree       | 700  | 1,00   | 0           | `.manifest-list li::before`|
// | destaque de leitura | Bricolage | 500 | 1,35   | -0,02 em    | `.prose blockquote`        |
// | subtítulo de leitura | Bricolage | 700 | 1,12  | -0,02 em    | `.article .prose h2`       |
// | nome na página da pessoa | Bricolage | 800 | 1,12 | -0,03 em | `#s-member h1`             |
// | iniciais da pessoa | Bricolage   | 800  | 1,00   | 0           | `.portrait`                |
// | título de estado | Bricolage   | 700  | 1,12   | -0,02 em    | `.state-box b`             |
// | título do post | Bricolage     | 800  | 1,12   | -0,03 em    | `.article-head h1`         |
// | subtítulo do post | Figtree    | 400  | 1,45   | 0           | `.article-head .sub`       |
// | iniciais do autor | Bricolage  | 700  | 1,00   | 0           | `.who .avatar`             |
// | título de cartão | Bricolage   | 600  | 1,20   | -0,02 em    | `.card h3`                 |
// | apoio    | Figtree             | 400  | 1,55   | 0           | `.lead`                    |
// | apoio de seção | Figtree       | 400  | 1,55   | 0           | `.lead` a 1,1 rem          |
// | selo     | Figtree             | 600  | 1,35   | 0           | `.fact`                    |
// | padrão   | Figtree             | 400  | 1,55   | 0           | `body`                     |
// | pequeno  | Figtree             | 400  | 1,50   | 0           | `.meta`, `.area span`      |
// | rótulo   | Figtree             | 700  | 1,40   | 0,08 em     | `.eyebrow`, `.tag`         |
//
// O rótulo é escrito em caixa alta no protótipo (`text-transform`). O Flutter
// não tem essa propriedade: quem usa o estilo aplica `toUpperCase()` no texto.

/// Escala de texto do redesign, já na faixa de largura certa.
///
/// Obtida por `AppTheme.typography.of(context)`. Não usa `google_fonts` nem
/// `num_extension`: as fontes estão embutidas em `assets/fonts/`.
class AppTextStyles {
  const AppTextStyles._(this.breakpoint);

  /// Estilos para a faixa de [width].
  factory AppTextStyles.forWidth(double width) {
    return AppTextStyles._(Breakpoint.fromWidth(width));
  }

  final Breakpoint breakpoint;

  static const String _displayFamily = 'BricolageGrotesque';
  static const String _bodyFamily = 'Figtree';

  /// Fontes do sistema, para o caso de a fonte embutida falhar.
  static const List<String> _fallback = ['system-ui', 'Roboto', 'Arial'];

  /// Tamanho por faixa (valores da spec 001).
  double _size({required double mobile, required double tablet, required double desktop}) {
    return switch (breakpoint) {
      Breakpoint.mobile => mobile,
      Breakpoint.tablet => tablet,
      Breakpoint.desktop => desktop,
    };
  }

  TextStyle _display({
    required double size,
    required FontWeight weight,
    required double height,
    required double letterSpacingEm,
  }) {
    return TextStyle(
      fontFamily: _displayFamily,
      fontFamilyFallback: _fallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: size * letterSpacingEm,
    );
  }

  TextStyle _body({
    required double size,
    required FontWeight weight,
    required double height,
    double letterSpacingEm = 0,
  }) {
    return TextStyle(
      fontFamily: _bodyFamily,
      fontFamilyFallback: _fallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: size * letterSpacingEm,
    );
  }

  /// Título de destaque (hero da Home). Valores da spec 004.
  TextStyle get display => _display(
        size: _size(mobile: 35, tablet: 54, desktop: 64),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.035,
      );

  /// Título de página.
  TextStyle get h1 => _display(
        size: _size(mobile: 32, tablet: 40, desktop: 52),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.03,
      );

  /// Título de seção.
  TextStyle get h2 => _display(
        size: _size(mobile: 26, tablet: 30, desktop: 36),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  /// Título de cartão.
  TextStyle get h3 => _display(
        size: _size(mobile: 18, tablet: 20, desktop: 20),
        weight: FontWeight.w700,
        height: 1.2,
        letterSpacingEm: -0.01,
      );

  /// Título do destaque principal da Home (`.feat.big h3`). Valores da spec 005.
  TextStyle get featureTitle => _display(
        size: _size(mobile: 24, tablet: 32, desktop: 35),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  /// Título dos destaques menores da Home (`.feat h3`). Valores da spec 005.
  TextStyle get featureTitleSmall => _display(
        size: _size(mobile: 18, tablet: 22, desktop: 24),
        weight: FontWeight.w700,
        height: 1.2,
        letterSpacingEm: -0.01,
      );

  /// Título das seções em duas colunas da Home, como Quem somos (`.split h2`).
  /// Valores da spec 006.
  TextStyle get splitTitle => _display(
        size: _size(mobile: 27, tablet: 36, desktop: 40),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  /// Nome de item em lista, como os públicos de Quem somos (`.for b`). Spec 006.
  TextStyle get listTitle => _display(
        size: _size(mobile: 18, tablet: 18, desktop: 18),
        weight: FontWeight.w700,
        height: 1.3,
        letterSpacingEm: 0,
      );

  /// Legenda sobre a capa do vídeo da Home (`.video-cap`). Spec 006.
  TextStyle get videoCaption => _display(
        size: _size(mobile: 18, tablet: 24, desktop: 26),
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacingEm: 0,
      );

  /// Nome de membro da equipe (`.member b`). Spec 008.
  TextStyle get memberName => _display(
        size: _size(mobile: 17, tablet: 17, desktop: 17),
        weight: FontWeight.w700,
        height: 1.3,
        letterSpacingEm: 0,
      );

  /// Iniciais no círculo de membro sem foto (`.avatar`). Spec 008.
  TextStyle get memberInitials => _display(
        size: _size(mobile: 24, tablet: 24, desktop: 24),
        weight: FontWeight.w700,
        height: 1,
        letterSpacingEm: 0,
      );

  /// Função de membro da equipe (`.member span`). Spec 008.
  TextStyle get memberRole => _body(
        size: _size(mobile: 14.5, tablet: 14.5, desktop: 14.5),
        weight: FontWeight.w400,
        height: 1.45,
      );

  /// Título da chamada para contato no fim da Home (`.cta h2`). Spec 009.
  TextStyle get ctaTitle => _display(
        size: _size(mobile: 24, tablet: 32, desktop: 35),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  /// Texto de leitura (artigos).
  TextStyle get reading => _body(
        size: _size(mobile: 17, tablet: 18, desktop: 18),
        weight: FontWeight.w400,
        height: 1.75,
      );

  /// Item de lista numerada na coluna de leitura (`.manifest-list li`). Spec 010.
  TextStyle get readingListItem => _body(
        size: _size(mobile: 17, tablet: 17.5, desktop: 17.5),
        weight: FontWeight.w400,
        height: 1.65,
      );

  /// Número dentro do círculo da lista numerada. Spec 010.
  TextStyle get readingListNumber => _body(
        size: _size(mobile: 14, tablet: 14, desktop: 14),
        weight: FontWeight.w700,
        height: 1,
      );

  /// Frase de destaque na coluna de leitura (`.prose blockquote`). Spec 010.
  TextStyle get readingQuote => _display(
        size: _size(mobile: 20, tablet: 22.4, desktop: 22.4),
        weight: FontWeight.w500,
        height: 1.35,
        letterSpacingEm: -0.02,
      );

  /// Subtítulo na coluna de leitura (`.article .prose h2`). Spec 011.
  TextStyle get readingSubtitle => _display(
        size: _size(mobile: 24, tablet: 27.2, desktop: 27.2),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  /// Nome na página da pessoa da equipe (`#s-member h1`). Spec 011.
  TextStyle get memberPageName => _display(
        size: _size(mobile: 32, tablet: 42, desktop: 48),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.03,
      );

  /// Iniciais na foto da pessoa sem foto (`.portrait`). Spec 011.
  TextStyle get memberPageInitials => _display(
        size: _size(mobile: 48, tablet: 64, desktop: 64),
        weight: FontWeight.w800,
        height: 1,
        letterSpacingEm: 0,
      );

  /// Título da caixa de estado, como o erro (`.state-box b`). Spec 011.
  TextStyle get stateTitle => _display(
        size: _size(mobile: 20.8, tablet: 20.8, desktop: 20.8),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  /// Título do post (`.article-head h1`). Spec 012.
  TextStyle get postTitle => _display(
        size: _size(mobile: 32, tablet: 42, desktop: 53),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.03,
      );

  /// Subtítulo do post (`.article-head .sub`). Spec 012.
  TextStyle get postSubtitle => _body(
        size: _size(mobile: 18, tablet: 20, desktop: 22.4),
        weight: FontWeight.w400,
        height: 1.45,
      );

  /// Iniciais no círculo do autor do post (`.who .avatar`). Spec 012.
  TextStyle get postAuthorInitials => _display(
        size: _size(mobile: 16, tablet: 16, desktop: 16),
        weight: FontWeight.w700,
        height: 1,
        letterSpacingEm: 0,
      );

  /// Título do cartão do Leia também (`.card h3`, peso 650). Spec 012.
  TextStyle get relatedCardTitle => _display(
        size: _size(mobile: 20, tablet: 20, desktop: 20),
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacingEm: -0.02,
      );

  /// Texto de apoio abaixo de títulos grandes (hero). Valores da spec 004.
  TextStyle get lead => _body(
        size: _size(mobile: 17, tablet: 20, desktop: 20),
        weight: FontWeight.w400,
        height: 1.55,
      );

  /// Texto de apoio de uma seção, como a missão em Quem somos (`.lead` com
  /// `font-size: 1.1rem`). Spec 006.
  TextStyle get sectionLead => _body(
        size: _size(mobile: 17, tablet: 18, desktop: 18),
        weight: FontWeight.w400,
        height: 1.55,
      );

  /// Texto de selo, como o marco de Nossa história (`.fact`). Spec 007.
  TextStyle get badge => _body(
        size: _size(mobile: 14.5, tablet: 14.5, desktop: 14.5),
        weight: FontWeight.w600,
        height: 1.35,
      );

  /// Texto padrão.
  TextStyle get regular => _body(
        size: _size(mobile: 16, tablet: 16, desktop: 16),
        weight: FontWeight.w400,
        height: 1.55,
      );

  /// Texto pequeno.
  TextStyle get small => _body(
        size: _size(mobile: 14, tablet: 14, desktop: 14),
        weight: FontWeight.w400,
        height: 1.5,
      );

  /// Rótulo (caixa alta: aplicar `toUpperCase()` no texto).
  TextStyle get label => _body(
        size: _size(mobile: 12.5, tablet: 12.5, desktop: 13),
        weight: FontWeight.w700,
        height: 1.4,
        letterSpacingEm: 0.08,
      );
}
