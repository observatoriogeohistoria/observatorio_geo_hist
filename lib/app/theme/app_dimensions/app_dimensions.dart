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

  /// Ícone dos botões em relação ao texto (`.i` do protótipo: 1,15 em).
  final double buttonIconScale = 1.15;

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

  /// Link com seta (`.link-arrow`): vão entre o texto e a seta, em repouso e
  /// no hover, e duração da transição (zero com movimento reduzido).
  final double arrowLinkGap = 6.0;
  final double arrowLinkGapHover = 9.0;
  final Duration arrowLinkAnimation = const Duration(milliseconds: 150);

  // Hero da Home (spec 004). Origem: `.hero`, `.hero h1`, `.lead` e `.area`
  // do protótipo; os `clamp()` do CSS viraram um valor fixo por faixa.

  /// Respiro acima do conteúdo do hero (`padding-block` inicial).
  double heroPaddingTop(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 48, 80, 104);

  /// Respiro abaixo dos atalhos (`padding-block` final).
  double heroPaddingBottom(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 40, 48, 64);

  /// Vão entre os botões e os atalhos (`.areas` `margin-top`).
  double heroShortcutsGap(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 36, 48, 60);

  /// Vão entre o rótulo e o título (`margin-top: 14px`).
  final double heroTitleGap = 14.0;

  /// Vão entre o texto de apoio e os botões (`.hero-actions` `margin-top: 30px`).
  final double heroActionsGap = 30.0;

  /// Largura máxima do título, em múltiplos do tamanho da fonte. O protótipo usa
  /// `max-width: 15ch` com `text-wrap: balance` (três linhas equilibradas); sem
  /// `balance` no Flutter, 8,4 em reproduz a mesma quebra.
  final double heroTitleMaxWidthEm = 8.4;

  /// Largura máxima do texto de apoio (60 caracteres a 20 px).
  final double heroLeadMaxWidth = 770.0;

  /// A partir desta ampliação do texto (1,3 = 130%), os atalhos do hero ficam
  /// em uma coluna em qualquer largura, para os títulos não quebrarem no meio.
  final double heroShortcutsStackTextScale = 1.3;

  /// Quadro laranja suave do ícone dos atalhos e o ícone dentro dele.
  final double shortcutIconBox = 46.0;
  final double shortcutIcon = 22.0;

  /// Subida do cartão de atalho no hover.
  final double shortcutHoverLift = 2.0;

  /// Duração das transições do cartão de atalho (zero com movimento reduzido).
  final Duration shortcutAnimation = const Duration(milliseconds: 150);

  /// Largura máxima da janela de categorias de uma área.
  final double categoriesDialogMaxWidth = 420.0;

  /// Anéis do fundo do hero: opacidade da cor, passo entre anéis e fração da
  /// altura em que o desenho começa a se apagar em direção à base.
  final double heroRingAccentOpacity = 0.11;
  final double heroRingInkOpacity = 0.06;
  final double heroRingAccentStep = 27.0;
  final double heroRingInkStep = 35.0;
  final double heroRingFadeStart = 0.55;

  /// Centro de cada conjunto de anéis, em fração da largura e da altura
  /// (`circle at 86% 18%` e `circle at 8% 110%`).
  final Offset heroRingAccentCenter = const Offset(0.86, 0.18);
  final Offset heroRingInkCenter = const Offset(0.08, 1.10);

  // Seções da Home (spec 005 em diante). Origem: `.section` e `.section-head`.

  /// Respiro vertical de uma seção (`.section` `padding-block`).
  double sectionPaddingVertical(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 48, 72, 96);

  /// Vão entre o título da seção e o conteúdo (`.section-head` `margin-bottom`).
  final double sectionHeadGap = 28.0;

  // Destaques da Home (spec 005). Origem: `.featured` e `.feat` do protótipo.

  /// Altura total da grade de destaques no tablet e no desktop (`.featured`
  /// `min-height: 440px`; menor no tablet). No celular os cartões ficam em
  /// coluna, com as alturas abaixo, e este valor não é usado.
  double featuredGridHeight(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 0, 400, 440);

  /// Alturas dos cartões no celular, em coluna (`.feat.big` 340 px; menores 220 px).
  final double featuredMainHeightMobile = 340.0;
  final double featuredSmallHeightMobile = 220.0;

  /// Vão entre os cartões (`.featured` `gap`).
  final double featuredGap = 16.0;

  /// Proporção das colunas (`1.6fr 1fr`), em fatores de `flex`.
  final int featuredMainFlex = 16;
  final int featuredSideFlex = 10;

  /// Preenchimento interno do texto (`.feat .body` `padding`; menor no celular).
  double featuredTextPadding(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 20, 24, 24);

  /// Vão entre rótulo, título e data (`.feat .body` `gap`).
  final double featuredTextGap = 8.0;

  /// Largura máxima do título do destaque principal, em múltiplos do tamanho
  /// da fonte (`max-width: 22ch`; na Bricolage Grotesque o "0" mede cerca de
  /// 0,55 em, então 22 caracteres ≈ 12 em).
  final double featuredTitleMaxWidthEm = 12.0;

  /// Linhas máximas do título antes das reticências.
  final int featuredTitleMaxLines = 3;

  /// Opacidade do véu escuro atrás do texto: na base e no topo do bloco de
  /// texto. Garante 4,5:1 mesmo com foto branca por trás.
  final double featuredScrimBottomOpacity = 0.88;
  final double featuredScrimTextOpacity = 0.72;

  /// Altura da faixa em que o véu esmaece até sumir, acima do texto.
  final double featuredScrimFade = 72.0;

  /// Ícone de "sem imagem" no canto do cartão.
  final double featuredPlaceholderIcon = 28.0;

  /// Duração da entrada da foto depois de carregada (zero com movimento reduzido).
  final Duration featuredImageFade = const Duration(milliseconds: 200);

  // Quem somos da Home (spec 006). Origem: `.split`, `.for-list` e `.for`.

  /// Vão entre a apresentação e os públicos (`.split` `gap`; em coluna no
  /// celular e no tablet, lado a lado no desktop).
  double whoWeAreGap(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 28, 44, 72);

  /// Proporção das colunas no desktop (`1fr 1.15fr`), em fatores de `flex`.
  final int whoWeAreIntroFlex = 20;
  final int whoWeAreAudienceFlex = 23;

  /// A partir desta ampliação do texto (1,3 = 130%), Quem somos fica em uma
  /// coluna também no desktop, para o título não quebrar palavras ao meio.
  final double whoWeAreStackTextScale = 1.3;

  /// Vãos da apresentação: rótulo → título, título → texto e texto → link
  /// (`.split h2` `margin-block: 10px 16px`; link com `margin-top: 22px`).
  final double whoWeAreTitleGap = 10.0;
  final double whoWeAreTextGap = 16.0;
  final double whoWeAreLinkGap = 22.0;

  /// Largura máxima do texto de missão (60 caracteres a 18 px).
  final double whoWeAreTextMaxWidth = 560.0;

  /// Lista de públicos: distância do topo (`.for-list` `margin-top`), vão
  /// entre itens (`gap`), preenchimento vertical de cada item (`.for`
  /// `padding`), vão entre ícone e texto e entre nome e descrição (`.for p`).
  final double audienceListTop = 8.0;
  final double audienceItemGap = 12.0;
  final double audienceItemPadding = 18.0;
  final double audienceIconGap = 16.0;
  final double audienceTextGap = 2.0;

  /// Círculo laranja suave do ícone do público e o ícone dentro dele.
  final double audienceIconBox = 44.0;
  final double audienceIcon = 20.0;

  // Vídeo da Home (spec 006). Origem: `.video`, `.video-cap` e `.play`.

  /// Proporção do quadro (largura ÷ altura): 16 : 10 no celular, 16 : 8 no
  /// tablet e no desktop.
  double videoAspectRatio(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 1.6, 2.0, 2.0);

  /// Altura máxima do quadro (`max-height: 460px`).
  final double videoMaxHeight = 460.0;

  /// Preenchimento da legenda: laterais e base (`left/right: 24px`,
  /// `bottom: 20px`; menor no celular).
  double videoCaptionPaddingHorizontal(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 20, 24, 24);
  double videoCaptionPaddingBottom(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 16, 20, 20);

  /// Linhas máximas da legenda antes das reticências (texto ampliado).
  final int videoCaptionMaxLines = 2;

  /// Véu escuro atrás da legenda e faixa em que ele esmaece acima dela.
  /// Branco sobre 0,72 de véu com capa branca dá cerca de 7,6:1.
  final double videoCaptionScrimOpacity = 0.72;
  final double videoCaptionScrimFade = 72.0;

  /// Botão "Assistir": círculo laranja, ícone, preenchimento (`padding:
  /// 10px 22px 10px 10px`), vão entre círculo e texto, crescimento no hover
  /// e duração das transições (zero com movimento reduzido).
  final double videoPlayCircle = 46.0;
  final double videoPlayIcon = 26.0;
  final double videoPlayPadding = 10.0;
  final double videoPlayPaddingEnd = 22.0;
  final double videoPlayGap = 14.0;
  final double videoPlayHoverScale = 1.03;
  final Duration videoAnimation = const Duration(milliseconds: 150);

  /// Indicador de "Carregando vídeo" dentro do círculo.
  final double videoLoadingIndicator = 22.0;

  /// Anéis da capa gerada (`.video::after`): passo, opacidade do branco e
  /// centro em fração da largura e da altura (`circle at 75% 35%`).
  final double videoRingStep = 31.0;
  final double videoRingOpacity = 0.08;
  final Offset videoRingCenter = const Offset(0.75, 0.35);

  /// Ângulo do degradê da capa gerada (`linear-gradient(150deg, …)`) e posição
  /// da cor do meio (`60%`).
  final double videoCoverAngleDegrees = 150.0;
  final double videoCoverMidStop = 0.6;

  /// Véu atrás dos controles do player: opacidade na base e altura. Ícones
  /// brancos ficam acima de 3:1 mesmo sobre um quadro branco.
  final double videoControlsScrimOpacity = 0.72;
  final double videoControlsScrimHeight = 72.0;

  /// Fração da altura do véu dos controles em que ele chega à opacidade cheia.
  final double videoControlsScrimSolidFrom = 0.4;

  /// Afastamento dos controles do player em relação à borda esquerda e à base
  /// do quadro, para o contorno de foco não ser cortado pelos cantos.
  final double videoControlsInset = 8.0;

  /// Largura máxima da caixa de erro sobre a capa.
  final double videoErrorMaxWidth = 360.0;

  // Nossa história (spec 007). Origem: `.narrow`, `.fact`, `.prose` e
  // `.page-head .wrap` do protótipo.

  /// Largura máxima da coluna do resumo na Home (`.narrow`).
  final double ourHistorySummaryMaxWidth = 720.0;

  /// Vãos do resumo: rótulo → título, título → selo, selo → texto e texto → link.
  final double ourHistoryTitleGap = 10.0;
  final double ourHistoryBadgeGap = 20.0;
  final double ourHistoryTextGap = 22.0;
  final double ourHistoryLinkGap = 22.0;

  /// Selo do marco (`.fact`): preenchimento vertical e lateral, vão entre
  /// ícone e texto e tamanho do ícone.
  final double milestoneBadgePaddingVertical = 8.0;
  final double milestoneBadgePaddingHorizontal = 16.0;
  final double milestoneBadgeIconGap = 10.0;
  final double milestoneBadgeIcon = 16.0;

  /// Coluna de leitura das páginas de texto (`.prose` `max-width`) e vão entre
  /// parágrafos (1,1 em a 18 px).
  final double readingMaxWidth = 680.0;
  final double readingParagraphGap = 20.0;

  // Equipe na Home (spec 008). Origem: `.team`, `.member` e `.avatar` do protótipo.

  /// Largura mínima de coluna da grade (`minmax(190px, 1fr)`), antes da ampliação do texto.
  final double teamColumnMinWidth = 190.0;

  /// Vão entre colunas e entre linhas da grade (`gap: 28px 20px`).
  final double teamColumnGap = 20.0;
  final double teamRowGap = 28.0;

  /// Diâmetro da foto do membro e vãos foto → nome e nome → função.
  final double memberAvatar = 76.0;
  final double memberAvatarGap = 10.0;
  final double memberTextGap = 4.0;

  /// Aumento da foto no hover de membro clicável e duração (`transition: transform .15s`).
  final double memberAvatarHoverScale = 1.05;
  final Duration memberAnimation = const Duration(milliseconds: 150);

  /// Barras do esqueleto do membro: altura e larguras (fração da coluna) do nome e da função.
  final double memberSkeletonBarHeight = 14.0;
  final double memberSkeletonNameWidth = 0.7;
  final double memberSkeletonRoleWidth = 0.5;

  // Realização e apoio (spec 009). Origem: `.logos`, `.logos.small` e `.logo`.

  /// Largura mínima de coluna da grade de logos (`minmax(150px, 1fr)`) e da
  /// variante menor do post (`.logos.small`, 130 px).
  final double partnerColumnMinWidth = 150.0;
  final double partnerColumnMinWidthSmall = 130.0;

  /// Vão entre logos (`gap`) e respiro da área de cada logo (`.logo` `padding`).
  final double partnerGap = 12.0;
  final double partnerPadding = 12.0;

  /// Largura máxima do logo e proporção dos arquivos (280 × 186 px).
  final double partnerLogoMaxWidth = 150.0;
  final double partnerLogoAspectRatio = 280 / 186;

  /// Opacidade do logo em repouso, subida e crescimento no hover/foco e duração.
  final double partnerRestOpacity = 0.55;
  final double partnerHoverLift = 3.0;
  final double partnerHoverScale = 1.05;
  final Duration partnerAnimation = const Duration(milliseconds: 200);

  // Chamada para contato (spec 009). Origem: `.cta`, `.cta h2` e `.cta p`.

  /// Respiro interno do quadro (`clamp(28px, 6cqi, 56px)`).
  double ctaPadding(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 28, 46, 56);

  /// Vãos título → texto (`.cta p` `margin-top`) e textos → botão (`gap`).
  final double ctaTextGap = 8.0;
  final double ctaButtonGap = 24.0;

  /// Largura máxima do título em múltiplos do tamanho da fonte e do texto,
  /// medidas no protótipo (`max-width: 22ch` a 700 dá 14,3 em; `52ch` a 16 px
  /// dá 533 px).
  final double ctaTitleMaxWidthEm = 14.3;
  final double ctaTextMaxWidth = 533.0;

  /// A partir desta ampliação do texto (1,3 = 130%), o botão fica abaixo do
  /// texto também no desktop.
  final double ctaStackTextScale = 1.3;

  // Base de leitura (spec 010). Origem: `.page-head .wrap`, `.crumbs`,
  // `.article`, `.manifest-list` e `.prose blockquote` do protótipo.

  /// Cabeçalho de página: respiro acima das migalhas e abaixo do título,
  /// vão migalhas → título e título → texto de apoio.
  final double pageHeadPaddingTop = 28.0;
  double pageHeadPaddingBottom(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 32, 46, 56);
  final double pageHeadTitleGap = 22.0;
  final double pageHeadLeadGap = 14.0;

  /// Migalhas: vão entre item e seta e tamanho da seta.
  final double breadcrumbGap = 6.0;
  final double breadcrumbIcon = 13.0;

  /// Respiro da coluna de leitura acima do texto e antes do rodapé.
  final double readingPaddingTop = 40.0;
  double readingPaddingBottom(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 40, 56, 64);

  /// Lista numerada: diâmetro do círculo, largura da coluna do número, vão
  /// número → texto, vão entre itens, descida do círculo para alinhar à
  /// primeira linha e margem acima e abaixo da lista.
  final double readingListNumberDiameter = 30.0;
  final double readingListNumberColumn = 34.0;
  final double readingListNumberGap = 14.0;
  final double readingListItemGap = 14.0;
  final double readingListNumberTopOffset = 3.0;
  final double readingListMarginVertical = 25.0;

  /// Destaque: espessura da barra, recuo do texto, preenchimento vertical e
  /// margem acima e abaixo.
  final double readingQuoteBar = 3.0;
  final double readingQuotePaddingLeft = 22.0;
  final double readingQuotePaddingVertical = 4.0;
  final double readingQuoteMarginVertical = 29.0;

  // Blocos de leitura da spec 011. Origem: `.article .prose h2`,
  // `.article .prose ul` e `.banner` do protótipo.

  /// Subtítulo: margem acima (1,7 em) e abaixo (0,6 em).
  final double readingSubtitleMarginTop = 46.0;
  final double readingSubtitleMarginBottom = 16.0;

  /// Lista com marcadores: recuo do texto (1,2 em), diâmetro do marcador, vão
  /// entre itens (0,4 em) e margem acima e abaixo (1 em).
  final double readingBulletIndent = 22.0;
  final double readingBulletDot = 6.0;
  final double readingBulletItemGap = 7.0;
  final double readingBulletListMarginVertical = 18.0;

  /// Figura: largura máxima, proporção, vão imagem → legenda, vão até o texto
  /// abaixo e ícone do placeholder (`.noimg`).
  final double readingFigureMaxWidth = 920.0;
  final double readingFigureAspect = 21 / 9;
  final double readingFigureCaptionGap = 10.0;
  final double readingFigureMarginBottom = 40.0;
  final double readingFigurePlaceholderIcon = 34.0;

  // Pessoa da equipe (spec 011). Origem: `.member-page`, `.portrait` e
  // `.article-head` da aba "Membro" do protótipo.

  /// Largura do bloco, coluna da foto lado a lado e empilhada, e largura útil
  /// abaixo da qual foto e texto empilham (`@container (max-width:700px)`).
  final double memberPageMaxWidth = 920.0;
  final double memberPortraitMaxWidth = 300.0;
  final double memberPortraitStackedMaxWidth = 280.0;
  final double memberPageStackBreak = 700.0;

  /// Vão entre foto e texto (`clamp(24px, 5cqi, 56px)`).
  double memberPageGap(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 24, 38, 56);

  /// Vãos migalhas → foto, rótulo → nome, nome → descrição, descrição →
  /// Lattes e respiro antes do rodapé.
  final double memberPageTopGap = 12.0;
  final double memberNameTopGap = 8.0;
  final double memberNameBottomGap = 18.0;
  final double memberLattesGap = 22.0;
  final double memberPageBottomGap = 64.0;

  /// Esqueleto da pessoa: altura da barra do nome e larguras (fração da
  /// coluna) das migalhas, do rótulo, do nome e da última linha do texto.
  final double memberPageSkeletonNameHeight = 40.0;
  final double memberPageSkeletonCrumbsWidth = 0.3;
  final double memberPageSkeletonLabelWidth = 0.25;
  final double memberPageSkeletonNameWidth = 0.7;
  final double memberPageSkeletonLastLineWidth = 0.6;

  // Caixa de estado (`.state-box` e `.err-state` da aba "Estados").

  /// Preenchimento, ícone, vão entre itens, vão extra antes do botão e
  /// largura máxima do texto (44 ch a 16 px).
  final double stateBoxPaddingVertical = 40.0;
  final double stateBoxPaddingHorizontal = 20.0;
  final double stateBoxIcon = 52.0;
  final double stateBoxIconGlyph = 24.0;
  final double stateBoxGap = 10.0;
  final double stateBoxButtonGap = 6.0;
  final double stateBoxTextMaxWidth = 380.0;

  double _byBreakpoint(Breakpoint breakpoint, double mobile, double tablet, double desktop) {
    return switch (breakpoint) {
      Breakpoint.mobile => mobile,
      Breakpoint.tablet => tablet,
      Breakpoint.desktop => desktop,
    };
  }
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

  /// [shadows] com cor transparente, para o estado sem sombra de uma animação.
  /// Animar até uma lista vazia encolhe a sombra com a cor cheia, e ela
  /// aparece nítida por um instante sob um fundo que também esmaece.
  List<BoxShadow> hidden(List<BoxShadow> shadows) => [
        for (final shadow in shadows) shadow.copyWith(color: shadow.color.withValues(alpha: 0)),
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
