import 'package:flutter/material.dart';

import '../calculator_specs.dart';
import 'calculator_screen.dart';

/// Ana ekran: tüm hesaplama araçlarının listesi.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('POLAT R&D')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: calculatorSpecs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final spec = calculatorSpecs[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(spec.icon, color: theme.colorScheme.onPrimaryContainer),
              ),
              title: Text(spec.title),
              subtitle: Text(spec.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CalculatorScreen(spec: spec),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
