import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// RAL 5004 (Siyah mavi) — ekran için yaklaşık değer.
const Color ral5004 = Color(0xFF1A1C2B);

/// RAL 1003 (Sinyal sarısı) — ekran için yaklaşık değer.
const Color ral1003 = Color(0xFFF9A800);

/// Koyu temada sayfa zemini: RAL 5004'ten daha koyu bir ton (kartlar RAL 5004 olur).
const Color _darkScaffold = Color(0xFF0E0F18);

/// Koyu temada alan dolgusu: RAL 5004'ün açılmış tonu.
const Color _darkField = Color(0xFF262940);

bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

/// Açık temada eski sabit gri tonlar BİREBİR korunur; koyu temada okunur karşılıkları kullanılır.
/// (Ekranlardaki `Color(0xFF666666)` vb. sabitlerin yerini alır.)
Color mutedColor(BuildContext context) =>
    isDark(context) ? const Color(0xFFB4B7C4) : const Color(0xFF666666);

Color subtleColor(BuildContext context) =>
    isDark(context) ? const Color(0xFFA0A3B2) : const Color(0xFF888888);

Color noteBlueColor(BuildContext context) =>
    isDark(context) ? const Color(0xFF9CBCEB) : const Color(0xFF2C5282);

Color footnoteColor(BuildContext context) =>
    isDark(context) ? const Color(0xFFA9BBC8) : const Color(0xFF5A6E7C);

/// Boyuta özgü harf aralığı (Apple): büyük başlıklar sıkı, küçük metin hafif açık.
TextTheme _tracked(TextTheme t) {
  TextStyle? s(TextStyle? style, double tracking) => style?.copyWith(letterSpacing: tracking);
  return t.copyWith(
    displayLarge: s(t.displayLarge, -1.0),
    displayMedium: s(t.displayMedium, -0.8),
    displaySmall: s(t.displaySmall, -0.6),
    headlineLarge: s(t.headlineLarge, -0.6),
    headlineMedium: s(t.headlineMedium, -0.5),
    headlineSmall: s(t.headlineSmall, -0.4),
    titleLarge: s(t.titleLarge, -0.3),
    titleMedium: s(t.titleMedium, -0.2),
    titleSmall: s(t.titleSmall, -0.1),
    bodyLarge: s(t.bodyLarge, -0.1),
    bodyMedium: s(t.bodyMedium, 0),
    bodySmall: s(t.bodySmall, 0.1),
    labelLarge: s(t.labelLarge, 0),
    labelMedium: s(t.labelMedium, 0.2),
    labelSmall: s(t.labelSmall, 0.3),
  );
}

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
  return _build(
    scheme,
    cardColor: Colors.white,
    fieldFill: Colors.white,
    hairline: ral5004.withValues(alpha: 0.10),
    focusColor: ral5004,
    outlinedColor: ral5004,
    outlinedSide: ral5004,
  );
}

/// Koyu tema: açık temadaki RAL 5004 / RAL 1003 renklerinden türetilir.
ThemeData buildPolatDarkTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: ral1003,
    onPrimary: ral5004,
    primaryContainer: ral1003,
    onPrimaryContainer: ral5004,
    secondary: ral1003,
    onSecondary: ral5004,
    secondaryContainer: Color(0xFF2E3250),
    onSecondaryContainer: Color(0xFFF2F2F7),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: _darkScaffold,
    onSurface: Color(0xFFF2F2F7),
    onSurfaceVariant: Color(0xFFB4B7C4),
  );
  return _build(
    scheme,
    cardColor: ral5004,
    fieldFill: _darkField,
    hairline: Colors.white.withValues(alpha: 0.08),
    focusColor: ral1003,
    outlinedColor: const Color(0xFFF2F2F7),
    outlinedSide: Colors.white.withValues(alpha: 0.35),
  );
}

ThemeData _build(
  ColorScheme scheme, {
  required Color cardColor,
  required Color fieldFill,
  required Color hairline,
  required Color focusColor,
  required Color outlinedColor,
  required Color outlinedSide,
}) {
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  final radius12 = BorderRadius.circular(12);
  OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
        borderRadius: radius12,
        borderSide: BorderSide(color: color, width: width),
      );

  return base.copyWith(
    scaffoldBackgroundColor: scheme.surface,
    textTheme: _tracked(base.textTheme),
    // iOS tarzı sayfa geçişi: kenardan kaydırarak geri dönülebilir, yay hissi taşır.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ral5004,
      foregroundColor: ral1003,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: ral1003),
      titleTextStyle: TextStyle(
        color: ral1003,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ral1003,
        foregroundColor: ral5004,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: outlinedColor,
        side: BorderSide(color: outlinedSide),
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border(hairline.withValues(alpha: 0.25), 1),
      enabledBorder: border(
        scheme.brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.18)
            : ral5004.withValues(alpha: 0.28),
        1,
      ),
      focusedBorder: border(focusColor, 2),
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: hairline),
      ),
    ),
    dividerTheme: DividerThemeData(color: hairline, space: 24, thickness: 1),
  );
}
