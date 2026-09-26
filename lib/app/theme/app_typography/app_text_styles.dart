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
// | h3       | Bricolage Grotesque | 700  | 1,20   | -0,01 em    | `.area b`, `.feat h3`      |
// | leitura  | Figtree             | 400  | 1,75   | 0           | `.prose`                   |
// | apoio    | Figtree             | 400  | 1,55   | 0           | `.lead`                    |
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

  /// Texto de leitura (artigos).
  TextStyle get reading => _body(
        size: _size(mobile: 17, tablet: 18, desktop: 18),
        weight: FontWeight.w400,
        height: 1.75,
      );

  /// Texto de apoio abaixo de títulos grandes (hero). Valores da spec 004.
  TextStyle get lead => _body(
        size: _size(mobile: 17, tablet: 20, desktop: 20),
        weight: FontWeight.w400,
        height: 1.55,
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
