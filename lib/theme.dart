import 'package:flutter/material.dart';

extension WortlyColorContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}

ThemeData wortlyTheme({Brightness brightness = Brightness.light}) {
  final dark = brightness == Brightness.dark;
  final colors = ColorScheme.fromSeed(
    seedColor: const Color(0xFF244C3D),
    brightness: brightness,
    primary: dark ? const Color(0xFFB4D2A4) : const Color(0xFF244C3D),
    onPrimary: dark ? const Color(0xFF19351E) : Colors.white,
    surface: dark ? const Color(0xFF141C18) : const Color(0xFFF8F7F1),
    onSurface: dark ? const Color(0xFFE7ECE2) : const Color(0xFF263C32),
    onSurfaceVariant: dark ? const Color(0xFFB4BFB0) : const Color(0xFF647267),
    surfaceContainerLow: dark ? const Color(0xFF1E2821) : Colors.white,
    surfaceContainerHigh: dark
        ? const Color(0xFF2C382E)
        : const Color(0xFFE9EDE1),
    outlineVariant: dark ? const Color(0xFF414E41) : const Color(0xFFDFE3D8),
    secondary: dark ? const Color(0xFFA6B99A) : const Color(0xFF637A50),
    tertiary: dark ? const Color(0xFFE4B381) : const Color(0xFF915425),
    tertiaryContainer: dark ? const Color(0xFF483324) : const Color(0xFFF8EBDF),
    error: dark ? const Color(0xFFFFB4AB) : const Color(0xFF9B382D),
  );
  final forest = colors.primary;
  final ink = colors.onSurface;
  final muted = colors.onSurfaceVariant;
  final paper = colors.surface;
  final sage = colors.surfaceContainerHigh;
  final line = colors.outlineVariant;
  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: paper,
    fontFamily: 'DMSans',
    textTheme: TextTheme(
      displaySmall: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 38,
        height: 1.2,
        color: ink,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 32,
        height: 1.2,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 28,
        height: 1.25,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.55, color: ink),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: muted),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: paper,
      foregroundColor: ink,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: forest,
        foregroundColor: colors.onPrimary,
        minimumSize: const Size(48, 54),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 50),
        side: BorderSide(color: line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: paper,
      surfaceTintColor: Colors.transparent,
      indicatorColor: sage,
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: forest),
      ),
    ),
    dividerTheme: DividerThemeData(color: line, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: forest,
      contentTextStyle: TextStyle(
        color: colors.onPrimary,
        fontFamily: 'DMSans',
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
