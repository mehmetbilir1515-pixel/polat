import 'package:flutter/material.dart';

/// RAL 5004 (Siyah mavi) — ekran için yaklaşık değer.
const Color ral5004 = Color(0xFF1A1C2B);

/// RAL 1003 (Sinyal sarısı) — ekran için yaklaşık değer.
const Color ral1003 = Color(0xFFF9A800);

ThemeData buildPolatTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: ral5004,
    onPrimary: Colors.white,
    primaryContainer: ral1003,
    onPrimaryContainer: ral5004,
    secondary: ral1003,
    onSecondary: ral5004,
    secondaryContainer: Color(0xFFFFE3A3),
    onSecondaryContainer: ral5004,
    error: Color(0xFFB3261E),
    onError: Colors.white,
    surface: Color(0xFFFFFBF2),
    onSurface: ral5004,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: ral5004,
      foregroundColor: ral1003,
      iconTheme: IconThemeData(color: ral1003),
      titleTextStyle: TextStyle(
        color: ral1003,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ral1003,
        foregroundColor: ral5004,
        minimumSize: const Size.fromHeight(48),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ral5004,
        side: const BorderSide(color: ral5004),
        minimumSize: const Size(0, 48),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ral5004, width: 2),
      ),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
