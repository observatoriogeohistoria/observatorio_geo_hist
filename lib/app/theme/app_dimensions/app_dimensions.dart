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

  SpacingScale spacing = const SpacingScale._();
  RadiiScale radii = const RadiiScale._();
  ShadowStyle shadows = const ShadowStyle._();
  FocusStyle focus = const FocusStyle._();
  ComponentSizes components = const ComponentSizes._();
}

class ComponentSizes {
  const ComponentSizes._();

  final double navbarHeight = 68.0;

  final double environmentBannerHeight = 32.0;

  final double buttonMinHeightSmall = 40.0;
  final double buttonMinHeightRegular = 44.0;

  final double buttonTextSmall = 14.0;
  final double buttonTextMedium = 16.0;
  final double buttonTextBig = 18.0;

  final double buttonIconScale = 1.15;

  final double logoMark = 34.0;
  final double logoName = 19.0;
  final double logoSubtitle = 11.5;

  final double navItemText = 15.5;
  final double navIcon = 20.0;

  final double navbarOpacity = 0.94;
  final double scrimOpacity = 0.4;

  final double menuIconSize = 24.0;
  final double minTapTarget = 44.0;

  final double dropdownMinWidth = 260.0;
  final double dropdownMaxWidth = 340.0;

  final double mobileMenuMaxWidth = 420.0;

  final Duration menuAnimation = const Duration(milliseconds: 160);

  final double arrowLinkGap = 6.0;
  final double arrowLinkGapHover = 9.0;
  final Duration arrowLinkAnimation = const Duration(milliseconds: 150);

  double heroPaddingTop(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 48, 80, 104);

  double heroPaddingBottom(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 40, 48, 64);

  double heroShortcutsGap(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 36, 48, 60);

  final double heroTitleGap = 14.0;

  final double heroActionsGap = 30.0;

  /// Sem `text-wrap: balance` no Flutter, 8,4 em reproduz a quebra em três linhas.
  final double heroTitleMaxWidthEm = 8.4;

  final double heroLeadMaxWidth = 770.0;

  final double heroShortcutsStackTextScale = 1.3;

  final double shortcutIconBox = 46.0;
  final double shortcutIcon = 22.0;

  final double shortcutHoverLift = 2.0;

  final Duration shortcutAnimation = const Duration(milliseconds: 150);

  final double categoriesDialogMaxWidth = 420.0;

  final double heroRingAccentOpacity = 0.11;
  final double heroRingInkOpacity = 0.06;
  final double heroRingAccentStep = 27.0;
  final double heroRingInkStep = 35.0;
  final double heroRingFadeStart = 0.55;

  final Offset heroRingAccentCenter = const Offset(0.86, 0.18);
  final Offset heroRingInkCenter = const Offset(0.08, 1.10);

  double sectionPaddingVertical(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 48, 72, 96);

  final double sectionHeadGap = 28.0;

  double featuredGridHeight(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 0, 400, 440);

  final double featuredMainHeightMobile = 260.0;

  final double featuredCompactThumbWidth = 112.0;
  final double featuredCompactThumbAspectRatio = 4 / 3;
  final double featuredCompactGap = 14.0;
  final double featuredCompactTextGap = 4.0;

  final double featuredGap = 16.0;

  final int featuredMainFlex = 16;
  final int featuredSideFlex = 10;

  double featuredTextPadding(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 20, 24, 24);

  final double featuredTextGap = 8.0;

  final double featuredTitleMaxWidthEm = 12.0;

  final int featuredTitleMaxLines = 3;

  /// Garante 4,5:1 mesmo com foto branca por trás.
  final double featuredScrimBottomOpacity = 0.88;
  final double featuredScrimTextOpacity = 0.72;

  final double featuredScrimFade = 72.0;

  final double featuredPlaceholderIcon = 28.0;

  final Duration featuredImageFade = const Duration(milliseconds: 200);

  double whoWeAreGap(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 28, 44, 72);

  final int whoWeAreIntroFlex = 20;
  final int whoWeAreAudienceFlex = 23;

  final double whoWeAreStackTextScale = 1.3;

  final double whoWeAreTitleGap = 10.0;
  final double whoWeAreTextGap = 16.0;
  final double whoWeAreLinkGap = 22.0;

  final double whoWeAreTextMaxWidth = 560.0;

  final double audienceListTop = 8.0;
  final double audienceItemGap = 12.0;
  final double audienceItemPadding = 18.0;
  final double audienceIconGap = 16.0;
  final double audienceTextGap = 2.0;

  final double audienceIconBox = 44.0;
  final double audienceIcon = 20.0;

