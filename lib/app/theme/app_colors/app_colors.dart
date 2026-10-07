part of '../app_theme.dart';

class AppColors {
  AppColors._();
  static AppColors get instance => AppColors._();

  Color white = const Color(0xffffffff);
  Color page = const Color(0xFFFFFFFF);
  Color surface = const Color(0xFFF7F5F2);
  Color ink = const Color(0xFF1F1B18);
  Color inkSecondary = const Color(0xFF5E5852);
  Color line = const Color(0xFFE6E1DA);
  Color lineStrong = const Color(0xFFCFC8BE);

  /// Borda de campo de formulário: único contorno do campo, precisa de 3:1 no branco (a [line] tem 1,3:1).
  Color fieldBorder = const Color(0xFF8A8178);

  Color accent = const Color(0xFFC94400);
  Color accentStrong = const Color(0xFFA33600);
  Color accentSoft = const Color(0xFFFFF0E6);
  Color accentSoftBorder = const Color(0xFFFFD2B8);

  /// Acento a 25 %, que mantém [accentStrong] acima de 4,5:1.
  Color textSelection = const Color(0x40C94400);

  Color footerBackground = const Color(0xFF1C1917);
  Color footerLine = const Color(0xFF37322E);
  Color footerText = const Color(0xFFD8D2CA);
  Color footerHighlight = const Color(0xFFFF9A62);

  Color imageScrim = const Color(0xFF14100E);

  Color skeletonBase = const Color(0xFFEEEAE4);
  Color skeletonHighlight = const Color(0xFFF8F6F3);

  Color onImageAccent = const Color(0xFFFFC9A6);

  Color onImageMuted = const Color(0xFFD8D2CA);

  Color imagePlaceholder = const Color(0xFF2B2622);

  Color videoCoverMid = const Color(0xFF3D4A4D);
  Color videoCoverEnd = const Color(0xFF7FA39B);

  Color videoBackdrop = const Color(0xFF1C1917);

  Color error = const Color(0xFFB3261E);

  Color errorSurface = const Color(0xFFFBE9E7);
  Color success = const Color(0xFF1C6B34);
  Color successSurface = const Color(0xFFE4F3E8);
  Color info = const Color(0xFF1E5AA8);
}
