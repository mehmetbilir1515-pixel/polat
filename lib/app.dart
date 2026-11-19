import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme.dart';
import 'theme_controller.dart';

class PolatApp extends StatelessWidget {
  const PolatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) => MaterialApp(
        title: 'POLAT R&D',
        debugShowCheckedModeBanner: false,
        theme: buildPolatTheme(),
        darkTheme: buildPolatDarkTheme(),
        themeMode: mode,
        home: const HomeScreen(),
      ),
    );
  }
}