  double videoAspectRatio(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 1.6, 2.0, 2.0);

  final double videoMaxHeight = 460.0;

  double videoCaptionPaddingHorizontal(Breakpoint breakpoint) =>
      _byBreakpoint(breakpoint, 20, 24, 24);
  double videoCaptionPaddingBottom(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 16, 20, 20);

  final int videoCaptionMaxLines = 2;

  final double videoCaptionActionGap = 16.0;

  final double videoCaptionScrimOpacity = 0.72;
  final double videoCaptionScrimFade = 72.0;

  final double videoPlayCircle = 46.0;
  final double videoPlayIcon = 26.0;
  final double videoPlayPadding = 10.0;
  final double videoPlayPaddingEnd = 22.0;
  final double videoPlayGap = 14.0;

  final double videoPlayCircleMobile = 34.0;
  final double videoPlayIconMobile = 20.0;
  final double videoPlayPaddingMobile = 6.0;
  final double videoPlayPaddingEndMobile = 16.0;
  final double videoPlayGapMobile = 10.0;
  final double videoPlayHoverScale = 1.03;
  final Duration videoAnimation = const Duration(milliseconds: 150);

  final double videoLoadingIndicator = 22.0;

  final double videoRingStep = 31.0;
  final double videoRingOpacity = 0.08;
  final Offset videoRingCenter = const Offset(0.75, 0.35);

  final double videoCoverAngleDegrees = 150.0;
  final double videoCoverMidStop = 0.6;

  final double videoControlsScrimOpacity = 0.72;
  final double videoControlsScrimHeight = 72.0;

  final double videoControlsScrimSolidFrom = 0.4;

  final double videoControlsInset = 8.0;

  final double videoErrorMaxWidth = 360.0;

  final double ourHistorySummaryMaxWidth = 720.0;

  final double ourHistoryTitleGap = 10.0;
  final double ourHistoryBadgeGap = 20.0;
  final double ourHistoryTextGap = 22.0;
  final double ourHistoryLinkGap = 22.0;

  final double milestoneBadgePaddingVertical = 8.0;
  final double milestoneBadgePaddingHorizontal = 16.0;
  final double milestoneBadgeIconGap = 10.0;
  final double milestoneBadgeIcon = 16.0;

  final double readingMaxWidth = 680.0;
  final double readingParagraphGap = 20.0;

  final double teamColumnMinWidth = 190.0;

  final double teamColumnGap = 20.0;
  final double teamRowGap = 28.0;

  final int teamColumnsMobile = 2;
  final double teamStackTextScale = 1.3;

  final double memberAvatar = 76.0;
  final double memberAvatarGap = 10.0;
  final double memberTextGap = 4.0;

  final double memberAvatarHoverScale = 1.05;
  final Duration memberAnimation = const Duration(milliseconds: 150);

  final double memberSkeletonBarHeight = 14.0;
  final double memberSkeletonNameWidth = 0.7;
  final double memberSkeletonRoleWidth = 0.5;

  final double partnerColumnMinWidth = 150.0;
  final double partnerColumnMinWidthSmall = 130.0;

  final double partnerGap = 12.0;
  final double partnerPadding = 12.0;

  final int partnerColumnsMobile = 3;
  final double partnerPaddingMobile = 6.0;

  final double partnerLogoMaxWidth = 150.0;
  final double partnerLogoAspectRatio = 280 / 186;

  final double partnerRestOpacity = 0.55;
  final double partnerHoverLift = 3.0;
  final double partnerHoverScale = 1.05;
  final Duration partnerAnimation = const Duration(milliseconds: 200);

  double ctaPadding(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 28, 46, 56);

  final double ctaTextGap = 8.0;
  final double ctaButtonGap = 24.0;

  final double ctaTitleMaxWidthEm = 14.3;
  final double ctaTextMaxWidth = 533.0;

  final double ctaStackTextScale = 1.3;

  final double pageHeadPaddingTop = 28.0;
  double pageHeadPaddingBottom(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 32, 46, 56);
  final double pageHeadTitleGap = 22.0;
  final double pageHeadLeadGap = 14.0;

  final double breadcrumbGap = 6.0;
  final double breadcrumbIcon = 13.0;

  final double readingPaddingTop = 40.0;
  double readingPaddingBottom(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 40, 56, 64);

  final double readingListNumberDiameter = 30.0;
  final double readingListNumberColumn = 34.0;
  final double readingListNumberGap = 14.0;
  final double readingListItemGap = 14.0;
  final double readingListNumberTopOffset = 3.0;
  final double readingListMarginVertical = 25.0;

