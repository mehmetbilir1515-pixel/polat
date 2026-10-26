import 'package:flutter/material.dart';

import '../calculator_specs.dart';
import 'calculator_screen.dart';
import 'decanter_3000g_screen.dart';
import 'decanter_specs_screen.dart';
import 'mass_balance_screen.dart';

/// Ana ekran: dekantör ekranları ve tüm hesaplama araçlarının listesi.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget Function() screen,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => screen()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Özel ekranlar listenin başında, ardından tanımdan üretilen hesaplayıcılar gelir.
    final featured = <({IconData icon, String title, String subtitle, Widget Function() screen})>[
      (
        icon: Icons.analytics_outlined,
        title: 'Dekantör Kütle Denkliği',
        subtitle:
            'Besleme, kek ve sentrat kütle denkliği; polimer tüketimi ve yakalama verimi.',
        screen: () => const MassBalanceScreen(),
      ),
      (
        icon: Icons.verified_outlined,
        title: 'POLAT DECANTER 3000G',
        subtitle: 'Model seçin; rulman, şanzıman ve tambur dayanımını 3000G için kontrol edin.',
        screen: () => const Decanter3000gScreen(),
      ),
      (
        icon: Icons.table_chart_outlined,
        title: 'Dekantör Model Değerleri',
        subtitle: 'Model seçin; maks. çalışma devri, gövde devri ve hidrolik kapasiteyi görün.',
        screen: () => const DecanterSpecsScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/icon/icon.png',
                width: 32,
                height: 32,
                semanticLabel: 'POLAT R&D logosu',
              ),
            ),
            const SizedBox(width: 12),
            const Text('POLAT R&D'),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: featured.length + calculatorSpecs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index < featured.length) {
            final item = featured[index];
            return _tile(
              context,
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              screen: item.screen,
            );
          }
          final spec = calculatorSpecs[index - featured.length];
          return _tile(
            context,
            icon: spec.icon,
            title: spec.title,
            subtitle: spec.description,
            screen: () => CalculatorScreen(spec: spec),
          );
        },
      ),
    );
  }
}
