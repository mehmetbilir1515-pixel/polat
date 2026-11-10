import 'package:flutter/material.dart';

import '../calculators/drive_config.dart';
import '../format.dart';
import '../widgets/model_selector.dart';

/// Dekantör şanzıman ve motor bilgisi: seri kodu ve tambur çapı seçilince Excel'deki
/// "Konfigürasyon" sayfasının diğer sütunları gösterilir. Bir seçim için birden çok
/// yapılandırma varsa hepsi ayrı kart olarak listelenir.
class DriveConfigScreen extends StatefulWidget {
  const DriveConfigScreen({super.key});

  @override
  State<DriveConfigScreen> createState() => _DriveConfigScreenState();
}

class _DriveConfigScreenState extends State<DriveConfigScreen> {
  String? _selection;

  /// Excel'de "X" olan (uygulanmayan) değerler tire ile gösterilir.
  String _text(String value) => value == 'X' ? '—' : value;

  String _rpm(int? value) => value == null ? '—' : formatNumber(value.toDouble(), decimals: 0);

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _configCard(DriveConfig c, {String? title}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            _row('Tambur Motor Gücü ve Devri', _text(c.drumMotor)),
            _row('Helezon Motor Gücü ve Devri', _text(c.scrollMotor)),
            _row('Şanzıman Tipi', _text(c.gearboxType)),
            _row('Şanzıman Torku', _text(c.gearboxTorque)),
            _row('Tambur Konik Açısı', _text(c.coneAngle)),
            _row('Gövde Motor Kasnağı', _text(c.drumMotorPulley)),
            _row('Helezon Motor Kasnağı', _text(c.scrollMotorPulley)),
            _row('Şanzıman Kasnağı', _text(c.gearboxPulley)),
            _row('Tambur Kasnağı', _text(c.drumPulley)),
            _row('50 Hz Tambur Devri (rpm)', _rpm(c.drumRpm50Hz)),
            _row('50 Hz Şanzıman Giriş Devri (rpm)', _rpm(c.gearboxInputRpm50Hz)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selection = _selection;
    final configs = selection == null ? const <DriveConfig>[] : driveConfigsFor(selection);
    return Scaffold(
      appBar: AppBar(title: const Text('Dekantör Şanzıman Motor Bilgisi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Seri kodu ve tambur çapını seçin; motor, şanzıman ve kasnak bilgileri görünsün.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ModelSelector(
                title: 'SERİ KODU VE TAMBUR ÇAPI SEÇİNİZ',
                models: driveConfigSelections,
                value: selection,
                onChanged: (value) => setState(() => _selection = value),
              ),
              if (selection != null) ...[
                const SizedBox(height: 20),
                Text(
                  configs.length == 1
                      ? '$selection — 1 yapılandırma'
                      : '$selection — ${configs.length} yapılandırma',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < configs.length; i++)
                  _configCard(
                    configs[i],
                    title: configs.length == 1 ? null : 'Yapılandırma ${i + 1} / ${configs.length}',
                  ),
              ],
              const SizedBox(height: 16),
              const Text(
                '"—": uygulanmaz (Excel\'te "X"), "YOK": ilgili kasnak bulunmaz.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