  final double readingQuoteBar = 3.0;
  final double readingQuotePaddingLeft = 22.0;
  final double readingQuotePaddingVertical = 4.0;
  final double readingQuoteMarginVertical = 29.0;

  final double readingSubtitleMarginTop = 46.0;
  final double readingSubtitleMarginBottom = 16.0;

  final double readingBulletIndent = 22.0;
  final double readingBulletDot = 6.0;
  final double readingBulletItemGap = 7.0;
  final double readingBulletListMarginVertical = 18.0;

  final double readingFigureMaxWidth = 920.0;
  final double readingFigureAspect = 21 / 9;
  final double readingFigureCaptionGap = 10.0;
  final double readingFigureMarginBottom = 40.0;
  final double readingFigurePlaceholderIcon = 34.0;

  final double memberPageMaxWidth = 920.0;
  final double memberPortraitMaxWidth = 300.0;
  final double memberPortraitStackedMaxWidth = 280.0;
  final double memberPageStackBreak = 700.0;

  double memberPageGap(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 24, 38, 56);

  final double memberPageTopGap = 12.0;
  final double memberNameTopGap = 8.0;
  final double memberNameBottomGap = 18.0;
  final double memberLattesGap = 22.0;
  final double memberPageBottomGap = 64.0;

  final double memberPageSkeletonNameHeight = 40.0;
  final double memberPageSkeletonCrumbsWidth = 0.3;
  final double memberPageSkeletonLabelWidth = 0.25;
  final double memberPageSkeletonNameWidth = 0.7;
  final double memberPageSkeletonLastLineWidth = 0.6;

  final double stateBoxPaddingVertical = 40.0;
  final double stateBoxPaddingHorizontal = 20.0;
  final double stateBoxIcon = 52.0;
  final double stateBoxIconGlyph = 24.0;
  final double stateBoxGap = 10.0;
  final double stateBoxButtonGap = 6.0;
  final double stateBoxTextMaxWidth = 380.0;

  final double postHeadMaxWidth = 820.0;

  final double postTitleGap = 22.0;
  final double postSubtitleGap = 14.0;
  final double postBylineMarginTop = 26.0;
  final double postBylinePaddingVertical = 18.0;
  final double postBylineGap = 16.0;

  final double postAuthorAvatar = 44.0;
  final double postAuthorGap = 12.0;

  final double postCoverMarginTop = 28.0;
  final double postCoverAspect = 21 / 9;
  final double postCoverCaptionGap = 10.0;

  final double postBodyPaddingTop = 40.0;

  final double shareIconButton = 38.0;
  final double shareIcon = 22.0;
  final double shareGap = 4.0;

  final double shareLabelGap = 6.0;
  final double shareCopyGap = 6.0;
  final double shareRowGap = 4.0;
  final Duration shareFeedbackDuration = const Duration(milliseconds: 1800);

  final double readingImageMaxHeight = 560.0;
  final double readingImageMarginVertical = 24.0;
  final double readingImagePlaceholderAspect = 16 / 10;

  final double postNoteMarginTop = 40.0;
  final double postNotePaddingVertical = 20.0;
  final double postNotePaddingHorizontal = 24.0;
  final double postNoteLabelGap = 6.0;
  final double postNoteIconGap = 8.0;

  final double postCardMinWidth = 300.0;
  final int postCardMaxColumns = 3;
  final double postCardGapH = 28.0;
  final double postCardGapV = 36.0;
  final double postCardInnerGap = 14.0;
  final double postCardThumbAspect = 16 / 10;
  final double postCardThumbLift = 4.0;
  final int postCardTitleMaxLines = 3;
  final int postCardSummaryMaxLines = 2;
  final double postCardTitleGap = 4.0;
  final Duration postCardAnimation = const Duration(milliseconds: 250);

  final double postCardSkeletonLabelHeight = 14.0;
  final double postCardSkeletonTitleHeight = 22.0;
  final double postCardSkeletonLabelWidth = 0.3;
  final double postCardSkeletonTitleWidth = 0.85;
  final double postCardSkeletonMetaWidth = 0.55;

  final double searchFieldHeight = 48.0;
  final double searchFieldMinWidth = 320.0;
  final double searchFieldMaxWidth = 520.0;
  final double searchFieldIconInset = 14.0;
  final double searchFieldPaddingStart = 44.0;
  final double searchFieldPaddingEnd = 84.0;
  final double searchFieldClearInset = 8.0;
  final double searchFieldClearPaddingH = 10.0;
  final double searchFieldClearPaddingV = 6.0;
  final double searchFieldBorder = 1.5;
  final double searchFieldFocusRing = 4.0;
  final Duration searchDebounce = const Duration(milliseconds: 400);

