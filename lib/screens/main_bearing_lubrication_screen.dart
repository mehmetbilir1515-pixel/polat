import 'package:flutter/material.dart';

/// Main Bearing yağlama bilgisi. Veri henüz eklenmedi; veri geldiğinde bu ekran
/// Helezon Rulmanı ekranıyla aynı akışı izleyecek (endüstriyel / zeytinyağı → model).
class MainBearingLubricationScreen extends StatelessWidget {
  const MainBearingLubricationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Main Bearing')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Main Bearing yağlama verisi henüz eklenmedi.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Veri paylaşıldığında bu bölümde de endüstriyel veya zeytinyağı seçimi ve ardından model seçimi yapılabilecek.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
