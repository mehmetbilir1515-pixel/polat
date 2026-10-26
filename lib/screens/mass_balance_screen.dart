import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../calculators/mass_balance.dart';
import '../calculators/validation.dart';
import '../format.dart';
import '../theme.dart';

/// Giriş (veri girilen) alanların dolgu rengi.
const Color _inputFill = Color(0xFFFFE3A3);

/// Santrifüj dekantör kütle denkliği ekranı. Değerler yazıldıkça sonuçlar anında güncellenir.
class MassBalanceScreen extends StatefulWidget {
  const MassBalanceScreen({super.key});

  @override
  State<MassBalanceScreen> createState() => _MassBalanceScreenState();
}

class _MassBalanceScreenState extends State<MassBalanceScreen> {
  /// Başlangıç değerleri (hesap sayfasındaki örnek).
  static const Map<String, String> _defaults = {
    'flow': '7',
    'density': '1000',
    'feedSolids': '1,13',
    'polymerPct': '0,1',
    'polymerLph': '800',
    'cakeSolids': '18',
    'centrateSolids': '0,05',
    'akmPct': '0,10',
  };

  late final Map<String, TextEditingController> _c = {
    for (final entry in _defaults.entries)
      entry.key: TextEditingController(text: entry.value),
  };

  MassBalanceResult? _result;
  String? _error;
  double? _akm;
  String? _akmError;

  @override
  void initState() {
    super.initState();
    _compute();
  }