  final double chipPaddingH = 14.0;
  final double chipPaddingV = 7.0;
  final double chipGap = 8.0;
  final double chipCountGap = 6.0;

  final double listingToolbarPaddingTop = 24.0;
  final double listingToolbarPaddingBottom = 8.0;
  final double listingToolbarGap = 16.0;
  final double listingCountPaddingTop = 4.0;
  final double listingCountPaddingBottom = 20.0;
  final double listingBlockPaddingTop = 20.0;
  final double listingBlockPaddingBottom = 12.0;
  final double listingBlockTitleGap = 20.0;
  final double listingBlockCountGap = 10.0;
  final double listingMorePaddingTop = 28.0;
  final double listingMorePaddingBottom = 56.0;
  final double listingMoreErrorGap = 12.0;
  final double listingStatePaddingTop = 24.0;
  final double listingStatePaddingBottom = 40.0;
  final double listingBottomGap = 40.0;

  final double pageHeadActionGap = 22.0;

  final double pageHeadSkeletonCrumbsWidth = 0.3;
  final double pageHeadSkeletonTitleWidth = 0.55;
  final double pageHeadSkeletonLastLineWidth = 0.7;

  final double postPlaceholderIcon = 34.0;

  final double postSkeletonBarHeight = 14.0;
  final double postSkeletonTitleHeight = 40.0;
  final double postSkeletonCrumbsWidth = 0.35;
  final double postSkeletonTitleLastWidth = 0.6;
  final double postSkeletonSubtitleWidth = 0.8;
  final double postSkeletonNameWidth = 0.3;
  final double postSkeletonDateWidth = 0.2;
  final double postSkeletonLastLineWidth = 0.6;
  final int postSkeletonLines = 5;

  final double supportPaddingVertical = 48.0;
  final double supportColumnsBreak = 820.0;
  final double supportColumnGapH = 64.0;
  final double supportColumnGapV = 32.0;
  final double supportLabelGap = 14.0;

  final double socialPillPaddingH = 14.0;
  final double socialPillPaddingV = 9.0;
  final double socialPillGap = 8.0;
  final double socialPillIcon = 18.0;

  double areaTilePadding(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 24, 30, 36);
  final double areaTileGap = 14.0;
  final double areaTileIconBox = 52.0;
  final double areaTileIcon = 26.0;
  final double areaTileStatsPaddingTop = 14.0;
  final double areaTileStatsGap = 20.0;
  final double areaTileLift = 3.0;
  final double areaTileGridGap = 20.0;
  final double areaTilesPaddingTop = 40.0;
  final double areaTilesPaddingBottom = 72.0;
  final double areaTileSkeletonWidth = 110.0;
  final double areaTileSkeletonHeight = 16.0;
  final Duration areaTileAnimation = const Duration(milliseconds: 200);

  final double libraryFiltersTop = 16.0;
  final double libraryFilterGap = 10.0;
  final double libraryFilterHeight = 42.0;
  final double libraryFilterBorder = 1.5;
  final double libraryFilterPaddingStart = 14.0;
  final double libraryFilterPaddingEnd = 12.0;
  final double libraryFilterIconGap = 8.0;
  final double libraryFilterIcon = 18.0;
  final double libraryFilterBadgePaddingH = 8.0;
  final double libraryFilterBadgePaddingV = 1.0;
  final double libraryYearFieldWidth = 96.0;
  final int libraryYearDigits = 4;

  final double libraryPanelMaxWidth = 360.0;
  final double libraryPanelMaxHeight = 400.0;
  final double libraryPanelOffset = 6.0;
  final double libraryPanelElevation = 8.0;
  final double libraryPanelPadding = 10.0;
  final double libraryPanelItemPadding = 8.0;
  final double libraryPanelFooterPaddingTop = 8.0;

  final double libraryActiveRowTop = 14.0;
  final double libraryActiveRowGap = 8.0;
  final double libraryActiveChipPaddingStart = 14.0;
  final double libraryActiveChipPaddingEnd = 6.0;
  final double libraryActiveChipPaddingV = 5.0;
  final double libraryActiveChipRemove = 24.0;
  final double libraryActiveChipRemoveIcon = 15.0;
  final double libraryActiveChipRemoveGap = 4.0;

  final double libraryCountPaddingTop = 20.0;
  final double libraryCountPaddingBottom = 8.0;

