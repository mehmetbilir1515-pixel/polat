import 'package:flutter/material.dart';

import 'main_bearing_lubrication_screen.dart';
import 'scroll_bearing_lubrication_screen.dart';

/// DEKANTÖR YAĞLAMA BİLGİSİ: önce Main Bearing / Helezon Rulmanı seçilir.
class BearingLubricationScreen extends StatelessWidget {
  const BearingLubricationScreen({super.key});

  Widget _choice(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget Function() screen,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => screen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  icon,
                  size: 30,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('DEKANTÖR YAĞLAMA BİLGİSİ')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'RULMAN YAĞLAMA BİLGİSİ',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rulman türünü seçin; ardından endüstriyel veya zeytinyağı dekantörünü ve modeli seçerek yağlama bilgisine ulaşın.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              _choice(
                context,
                icon: Icons.settings,
                title: 'Main Bearing',
                subtitle: 'Ana (tambur) rulmanları',
                screen: () => const MainBearingLubricationScreen(),
              ),
              _choice(
                context,
                icon: Icons.autorenew,
                title: 'Helezon Rulmanı',
                subtitle: 'Helezon rulmanları',
                screen: () => const ScrollBearingLubricationScreen(),
              ),
              const SizedBox(height: 24),
              Text(
                'created by MEHMET BİLİR',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFAAAAAA),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
