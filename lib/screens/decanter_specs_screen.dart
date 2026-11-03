import 'package:flutter/material.dart';

import '../calculators/decanter_specs.dart';
import '../format.dart';
import '../widgets/model_selector.dart';

/// Dekantör model değerleri: modeli seçince maksimum çalışma devri, gövde devri
/// hidrolik kapasite, katı çıkış çapı ve helezon boru çapı gösterilir.
/// 10° ve 15° yapıları olan modellerde iki açının değerleri birlikte görünür.
class DecanterSpecsScreen extends StatefulWidget {
  const DecanterSpecsScreen({super.key});

  @override
  State<DecanterSpecsScreen> createState() => _DecanterSpecsScreenState();
}

class _DecanterSpecsScreenState extends State<DecanterSpecsScreen> {
  String? _selectedModel;

  DecanterSpec? get _spec {
    final name = _selectedModel;
    if (name == null) {
      return null;
    }
    return decanterSpecs.firstWhere((s) => s.model == name);
  }

  Widget _valueCard(String label, String value, String unit) {
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
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            Text(
              unit,
              style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
            ),
          ],
        ),
      ),
    );
  }

  /// Çap kartı: tek yapılı modelde büyük değer, 10°/15° modellerde açı başına bir satır.
  Widget _diameterCard(String label, List<DiameterSet> sets, double Function(DiameterSet) pick) {
    String text(DiameterSet d) => formatCompact(pick(d), maxDecimals: 1);
    if (sets.length == 1) {
      return _valueCard(label, text(sets.single), 'mm');
    }
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
            const SizedBox(height: 8),
            for (final d in sets)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${d.angleDeg}°',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      text(d),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'mm',
                      style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spec = _spec;
    return Scaffold(
      appBar: AppBar(title: const Text('Dekantör Model Değerleri')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Modeli seçin; maksimum çalışma devri, gövde devri, hidrolik kapasite, katı çıkış çapı ve helezon boru çapı görünsün.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ModelSelector(
                models: [for (final s in decanterSpecs) s.model],
                value: _selectedModel,
                onChanged: (value) => setState(() => _selectedModel = value),
              ),
              if (spec != null) ...[
                const SizedBox(height: 20),
                _valueCard(
                  'Maks. Çalışma Devri',
                  formatNumber(spec.maxOperatingRpm.toDouble(), decimals: 0),
                  'rpm',
                ),
                _valueCard(
                  'Maks. Gövde Devri',
                  formatNumber(spec.maxBowlRpm.toDouble(), decimals: 0),
                  'rpm',
                ),
                _valueCard(
                  'Hidrolik Kapasite',
                  spec.hydraulicRangeText,
                  'm³/h',
                ),
                _diameterCard('Katı Çıkış Çapı', spec.diameters, (d) => d.solidsOutletMm),
                _diameterCard('Helezon Boru Çapı', spec.diameters, (d) => d.scrollPipeMm),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
