import 'package:flutter/material.dart';

const forest = Color(0xFF244C3D);
const ink = Color(0xFF263C32);
const muted = Color(0xFF647267);
const paper = Color(0xFFF8F7F1);
const sage = Color(0xFFE9EDE1);
const line = Color(0xFFDFE3D8);
const amber = Color(0xFF915425);

ThemeData wortlyTheme() {
  final colors = ColorScheme.fromSeed(
    seedColor: forest,
    brightness: Brightness.light,
    primary: forest,
    surface: paper,
    onSurface: ink,
    secondary: const Color(0xFF637A50),
    error: const Color(0xFF9B382D),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: paper,
    fontFamily: 'DMSans',
    textTheme: const TextTheme(
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
    appBarTheme: const AppBarTheme(
      backgroundColor: paper,
      foregroundColor: ink,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: forest,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 54),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 50),
        side: const BorderSide(color: line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: paper,
      surfaceTintColor: Colors.transparent,
      indicatorColor: sage,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: forest,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(color: line, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: forest,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
