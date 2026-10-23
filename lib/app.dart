import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class PolatApp extends StatelessWidget {
  const PolatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POLAT R&D',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B3C5D)),
      ),
      home: const HomeScreen(),
    );
  }
}