  final double libraryDocPaddingV = 22.0;
  final double libraryDocPaddingH = 16.0;
  final double libraryDocGapV = 8.0;
  final double libraryDocGapH = 24.0;
  final double libraryDocSideGap = 14.0;
  final double libraryDocArrow = 20.0;
  final double libraryDocStackBreak = 560.0;
  final int libraryDocTitleMaxLines = 3;
  final int libraryDocMaxCategories = 2;
  final double libraryTagGap = 6.0;
  final double libraryTagPaddingH = 8.0;
  final double libraryTagPaddingV = 2.0;
  final double libraryBadgePaddingH = 10.0;
  final double libraryBadgePaddingV = 4.0;
  final Duration libraryDocAnimation = const Duration(milliseconds: 150);

  final int librarySkeletonRows = 5;
  final double librarySkeletonTitleHeight = 20.0;
  final double librarySkeletonTitleWidth = 0.7;
  final double librarySkeletonMetaHeight = 14.0;
  final double librarySkeletonMetaWidth = 0.45;
  final double librarySkeletonTagWidth = 72.0;
  final double librarySkeletonTagHeight = 18.0;

  final double libraryDetailMaxWidth = 920.0;
  final double libraryDetailBadgeTop = 22.0;
  final double libraryDetailTitleTop = 12.0;
  final double libraryDetailActionTop = 22.0;

  final double libraryFactsTop = 24.0;
  final double libraryFactsPaddingV = 20.0;
  final double libraryFactsGapV = 14.0;
  final double libraryFactsGapH = 28.0;
  final double libraryFactsMinColumn = 170.0;
  final int libraryFactsMaxColumns = 4;
  final double libraryFactLabelGap = 2.0;

  final double libraryViewerMarginTop = 32.0;
  double libraryViewerMarginBottom(Breakpoint breakpoint) => _byBreakpoint(breakpoint, 40, 56, 64);
  final double libraryViewerBarPaddingV = 8.0;
  final double libraryViewerBarPaddingH = 14.0;
  final double libraryViewerButton = 32.0;
  final double libraryViewerButtonIcon = 20.0;
  final double libraryViewerButtonGap = 6.0;
  final double libraryViewerPageMaxWidth = 560.0;
  final double libraryViewerPageWidthFactor = 0.86;
  final double libraryViewerPageMargin = 24.0;
  final double libraryViewerStatePadding = 20.0;

  /// Largura sobre altura de uma folha A4, usada antes de saber a proporção do PDF.
  final double libraryViewerA4Aspect = 1 / 1.414;

  final double libraryDetailSkeletonBadgeWidth = 96.0;
  final double libraryDetailSkeletonBadgeHeight = 26.0;
  final double libraryDetailSkeletonTitleHeight = 34.0;
  final double libraryDetailSkeletonTitleGap = 10.0;
  final double libraryDetailSkeletonTitleLastWidth = 0.6;
  final double libraryDetailSkeletonLabelWidth = 64.0;
  final double libraryDetailSkeletonLabelHeight = 12.0;
  final double libraryDetailSkeletonValueWidth = 120.0;
  final double libraryDetailSkeletonValueHeight = 18.0;
  final double libraryDetailSkeletonButtonWidth = 200.0;
  final double libraryDetailSkeletonViewerHeight = 320.0;

  double _byBreakpoint(
    Breakpoint breakpoint,
    double mobile,
    double tablet,
    double desktop,
  ) {
    return switch (breakpoint) {
      Breakpoint.mobile => mobile,
      Breakpoint.tablet => tablet,
      Breakpoint.desktop => desktop,
    };
  }
}

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

  final double pill = 999.0;
}

class ShadowStyle {
  const ShadowStyle._();

  List<BoxShadow> get soft => const [
        BoxShadow(color: Color(0x141F1B18), blurRadius: 26, offset: Offset(0, 10)),
      ];

  List<BoxShadow> get lifted => const [
        BoxShadow(color: Color(0x1A1F1B18), blurRadius: 34, offset: Offset(0, 14)),
      ];

  List<BoxShadow> get elevated => const [
        BoxShadow(color: Color(0x241F1B18), blurRadius: 36, offset: Offset(0, 14)),
      ];

  /// Animar até uma lista vazia mostra a sombra nítida por um instante; esmaecer a cor
  /// faz ela sumir junto com o fundo. Em repouso, use `null`: sombra transparente ainda é pintada.
  List<BoxShadow> fade(List<BoxShadow> shadows, double opacity) => [
        for (final shadow in shadows)
          shadow.copyWith(color: shadow.color.withValues(alpha: shadow.color.a * opacity)),
      ];
}

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
