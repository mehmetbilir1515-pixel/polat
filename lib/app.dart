import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme.dart';

class PolatApp extends StatelessWidget {
  const PolatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POLAT R&D',
      debugShowCheckedModeBanner: false,
      theme: buildPolatTheme(),
      home: const HomeScreen(),
    );
  }
}
