import 'package:flutter/material.dart';

import '../calculators/decanter_3000g.dart';
import '../format.dart';
import '../theme.dart';

const Color _passGreen = Color(0xFF28A745);
const Color _failRed = Color(0xFFDC3545);

/// POLAT DECANTER 3000G: seçilen dekantör modelinin 3000G kontrolünü gösterir.
class Decanter3000gScreen extends StatefulWidget {
  const Decanter3000gScreen({super.key});

  @override
  State<Decanter3000gScreen> createState() => _Decanter3000gScreenState();
}

class _Decanter3000gScreenState extends State<Decanter3000gScreen> {
  String? _selectedModel;

  Decanter3000gAnalysis? get _analysis {
    final name = _selectedModel;
    if (name == null) {
      return null;
    }
    final model = decanter3000gModels.firstWhere((m) => m.model == name);
    return analyze3000g(model);
  }

  Widget _selector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ral5004,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'DEKANTÖR MODELİ SEÇİNİZ',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedModel,
                hint: const Text('-- Listeden Seçin --'),
                style: const TextStyle(
                  color: ral5004,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                items: [
                  for (final m in decanter3000gModels)
                    DropdownMenuItem<String>(
                      value: m.model,
                      child: Text(m.model),
                    ),
                ],
                onChanged: (value) => setState(() => _selectedModel = value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _banner() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: const Color(0xFFE8F5E9),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 6, color: _passGreen),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Mevcut Çalışma Devri 3000G'yi Sağlamaktadır.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value, String unit) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF888888),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            Text(
              unit,
              style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _checkCard(Decanter3000gCheck check) {
    final color = check.passed ? _passGreen : _failRed;
    final icon = check.passed
        ? Icons.check_circle
        : (check.kind == Decanter3000gCheckKind.strength
            ? Icons.warning_amber_rounded
            : Icons.cancel);
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 6, color: color),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(icon, color: color, size: 28),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '${check.title}: '),
                          TextSpan(
                            text: check.valueText,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: check.detail),
                          if (!check.passed) ...[
                            const TextSpan(text: ' | '),
                            TextSpan(
                              text: check.failureLabel,
                              style: const TextStyle(
                                color: _failRed,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ],
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _results(Decanter3000gAnalysis a) {
    return [
      if (a.meets3000gAlready) _banner(),
      const SizedBox(height: 20),
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _infoCard(
              'Maks. Çalışma Devri',
              formatNumber(a.maxRpm.toDouble(), decimals: 0),
              'rpm',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _infoCard(
              a.dynamicLabel,
              formatNumber(a.dynamicValue.toDouble(), decimals: 0),
              a.dynamicUnit,
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      for (final check in a.checks) _checkCard(check),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final analysis = _analysis;
    return Scaffold(
      appBar: AppBar(title: const Text('POLAT DECANTER 3000G')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'DEKANTÖRLER İÇİN 3000G KONTROL EKRANI',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'R&D DEKANTÖR',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              _selector(),
              if (analysis != null) ..._results(analysis),
              const SizedBox(height: 32),
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
