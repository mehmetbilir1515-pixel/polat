import 'package:flutter/material.dart';

import '../calculators/rotation_direction.dart';
import '../theme.dart';

const _all = '__all__';

/// DEKANTÖR MOTOR DÖNÜŞ YÖNÜ: model, şanzıman ve motor tipine göre dönüş yönü
/// talimatı (AG-TL-09 Rev.04). Süzgeçler "Tümü" olabilir; sonuçlar anında güncellenir.
class RotationDirectionScreen extends StatefulWidget {
  const RotationDirectionScreen({super.key});

  @override
  State<RotationDirectionScreen> createState() => _RotationDirectionScreenState();
}

class _RotationDirectionScreenState extends State<RotationDirectionScreen> {
  String _model = _all;
  String _gearbox = _all;
  String _motor = _all;

  String? _criterion(String v) => v == _all ? null : v;

  Widget _dropdown({
    required Key key,
    required String label,
    required String allLabel,
    required List<String> options,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              key: key,
              isExpanded: true,
              value: value,
              style: const TextStyle(color: ral5004, fontSize: 15, fontWeight: FontWeight.bold),
              items: [
                DropdownMenuItem<String>(value: _all, child: Text(allLabel)),
                for (final o in options) DropdownMenuItem<String>(value: o, child: Text(o)),
              ],
              onChanged: (v) {
                if (v != null) {
                  onChanged(v);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _filters() {
    final active = _model != _all || _gearbox != _all || _motor != _all;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ral5004,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _dropdown(
            key: const ValueKey('filter-model'),
            label: 'MODEL SEÇİN',
            allLabel: 'Tüm Modeller',
            options: rotationModels,
            value: _model,
            onChanged: (v) => setState(() => _model = v),
          ),
          const SizedBox(height: 14),
          _dropdown(
            key: const ValueKey('filter-gearbox'),
            label: 'ŞANZIMAN TİPİ',
            allLabel: 'Tüm Şanzıman Tipleri',
            options: rotationGearboxes,
            value: _gearbox,
            onChanged: (v) => setState(() => _gearbox = v),
          ),
          const SizedBox(height: 14),
          _dropdown(
            key: const ValueKey('filter-motor'),
            label: 'MOTOR TİPİ',
            allLabel: 'Tüm Motorlar',
            options: motorTypes,
            value: _motor,
            onChanged: (v) => setState(() => _motor = v),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              key: const ValueKey('reset-filters'),
              onPressed: active
                  ? () => setState(() {
                        _model = _all;
                        _gearbox = _all;
                        _motor = _all;
                      })
                  : null,
              icon: const Icon(Icons.filter_alt_off_outlined),
              label: const Text('Filtreleri Temizle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _directionBadge(RotationDirection d) {
    final cw = d == RotationDirection.clockwise;
    final bg = cw ? const Color(0xFFD4EDDA) : const Color(0xFFF8D7DA);
    final fg = cw ? const Color(0xFF155724) : const Color(0xFF721C24);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(cw ? Icons.rotate_right : Icons.rotate_left, color: fg, size: 20),
          const SizedBox(width: 8),
          Text(d.label, style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _entryCard(RotationEntry e) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.model, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('Şanzıman: ${e.gearbox}'),
            const SizedBox(height: 2),
            Text('Motor: ${e.motor}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _directionBadge(e.direction),
            if (e.note.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(e.note, style: const TextStyle(fontSize: 13, color: Color(0xFF2C5282))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _notes() {
    Widget p(String text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(text, style: const TextStyle(fontSize: 13)),
        );
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF9E6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          p('NOT 1: Dönüş yönü belirlenmeden önce şanzıman bağlantı tipi (konik gövde tarafı veya düz gövde tarafı) ve modeli belirlenmelidir.'),
          p('NOT 2: Dönüş yönleri, görselde belirtilen bakış yönüne göre tanımlanmıştır (motor mili ucundan dekantöre doğru bakış). Motorun montaj pozisyonundan bağımsızdır.'),
          p('NOT 3: Saat yönü ve saat yönü tersi ifadeleri yukarıdaki referans bakış yönüne göredir. Yanlış bağlantı helezon kırılmasına veya ağır hasara yol açabilir.'),
          p('Kontrol listesi: Model doğrulandı → Şanzıman etiketi kontrolü → Bakış yönü onayı → Tablo ile karşılaştırma.'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = filterRotation(
      model: _criterion(_model),
      gearbox: _criterion(_gearbox),
      motor: _criterion(_motor),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('DEKANTÖR MOTOR DÖNÜŞ YÖNÜ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Model, şanzıman ve motor tipine göre dönüş yönü talimatı (Rev.04)',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _filters(),
          const SizedBox(height: 16),
          Text(
            '${results.length} kayıt',
            key: const ValueKey('result-count'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (results.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Seçilen kriterlere uygun kayıt bulunamadı. Filtreleri genişletin.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            for (final e in results) _entryCard(e),
          _notes(),
          const SizedBox(height: 16),
          const Text(
            'Talimat No: AG-TL-09 Rev.04 | Yürürlük Tarihi: 2026-02\nÜretim / Saha Servis İçin Standart Doküman',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Color(0xFF5A6E7C)),
          ),
        ],
      ),
    );
  }
}
