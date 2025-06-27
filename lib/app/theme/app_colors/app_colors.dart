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
}
