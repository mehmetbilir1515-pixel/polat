import 'package:flutter/material.dart';

import '../calculators/gearbox_torque.dart';
import '../format.dart';
import '../widgets/gearbox_lubrication_guide.dart';
import '../widgets/model_selector.dart';

/// Şanzıman tork ve yağlama bilgisi: şanzıman tipini seçince maksimum tork dayanımı (Nm),
/// yağ bilgisi (gres / sıvı), yağ miktarı ve yağ kodları gösterilir.
class GearboxTorqueScreen extends StatefulWidget {
  const GearboxTorqueScreen({super.key});

  @override
  State<GearboxTorqueScreen> createState() => _GearboxTorqueScreenState();
}

class _GearboxTorqueScreenState extends State<GearboxTorqueScreen> {
  String? _selectedModel;

  Widget _valueCard(String label, String value, {String? unit}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
                  value,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: const TextStyle(fontSize: 16, color: Color(0xFF888888)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = _selectedModel;
    final entry = selected == null ? null : gearboxTorqueFor(selected);
    return Scaffold(
      appBar: AppBar(title: const Text('Şanzıman Tork ve Yağlama Bilgisi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Şanzıman tipini seçin; maksimum tork dayanımı, yağ bilgisi ve yağ miktarı görünsün.',
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
                Text(
                  entry.model,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _valueCard(
                  'Maks. Tork Dayanımı',
                  formatNumber(entry.maxTorqueNm.toDouble(), decimals: 0),
                  unit: 'Nm',
                ),
                _valueCard('Yağ Bilgisi', entry.oil.label),
                _valueCard(
                  'Yağ Miktarı',
                  formatCompact(entry.oilAmount, maxDecimals: 1),
                  unit: entry.oil.unit,
                ),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(greaseCodeNote, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text(liquidOilCodeNote, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const GearboxLubricationGuide(),
            ],
          ),
        ),
      ),
    );
  }
}
