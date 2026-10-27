import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../calculators/bearing_lubrication.dart';
import '../format.dart';
import '../widgets/model_selector.dart';

enum _OilType { industrial, oliveOil }

/// Helezon rulmanı yağlama bilgisi: endüstriyel veya zeytinyağı
/// seçilir, ardından model seçilerek yağ miktarı, basım sayısı ve rulman bilgisi görülür.
class ScrollBearingLubricationScreen extends StatefulWidget {
  const ScrollBearingLubricationScreen({super.key});

  @override
  State<ScrollBearingLubricationScreen> createState() =>
      _ScrollBearingLubricationScreenState();
}

class _ScrollBearingLubricationScreenState
    extends State<ScrollBearingLubricationScreen> {
  _OilType _oil = _OilType.industrial;
  String? _model;

  static const String _note =
      'Not: Yapılan hesaplamalar rulmanın optimum çalışma koşulları altında olduğu durumlar içindir, dekantörün çalışma koşulları göz önüne alınarak basım sayıları arttırılabilir.';

  List<String> get _models => _oil == _OilType.industrial
      ? [for (final d in industrialScrollLubrication) d.model]
      : [for (final d in oliveOilScrollLubrication) d.model];

  Future<void> _openSkf(String bearingType) async {
    final uri = Uri.parse(skfSearchUrl(bearingType));
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SKF sayfası açılamadı.')),
      );
    }
  }

  Widget _labelValue(String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: Text(label)),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      ),
    );
  }

  Widget _skfButton(String bearingType) {
    return OutlinedButton(
      onPressed: () => _openSkf(bearingType),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: const Text("SKF'te Ara"),
    );
  }

  Widget _bullet(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _noteBlock() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        _note,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _industrialResult(IndustrialScrollLubrication d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${d.model} Yağlama Bilgisi',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (final b in d.bearings)
                  _bullet(
                    '${b.position} Rulman: ',
                    '${formatCompact(b.greaseG)} g - ${b.shots} defa basım',
                  ),
                _bullet(
                  'Her iki rulman toplam yağ miktarı: ',
                  '${formatCompact(d.totalG)} g',
                ),
              ],
            ),
          ),
        ),
        _sectionTitle('Rulman Bilgileri'),
        for (final b in d.bearings)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${b.position} Rulman',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  _labelValue('Rulman Tipi', b.type),
                  _labelValue('Rulman Kodu', b.code),
                  _labelValue('Dış Çap (mm)', formatCompact(b.outerMm)),
                  _labelValue('İç Çap (mm)', formatCompact(b.innerMm)),
                  _labelValue('Genişlik (mm)', formatCompact(b.widthMm)),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _skfButton(b.type),
                  ),
                ],
              ),
            ),
          ),
        _noteBlock(),
      ],
    );
  }

  Widget _oliveResult(OliveOilScrollLubrication d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${d.model} Yağlama Bilgisi',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                _labelValue('Re-Greasing Miktarı (g)', formatCompact(d.regreaseG)),
                _labelValue('Manuel Gres Pompası ile Basım Sayısı', '${d.shots}'),
                _labelValue(
                  'Rulman Tipi',
                  d.type,
                  trailing: _skfButton(d.type),
                ),
                _labelValue('Rulman Kodu', d.code),
                _labelValue('Dış Çap (mm)', formatCompact(d.outerMm)),
                _labelValue('İç Çap (mm)', formatCompact(d.innerMm)),
                _labelValue('Genişlik (mm)', formatCompact(d.widthMm)),
              ],
            ),
          ),
        ),
        _noteBlock(),
      ],
    );
  }

  Widget? _result() {
    final name = _model;
    if (name == null) {
      return null;
    }
    if (_oil == _OilType.industrial) {
      return _industrialResult(
        industrialScrollLubrication.firstWhere((d) => d.model == name),
      );
    }
    return _oliveResult(
      oliveOilScrollLubrication.firstWhere((d) => d.model == name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = _result();
    final title = _oil == _OilType.industrial
        ? 'ENDÜSTRİYEL DEKANTÖRLERİN HELEZON RULMANLARININ YAĞLAMA BİLGİSİ'
        : 'ZEYTİNYAĞI DEKANTÖRLERİNİN HELEZON RULMANLARININ YAĞLAMA BİLGİSİ';
    return Scaffold(
      appBar: AppBar(title: const Text('Helezon Rulmanı')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<_OilType>(
                segments: const [
                  ButtonSegment<_OilType>(
                    value: _OilType.industrial,
                    label: Text('Endüstriyel'),
                  ),
                  ButtonSegment<_OilType>(
                    value: _OilType.oliveOil,
                    label: Text('Zeytinyağı'),
                  ),
                ],
                selected: {_oil},
                onSelectionChanged: (selection) {
                  setState(() {
                    _oil = selection.first;
                    _model = null;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              ModelSelector(
                models: _models,
                value: _model,
                onChanged: (value) => setState(() => _model = value),
              ),
              if (result != null) ...[
                const SizedBox(height: 20),
                result,
              ],
              const SizedBox(height: 32),
              Text(
                'Created By Mehmet BİLİR',
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
