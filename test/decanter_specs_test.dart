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
}
