import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının seçtiği tema. Varsayılan AÇIK temadır (uygulamanın özgün görünümü);
/// koyu tema ve sistem ayarını izleme isteğe bağlıdır. Seçim cihazda saklanır.
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

const String _prefKey = 'theme_mode';

/// Kaydedilmiş tema seçimini yükler (yoksa açık tema kalır). Depolama
/// kullanılamıyorsa sessizce varsayılana döner.
Future<void> loadThemeMode() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    themeModeNotifier.value = switch (saved) {
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.light,
    };
  } catch (_) {
    // Depolama yok: varsayılan (açık) tema geçerli.
  }
}

/// Temayı değiştirir ve saklar.
Future<void> setThemeMode(ThemeMode mode) async {
  themeModeNotifier.value = mode;
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
      ThemeMode.light => 'light',
    });
  } catch (_) {
    // Saklanamadıysa seçim yalnızca bu oturumda geçerli olur.
  }
}
