import 'package:flutter/material.dart';

import '../calculators/gearbox_torque.dart';
import '../format.dart';
import '../widgets/model_selector.dart';

/// Şanzıman tork bilgisi: şanzıman tipini seçince maksimum tork dayanımı (Nm) gösterilir.
class GearboxTorqueScreen extends StatefulWidget {
  const GearboxTorqueScreen({super.key});

  @override
  State<GearboxTorqueScreen> createState() => _GearboxTorqueScreenState();
}

class _GearboxTorqueScreenState extends State<GearboxTorqueScreen> {
  String? _selectedModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = _selectedModel;
    final entry = selected == null ? null : gearboxTorqueFor(selected);
    return Scaffold(
      appBar: AppBar(title: const Text('Şanzıman Tork Bilgisi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Şanzıman tipini seçin; maksimum tork dayanımı görünsün.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ModelSelector(
                title: 'ŞANZIMAN TİPİ SEÇİNİZ',
                models: gearboxTorqueModels,
                value: selected,
                onChanged: (value) => setState(() => _selectedModel = value),
              ),
              if (entry != null) ...[
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          entry.model,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Maks. Tork Dayanımı',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              formatNumber(entry.maxTorqueNm.toDouble(), decimals: 0),
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Nm',
                              style: TextStyle(fontSize: 16, color: Color(0xFF888888)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