  @override
  void dispose() {
    for (final controller in _c.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double? _n(String key) => parseNumber(_c[key]!.text);

  void _compute() {
    final flow = _n('flow');
    final density = _n('density');
    final feedSolids = _n('feedSolids');
    final polymerPct = _n('polymerPct');
    final polymerLph = _n('polymerLph');
    final cakeSolids = _n('cakeSolids');
    final centrateSolids = _n('centrateSolids');

    if (flow == null ||
        density == null ||
        feedSolids == null ||
        polymerPct == null ||
        polymerLph == null ||
        cakeSolids == null ||
        centrateSolids == null) {
      _result = null;
      _error = 'Tüm alanlara geçerli bir sayı girin.';
    } else {
      try {
        _result = decanterMassBalance(
          feedFlowM3h: flow,
          feedDensityKgPerM3: density,
          feedSolidsPercent: feedSolids,
          cakeSolidsPercent: cakeSolids,
          centrateSolidsPercent: centrateSolids,
          polymerConcentrationPercent: polymerPct,
          polymerSolutionLph: polymerLph,
        );
        _error = null;
      } on CalculationException catch (e) {
        _result = null;
        _error = e.message;
      }
    }

    final akmPct = _n('akmPct');
    if (akmPct == null) {
      _akm = null;
      _akmError = 'Geçerli bir sayı girin.';
    } else {
      try {
        _akm = percentToAkmMgL(akmPct);
        _akmError = null;
      } on CalculationException catch (e) {
        _akm = null;
        _akmError = e.message;
      }
    }
  }

  void _resetDefaults() {
    FocusScope.of(context).unfocus();
    setState(() {
      for (final entry in _defaults.entries) {
        _c[entry.key]!.text = entry.value;
      }
      _compute();
    });
  }

  String _fmt(double? value, String unit, {int decimals = 2}) {
    if (value == null) {
      return '—';
    }
    return '${formatNumber(value, decimals: decimals)} $unit';
  }

  Widget _section(String title, List<Widget> children) {
    return Card(
      key: ValueKey('section-$title'),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: ral1003,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ral5004,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  /// Tek bir sayı kutusu. Sabit [ValueKey] sayesinde, sayfa düzeni değişse bile
  /// (ör. hata bandı açılıp kapansa) odak ve imleç aynı kutuda kalır.
  Widget _field(String key, String label, String unit) {
    return TextField(
      key: ValueKey('field-$key'),
      controller: _c[key],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        filled: true,
        fillColor: _inputFill,
        border: const OutlineInputBorder(),
      ),
      onChanged: (_) => setState(_compute),
    );
  }

  Widget _input(String key, String label, String unit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _field(key, label, unit),
    );
  }

  /// İki kutuyu yan yana koyar (ekranı sıkılaştırır).
  Widget _inputPair(
    String key1,
    String label1,
    String unit1,
    String key2,
    String label2,
    String unit2,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _field(key1, label1, unit1)),
          const SizedBox(width: 12),
          Expanded(child: _field(key2, label2, unit2)),
        ],
      ),
    );
  }

  Widget _output(String label, String value, {bool strong = false}) {
    final style = TextStyle(
      fontWeight: strong ? FontWeight.bold : FontWeight.w500,
      fontSize: strong ? 18 : 15,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(value, textAlign: TextAlign.right, style: style),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = _result;

    return Scaffold(
      appBar: AppBar(title: const Text('Dekantör Kütle Denkliği')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Santrifüj dekantör için kütle denkliği hesabı. Sarı alanlara değer girin; sonuçlar anında güncellenir.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              // Hata bandı her zaman listede yer alır (boşken sıfır yükseklikte);
              // böylece altındaki kutuların sırası ve durumu değişmez.
              AnimatedSize(
                key: const ValueKey('error-slot'),
                duration: const Duration(milliseconds: 150),
                alignment: Alignment.topCenter,
                child: _error == null
                    ? const SizedBox(width: double.infinity)
                    : Card(
                        color: theme.colorScheme.errorContainer,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _error!,
                            style: TextStyle(color: theme.colorScheme.onErrorContainer),
                          ),
                        ),
                      ),
              ),
              _section('DEKANTÖR GİRİŞ', [
                _inputPair('flow', 'Ürün debisi', 'm³/h', 'density', 'Yoğunluk', 'kg/m³'),
                _input('feedSolids', 'Kuru katı madde', '% w/w'),
                const Divider(),
                _output('Ürün debisi', _fmt(r?.feedMassKgH, 'kg/h')),
                _output('Kuru katı madde', _fmt(r?.feedSolidsKgH, 'kg/h')),
                _output('Nem içeriği', _fmt(r?.feedWaterPercent, '% w/w')),
                _output('Nem içeriği', _fmt(r?.feedWaterKgH, 'kg/h')),
              ]),
              _section('POLİMER (POLİELEKTROLİT) DOZAJLAMA', [
                _inputPair('polymerPct', 'Hazırlama oranı', '%', 'polymerLph', 'Çözelti debisi', 'L/h'),
                const Divider(),
                _output('Polimer debisi', _fmt(r?.polymerKgH, 'kg/h')),
                _output(
                  'Polimer tüketimi',
                  _fmt(r?.polymerKgPerTonDs, 'kg/tDS'),
                  strong: true,
                ),
              ]),
              _section('DEKANTÖR KATI ÇIKIŞ (KEK)', [
                _input('cakeSolids', 'Kuru katı madde (kek kuruluğu)', '% w/w'),
                const Divider(),
                _output('Katı çıkış', _fmt(r?.cakeMassKgH, 'kg/h'), strong: true),
                _output('Kuru katı madde', _fmt(r?.cakeSolidsKgH, 'kg/h')),
                _output('Nem içeriği', _fmt(r?.cakeWaterPercent, '% w/w')),
                _output('Nem içeriği', _fmt(r?.cakeWaterKgH, 'kg/h')),
              ]),
              _section('DEKANTÖR SENTRAT ÇIKIŞ', [
                _input('centrateSolids', 'Kuru katı madde', '% w/w'),
                const Divider(),
                _output('Sentrat çıkış', _fmt(r?.centrateMassKgH, 'kg/h'), strong: true),
                _output('Kuru katı madde', _fmt(r?.centrateSolidsKgH, 'kg/h')),
                _output('Nem içeriği', _fmt(r?.centrateWaterPercent, '% w/w')),
                _output('Nem içeriği', _fmt(r?.centrateWaterKgH, 'kg/h')),
                _output(
                  'Sentrat AKM',
                  _fmt(r?.centrateAkmMgL, 'mg/L', decimals: 0),
                ),
              ]),
              _section('YAKALAMA VERİMİ', [
                _output(
                  'Yakalama verimi',
                  _fmt(r?.captureEfficiencyPercent, '%'),
                  strong: true,
                ),
                _output(
                  'Katı geri kazanımı (kütle bazlı)',
                  _fmt(r?.solidsRecoveryPercent, '%'),
                ),
              ]),
              _section('GÜNLÜK DEĞERLER (24 SAAT)', [
                _output(
                  '1 günde işlenebilecek çamur miktarı',
                  _fmt(r?.dailyFeedM3, 'm³/gün'),
                ),
                _output(
                  '1 günde elde edilecek kek miktarı',
                  _fmt(r?.dailyCakeTons, 'ton/gün'),
                ),
                _output(
                  '1 günde sentrat çıkışı',
                  _fmt(r?.dailyCentrateM3, 'm³/gün'),
                ),
              ]),
              _section("% ORANINI AKM'YE DÖNÜŞTÜRME", [
                _input('akmPct', 'Kuru madde', '%'),
                const Divider(),
                if (_akmError != null)
                  Text(
                    _akmError!,
                    style: TextStyle(color: theme.colorScheme.error),
                  )
                else
                  _output('AKM', _fmt(_akm, 'mg/L', decimals: 0), strong: true),
              ]),
              OutlinedButton(
                onPressed: _resetDefaults,
                child: const Text('Örnek değerlere dön'),
              ),
              const SizedBox(height: 16),
              Text(
                '* Polimer dozajı kütle balansında ihmal edilmiştir. Polimer çözeltisi ve '
                'sentrat için yoğunluk 1 kg/L (1000 kg/m³) varsayılır. Yakalama verimi, '
                'besleme ile sentrat kuru katı oranlarından hesaplanır. Sonuçlar mühendislik '
                'tahminidir; ekipman kararı öncesi proses testleriyle doğrulayın.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
