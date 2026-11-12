import 'package:flutter/material.dart';

import '../calculator_specs.dart';
import 'bearing_lubrication_screen.dart';
import 'calculator_screen.dart';
import 'decanter_3000g_screen.dart';
import 'decanter_specs_screen.dart';
import 'drive_config_screen.dart';
import 'gearbox_torque_screen.dart';
import 'mass_balance_screen.dart';
import 'rotation_direction_screen.dart';

/// Ana ekrandaki bir kart: özel ekran ya da tanımdan üretilen hesaplayıcı.
typedef HomeEntry = ({
  IconData icon,
  String title,
  String subtitle,
  Widget Function() screen,
});

HomeEntry _fromSpec(String id) {
  final spec = calculatorSpecs.firstWhere((s) => s.id == id);
  return (
    icon: spec.icon,
    title: spec.title,
    subtitle: spec.description,
    screen: () => CalculatorScreen(spec: spec),
  );
}

/// Ana ekran kartlarının sırası (kullanıcının belirlediği sıra).
List<HomeEntry> buildHomeEntries() => [
      // 1
      (
        icon: Icons.table_chart_outlined,
        title: 'Dekantör Model Değerleri',
        subtitle: 'Model seçin; devirler, hidrolik kapasite, katı çıkış çapı ve helezon boru çapını görün.',
        screen: () => const DecanterSpecsScreen(),
      ),
      // 2
      _fromSpec('differential-speed'),
      // 3
      (
        icon: Icons.settings_applications_outlined,
        title: 'Dekantör Şanzıman Motor Bilgisi',
        subtitle: 'Seri kodu ve tambur çapını seçin; motor, şanzıman ve kasnak bilgilerini görün.',
        screen: () => const DriveConfigScreen(),
      ),
      // 4
      (
        icon: Icons.speed_outlined,
        title: 'Şanzıman Tork ve Yağlama Bilgisi',
        subtitle: 'Şanzıman tipini seçin; maks. tork dayanımı, yağ bilgisi, yağ miktarı ve yağ kodlarını görün.',
        screen: () => const GearboxTorqueScreen(),
      ),
      // 5
      _fromSpec('g-force'),
      // 6
      (
        icon: Icons.rotate_right,
        title: 'Dekantör Motor Dönüş Yönü',
        subtitle: 'Model, şanzıman ve motor tipine göre ana / helezon motoru dönüş yönü.',
        screen: () => const RotationDirectionScreen(),
      ),
      // 7
      _fromSpec('belt-length'),
      // 8 (kasnak boyutu + kasnak hızı)
      _fromSpec('pulley'),
      // 9
      (
        icon: Icons.verified_outlined,
        title: 'Dekantör 3000G Verileri',
        subtitle: 'Model seçin; rulman, şanzıman ve tambur dayanımını 3000G için kontrol edin.',
        screen: () => const Decanter3000gScreen(),
      ),
      // 10
      (
        icon: Icons.settings_input_component_outlined,
        title: 'Dekantör Yağlama Bilgisi',
        subtitle: 'Main Bearing / Helezon Rulmanı; endüstriyel veya zeytinyağı dekantörü ve modele göre yağlama bilgisi.',
        screen: () => const BearingLubricationScreen(),
      ),
      // 11
      (
        icon: Icons.analytics_outlined,
        title: 'Dekantör Kütle Denkliği',
        subtitle: 'Besleme, kek ve sentrat kütle denkliği; polimer tüketimi ve yakalama verimi.',
        screen: () => const MassBalanceScreen(),
      ),
      // 12
      _fromSpec('throughput'),
      // 13
      _fromSpec('flow-rate'),
    ];

/// Ana ekran: dekantör ekranları ve hesaplama araçlarının sıralı listesi.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _tile(BuildContext context, HomeEntry entry) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(entry.icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(entry.title),
        subtitle: Text(entry.subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => entry.screen()),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entries = buildHomeEntries();
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
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _tile(context, entries[index]),
      ),
    );
  }
}
