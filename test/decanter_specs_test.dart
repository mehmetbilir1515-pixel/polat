import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/decanter_3000g.dart';
import 'package:polat_rd/calculators/decanter_specs.dart';

// Beklenen değerler, kullanıcının gönderdiği model tablosundan alınmıştır.
void main() {
  const table = <({String model, int operating, int bowl, String hydraulic})>[
    (model: 'S200', operating: 5300, bowl: 5500, hydraulic: '1-6'),
    (model: 'S300', operating: 4300, bowl: 4500, hydraulic: '6-15'),
    (model: 'S350', operating: 3850, bowl: 4200, hydraulic: '15-25'),
    (model: 'S430', operating: 3100, bowl: 3500, hydraulic: '25-35'),
    (model: 'S470', operating: 3100, bowl: 3300, hydraulic: '35-45'),
    (model: 'S530', operating: 2800, bowl: 3000, hydraulic: '40-50'),
    (model: 'S570', operating: 2600, bowl: 2800, hydraulic: '50-70'),
    (model: 'SX650', operating: 2300, bowl: 2500, hydraulic: '70-100'),
    (model: 'S670', operating: 2100, bowl: 2300, hydraulic: '80-110'),
  ];

  test('tablodaki 9 model aynı sırayla ve aynı değerlerle bulunur', () {
    expect(decanterSpecs.map((s) => s.model).toList(), table.map((t) => t.model).toList());
    for (final t in table) {
      final s = decanterSpecs.firstWhere((x) => x.model == t.model);
      expect(s.maxOperatingRpm, t.operating, reason: t.model);
      expect(s.maxBowlRpm, t.bowl, reason: t.model);
      expect(s.hydraulicRangeText, t.hydraulic, reason: t.model);
    }
  });

  test('gövde devri çalışma devrinden büyüktür, kapasite aralığı geçerlidir', () {
    for (final s in decanterSpecs) {
      expect(s.maxBowlRpm, greaterThan(s.maxOperatingRpm), reason: s.model);
      expect(s.hydraulicMaxM3h, greaterThan(s.hydraulicMinM3h), reason: s.model);
    }
  });

  test('maks. çalışma devri 3000G ekranındaki verilerle tutarlıdır', () {
    for (final s in decanterSpecs) {
      final other = decanter3000gModels.firstWhere((m) => m.model == s.model);
      expect(other.maxRpm, s.maxOperatingRpm, reason: s.model);
    }
  });

  // Kullanıcının gönderdiği çap tablosu, olduğu gibi (sekmeli, virgüllü); Dart verisinden bağımsız ayrıştırılır.
  const diameterTable = '''
S200\t117,8\t112
S300\t175,5\t150
S350\t211\t198
S430\t262\t228
S470 10°\t277,6\t238
S470 15°\t225,6\t230
S530 10°\t302\t285
S530 15°\t254,5\t244
S570 10°\t327,6\t320
S570 15°\t273,6\t244
SX650 10°\t360\t300
SX650 15°\t302\t300
S670 10°\t402\t353
''';

  test('katı çıkış ve helezon boru çapları kullanıcı tablosuyla aynıdır', () {
    final rows = diameterTable.trim().split('\n').map((line) {
      final parts = line.split('\t');
      final m = RegExp(r'^(\S+?)(?: (\d+)°)?$').firstMatch(parts[0])!;
      return (
        model: m.group(1)!,
        angle: m.group(2) == null ? null : int.parse(m.group(2)!),
        solids: double.parse(parts[1].replaceAll(',', '.')),
        scroll: double.parse(parts[2].replaceAll(',', '.')),
      );
    }).toList();
    expect(rows.length, 13);

    // Tablodaki her satır tam bir kez, doğru değerlerle bulunur; fazladan kayıt yoktur.
    var matched = 0;
    for (final s in decanterSpecs) {
      for (final d in s.diameters) {
        final hits = rows.where((r) => r.model == s.model && r.angle == d.angleDeg).toList();
        expect(hits.length, 1, reason: '${s.model} ${d.angleDeg}');
        expect(d.solidsOutletMm, hits.single.solids, reason: '${s.model} ${d.angleDeg}');
        expect(d.scrollPipeMm, hits.single.scroll, reason: '${s.model} ${d.angleDeg}');
        matched++;
      }
    }
    expect(matched, rows.length);
  });

  test('10°/15° olan modellerde iki kayıt, diğerlerinde tek kayıt vardır', () {
    const twoAngles = {'S470', 'S530', 'S570', 'SX650'};
    for (final s in decanterSpecs) {
      if (twoAngles.contains(s.model)) {
        expect(s.diameters.map((d) => d.angleDeg).toList(), [10, 15], reason: s.model);
      } else if (s.model == 'S670') {
        expect(s.diameters.map((d) => d.angleDeg).toList(), [10]);
      } else {
        expect(s.diameters.map((d) => d.angleDeg).toList(), [null], reason: s.model);
      }
    }
  });
}
