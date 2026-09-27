part of '../app_theme.dart';

class AppDimensions {
  AppDimensions._();
  static AppDimensions get instance => AppDimensions._();

  DimensionStyle space = const DimensionStyle._(
    mini: 4.0,
    small: 8.0,
    medium: 16.0,
    large: 24.0,
    huge: 32.0,
    massive: 48.0,
    immense: 64.0,
    gigantic: 96.0,
  );

  DimensionStyle radius = const DimensionStyle._(
    mini: 2.0,
    small: 4.0,
    medium: 8.0,
    large: 12.0,
    huge: 24.0,
    massive: 48.0,
    immense: 64.0,
    gigantic: 100.0,
  );

  DimensionStyle stroke = const DimensionStyle._(
    mini: 0.5,
    small: 1.0,
    medium: 2.0,
    large: 3.0,
    huge: 4.0,
    massive: 5.0,
    immense: 6.0,
    gigantic: 7.0,
  );

  // Tokens do redesign. Escalas nomeadas pelo valor em px lógicos.
  SpacingScale spacing = const SpacingScale._();
  RadiiScale radii = const RadiiScale._();
  ShadowStyle shadows = const ShadowStyle._();
  FocusStyle focus = const FocusStyle._();
  ComponentSizes components = const ComponentSizes._();
}

/// Tamanhos fixos de componentes compartilhados (botões, navbar, menus).
class ComponentSizes {
  const ComponentSizes._();

  /// Altura da navbar fixa.
  final double navbarHeight = 68.0;

  /// Altura da faixa de aviso de ambiente de testes (acima da navbar).
  final double environmentBannerHeight = 32.0;

  /// Altura mínima dos botões: pequeno e médio/grande.
  final double buttonMinHeightSmall = 40.0;
  final double buttonMinHeightRegular = 44.0;

  /// Tamanho do texto dos botões pequeno, médio e grande.
  final double buttonTextSmall = 14.0;
  final double buttonTextMedium = 16.0;
  final double buttonTextBig = 18.0;

  /// Logo: tamanho da marca e dos textos.
  final double logoMark = 34.0;
  final double logoName = 19.0;
  final double logoSubtitle = 11.5;

  /// Texto dos itens da navbar e das opções dos menus.
  final double navItemText = 15.5;
  final double navIcon = 20.0;

  /// Opacidade do fundo da navbar e do véu atrás do menu de celular.
  final double navbarOpacity = 0.94;
  final double scrimOpacity = 0.4;

  /// Ícone do botão de menu (três traços / fechar) e área tocável mínima.
  final double menuIconSize = 24.0;
  final double minTapTarget = 44.0;

  /// Larguras do menu suspenso de categorias (desktop).
  final double dropdownMinWidth = 260.0;
  final double dropdownMaxWidth = 340.0;

  /// Largura máxima do painel do menu de celular e tablet.
  final double mobileMenuMaxWidth = 420.0;

  /// Duração das animações de menu (zero com movimento reduzido).
  final Duration menuAnimation = const Duration(milliseconds: 160);
}

/// Escala de espaçamento em passos de 4 px.
class SpacingScale {
  const SpacingScale._();

  final double s4 = 4.0;
  final double s8 = 8.0;
  final double s12 = 12.0;
  final double s16 = 16.0;
  final double s20 = 20.0;
  final double s24 = 24.0;
  final double s32 = 32.0;
  final double s40 = 40.0;
  final double s48 = 48.0;
  final double s64 = 64.0;
  final double s96 = 96.0;
}

/// Raios de canto usados no protótipo.
class RadiiScale {
  const RadiiScale._();

  final double r6 = 6.0;
  final double r8 = 8.0;
  final double r10 = 10.0;
  final double r12 = 12.0;
  final double r14 = 14.0;
  final double r16 = 16.0;
  final double r18 = 18.0;
  final double r20 = 20.0;

  /// Totalmente arredondado.
  final double pill = 999.0;
}

/// Sombras prontas para `BoxDecoration.boxShadow`.
class ShadowStyle {
  const ShadowStyle._();

  /// Cartões em repouso.
  List<BoxShadow> get soft => const [
        BoxShadow(
          color: Color(0x141F1B18),
          blurRadius: 26,
          offset: Offset(0, 10),
        ),
      ];

  /// Menus, painéis e cartões em hover.
  List<BoxShadow> get elevated => const [
        BoxShadow(
          color: Color(0x241F1B18),
          blurRadius: 36,
          offset: Offset(0, 14),
        ),
      ];
}

/// Contorno de foco visível padrão (teclado).
class FocusStyle {
  const FocusStyle._();

  final double width = 3.0;
  final double offset = 2.0;

  Color get color => AppColors.instance.accent;
}

class DimensionStyle {
  const DimensionStyle._({
    required this.mini,
    required this.small,
    required this.medium,
    required this.large,
    required this.huge,
    required this.massive,
    required this.immense,
    required this.gigantic,
  });

  final double mini;
  final double small;
  final double medium;
  final double large;
  final double huge;
  final double massive;
  final double immense;
  final double gigantic;
}
