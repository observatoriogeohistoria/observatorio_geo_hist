part of '../app_theme.dart';

class AppTextStyles {
  const AppTextStyles._(this.breakpoint);

  factory AppTextStyles.forWidth(double width) {
    return AppTextStyles._(Breakpoint.fromWidth(width));
  }

  final Breakpoint breakpoint;

  static const String _displayFamily = 'BricolageGrotesque';
  static const String _bodyFamily = 'Figtree';

  static const List<String> _fallback = ['system-ui', 'Roboto', 'Arial'];

  double _size({
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
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

  TextStyle get display => _display(
        size: _size(mobile: 35, tablet: 54, desktop: 64),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.035,
      );

  TextStyle get h1 => _display(
        size: _size(mobile: 32, tablet: 40, desktop: 52),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.03,
      );

  TextStyle get h2 => _display(
        size: _size(mobile: 26, tablet: 30, desktop: 36),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get h3 => _display(
        size: _size(mobile: 18, tablet: 20, desktop: 20),
        weight: FontWeight.w700,
        height: 1.2,
        letterSpacingEm: -0.01,
      );

  TextStyle get featureTitle => _display(
        size: _size(mobile: 24, tablet: 32, desktop: 35),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get featureTitleSmall => _display(
        size: _size(mobile: 18, tablet: 22, desktop: 24),
        weight: FontWeight.w700,
        height: 1.2,
        letterSpacingEm: -0.01,
      );

  TextStyle get splitTitle => _display(
        size: _size(mobile: 27, tablet: 36, desktop: 40),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get listTitle => _display(
        size: _size(mobile: 18, tablet: 18, desktop: 18),
        weight: FontWeight.w700,
        height: 1.3,
        letterSpacingEm: 0,
      );

  TextStyle get videoCaption => _display(
        size: _size(mobile: 18, tablet: 24, desktop: 26),
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacingEm: 0,
      );

  TextStyle get memberName => _display(
        size: _size(mobile: 17, tablet: 17, desktop: 17),
        weight: FontWeight.w700,
        height: 1.3,
        letterSpacingEm: 0,
      );

  TextStyle get memberInitials => _display(
        size: _size(mobile: 24, tablet: 24, desktop: 24),
        weight: FontWeight.w700,
        height: 1,
        letterSpacingEm: 0,
      );

  TextStyle get memberRole => _body(
        size: _size(mobile: 14.5, tablet: 14.5, desktop: 14.5),
        weight: FontWeight.w400,
        height: 1.45,
      );

  TextStyle get ctaTitle => _display(
        size: _size(mobile: 24, tablet: 32, desktop: 35),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get reading => _body(
        size: _size(mobile: 17, tablet: 18, desktop: 18),
        weight: FontWeight.w400,
        height: 1.75,
      );

  TextStyle get readingListItem => _body(
        size: _size(mobile: 17, tablet: 17.5, desktop: 17.5),
        weight: FontWeight.w400,
        height: 1.65,
      );

  TextStyle get readingListNumber => _body(
        size: _size(mobile: 14, tablet: 14, desktop: 14),
        weight: FontWeight.w700,
        height: 1,
      );

  TextStyle get readingQuote => _display(
        size: _size(mobile: 20, tablet: 22.4, desktop: 22.4),
        weight: FontWeight.w500,
        height: 1.35,
        letterSpacingEm: -0.02,
      );

  TextStyle get readingSubtitle => _display(
        size: _size(mobile: 24, tablet: 27.2, desktop: 27.2),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get memberPageName => _display(
        size: _size(mobile: 32, tablet: 42, desktop: 48),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.03,
      );

  TextStyle get memberPageInitials => _display(
        size: _size(mobile: 48, tablet: 64, desktop: 64),
        weight: FontWeight.w800,
        height: 1,
        letterSpacingEm: 0,
      );

  TextStyle get stateTitle => _display(
        size: _size(mobile: 20.8, tablet: 20.8, desktop: 20.8),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get notFoundCode => _display(
        size: _size(mobile: 64, tablet: 92, desktop: 112),
        weight: FontWeight.w800,
        height: 1,
        letterSpacingEm: -0.04,
      );

  TextStyle get postTitle => _display(
        size: _size(mobile: 32, tablet: 42, desktop: 53),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.03,
      );

  TextStyle get postSubtitle => _body(
        size: _size(mobile: 18, tablet: 20, desktop: 22.4),
        weight: FontWeight.w400,
        height: 1.45,
      );

  TextStyle get postAuthorInitials => _display(
        size: _size(mobile: 16, tablet: 16, desktop: 16),
        weight: FontWeight.w700,
        height: 1,
        letterSpacingEm: 0,
      );

  TextStyle get postCardTitle => _display(
        size: _size(mobile: 20, tablet: 20, desktop: 20),
        weight: FontWeight.w600,
        height: 1.2,
        letterSpacingEm: -0.02,
      );

  TextStyle get postCardSummary => _body(
        size: _size(mobile: 15.5, tablet: 15.5, desktop: 15.5),
        weight: FontWeight.w400,
        height: 1.55,
      );

  TextStyle get listingBlockTitle => _display(
        size: _size(mobile: 24, tablet: 24, desktop: 24),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get areaTileTitle => _display(
        size: _size(mobile: 25.6, tablet: 32, desktop: 33.6),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get libraryDocTitle => _display(
        size: _size(mobile: 19.2, tablet: 19.2, desktop: 19.2),
        weight: FontWeight.w600,
        height: 1.3,
        letterSpacingEm: -0.02,
      );

  TextStyle get detailTitle => _display(
        size: _size(mobile: 28.8, tablet: 36, desktop: 44.8),
        weight: FontWeight.w800,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get factValue => _body(
        size: _size(mobile: 16, tablet: 16, desktop: 16),
        weight: FontWeight.w400,
        height: 1.55,
      );

  TextStyle get workListenTitle => _body(
        size: _size(mobile: 15.5, tablet: 15.5, desktop: 15.5),
        weight: FontWeight.w600,
        height: 1.3,
      );

  TextStyle get workListenHost => _body(
        size: _size(mobile: 14, tablet: 14, desktop: 14),
        weight: FontWeight.w400,
        height: 1.4,
      );

  TextStyle get libraryFilter => _body(
        size: _size(mobile: 14.5, tablet: 14.5, desktop: 14.5),
        weight: FontWeight.w600,
        height: 1.2,
      );

  TextStyle get tag => _body(
        size: _size(mobile: 12.5, tablet: 12.5, desktop: 12.5),
        weight: FontWeight.w500,
        height: 1.4,
      );

  TextStyle get formLabel => _body(
        size: _size(mobile: 15, tablet: 15, desktop: 15),
        weight: FontWeight.w600,
        height: 1.4,
      );

  TextStyle get formError => _body(
        size: _size(mobile: 14, tablet: 14, desktop: 14),
        weight: FontWeight.w500,
        height: 1.45,
      );

  TextStyle get confirmationTitle => _display(
        size: _size(mobile: 22.4, tablet: 25.6, desktop: 25.6),
        weight: FontWeight.w700,
        height: 1.12,
        letterSpacingEm: -0.02,
      );

  TextStyle get meta => _body(
        size: _size(mobile: 14.5, tablet: 14.5, desktop: 14.5),
        weight: FontWeight.w400,
        height: 1.5,
      );

  TextStyle get chip => _body(
        size: _size(mobile: 14, tablet: 14, desktop: 14),
        weight: FontWeight.w600,
        height: 1.2,
      );

  TextStyle get lead => _body(
        size: _size(mobile: 17, tablet: 20, desktop: 20),
        weight: FontWeight.w400,
        height: 1.55,
      );

  TextStyle get sectionLead => _body(
        size: _size(mobile: 17, tablet: 18, desktop: 18),
        weight: FontWeight.w400,
        height: 1.55,
      );

  TextStyle get badge => _body(
        size: _size(mobile: 14.5, tablet: 14.5, desktop: 14.5),
        weight: FontWeight.w600,
        height: 1.35,
      );

  TextStyle get regular => _body(
        size: _size(mobile: 16, tablet: 16, desktop: 16),
        weight: FontWeight.w400,
        height: 1.55,
      );

  TextStyle get small => _body(
        size: _size(mobile: 14, tablet: 14, desktop: 14),
        weight: FontWeight.w400,
        height: 1.5,
      );

  TextStyle get label => _body(
        size: _size(mobile: 12.5, tablet: 12.5, desktop: 13),
        weight: FontWeight.w700,
        height: 1.4,
        letterSpacingEm: 0.08,
      );
}
