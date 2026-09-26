part of '../app_theme.dart';

class AppColors {
  AppColors._();
  static AppColors get instance => AppColors._();

  Color lightOrange = const Color.fromARGB(255, 255, 146, 67);
  Color orange = const Color(0xffff6900);

  Color amber = const Color(0xfffcb900);
  Color white = const Color(0xffffffff);

  Color lighterGray = const Color(0xFFF0F0F0);
  Color lightGray = const Color.fromARGB(255, 207, 206, 206);
  Color gray = const Color(0xFFABB8C3);
  Color darkGray = const Color.fromARGB(255, 53, 53, 53);

  Color red = const Color(0xFFE53935);
  Color green = const Color(0xFF43A047);
  Color blue = const Color(0xFF1E88E5);

  // Cores do redesign, nomeadas por função.
  Color page = const Color(0xFFFFFFFF);
  Color surface = const Color(0xFFF7F5F2);
  Color ink = const Color(0xFF1F1B18);
  Color inkSecondary = const Color(0xFF5E5852);
  Color line = const Color(0xFFE6E1DA);

  Color accent = const Color(0xFFC94400);
  Color accentStrong = const Color(0xFFA33600);
  Color accentSoft = const Color(0xFFFFF0E6);

  Color footerBackground = const Color(0xFF1C1917);
  Color footerLine = const Color(0xFF37322E);
  Color footerText = const Color(0xFFD8D2CA);
  Color footerHighlight = const Color(0xFFFF9A62);

  // Texto e fundo sobre fotos (cartões de destaque, spec 005).
  /// Véu escuro do degradê sobre a foto (`rgba(20,16,14)` do `.feat::before`).
  Color imageScrim = const Color(0xFF14100E);

  /// Rótulo sobre foto (`.feat .tag`).
  Color onImageAccent = const Color(0xFFFFC9A6);

  /// Texto secundário sobre foto (data do destaque).
  Color onImageMuted = const Color(0xFFD8D2CA);

  /// Fundo do cartão sem imagem, enquanto a imagem carrega ou quando ela falha.
  Color imagePlaceholder = const Color(0xFF2B2622);

  // Vídeo de apresentação da Home (spec 006).
  /// Meio e fim do degradê da capa gerada (`.video` do protótipo); o início é [ink].
  Color videoCoverMid = const Color(0xFF3D4A4D);
  Color videoCoverEnd = const Color(0xFF7FA39B);

  /// Fundo do quadro atrás do player (faixas escuras quando o vídeo é mais estreito).
  Color videoBackdrop = const Color(0xFF1C1917);

  Color error = const Color(0xFFB3261E);
  Color success = const Color(0xFF1C6B34);
  Color successSurface = const Color(0xFFE4F3E8);
}
