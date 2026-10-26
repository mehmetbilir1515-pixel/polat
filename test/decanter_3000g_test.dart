import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/decanter_3000g.dart';

// Beklenen sonuçlar, "3000G Kontrol Ekranı" HTML sayfasının kendi kodu Node'da
// çalıştırılarak üretilmiştir (her modelde kartların geçti/kaldı sırası).
void main() {
  final expected = <({String model, bool standard, int maxRpm, int dynamic, List<bool> checks})>[
    (model: 'S200', standard: true, maxRpm: 5300, dynamic: 3140, checks: [true, true, true]),
    (model: 'S300', standard: true, maxRpm: 4300, dynamic: 3101, checks: [true, true, true]),
    (model: 'S350', standard: true, maxRpm: 3850, dynamic: 2933, checks: [true, true, true]),
    (model: 'S430', standard: false, maxRpm: 3100, dynamic: 3533, checks: [true, false, true, true, true]),
    (model: 'S470', standard: false, maxRpm: 3100, dynamic: 3379, checks: [true, false, true, true, true]),
    (model: 'S530', standard: false, maxRpm: 2800, dynamic: 3182, checks: [false, false, true, true, true]),
    (model: 'S570', standard: false, maxRpm: 2600, dynamic: 3069, checks: [false, false, false, false, true]),
    (model: 'SX650', standard: false, maxRpm: 2300, dynamic: 2873, checks: [true, false, false, false, false]),
    (model: 'S670', standard: false, maxRpm: 2100, dynamic: 2785, checks: [false, false, false, false, false]),
    (model: 'SX840', standard: false, maxRpm: 2100, dynamic: 2535, checks: [false, false, false, false, false]),
    (model: 'SX920', standard: false, maxRpm: 1700, dynamic: 2415, checks: [false, false, false, false, false]),
  ];

  Decanter3000gModel find(String name) =>
      decanter3000gModels.firstWhere((m) => m.model == name);

  group('3000G kontrolü (HTML ile birebir)', () {
    test('11 model listelenir', () {
      expect(decanter3000gModels.length, 11);
      expect(decanter3000gModels.first.model, 'S200');
      expect(decanter3000gModels.last.model, 'SX920');
    });

    for (final e in expected) {
      test('${e.model}: kartların geçti/kaldı sonucu HTML ile aynı', () {
        final a = analyze3000g(find(e.model));
        expect(a.meets3000gAlready, e.standard);
        expect(a.maxRpm, e.maxRpm);
        expect(a.dynamicValue, e.dynamic);
        expect(a.dynamicLabel, e.standard ? 'Mevcut G Kuvveti' : 'Hedef 3000G Devri');
        expect(a.dynamicUnit, e.standard ? 'G' : 'rpm');
        expect(a.checks.map((c) => c.passed).toList(), e.checks);
      });
    }

    test('S200, S300, S350 zaten 3000G sağlıyor', () {
      for (final name in ['S200', 'S300', 'S350']) {
        expect(analyze3000g(find(name)).meets3000gAlready, isTrue, reason: name);
      }
      expect(analyze3000g(find('S430')).meets3000gAlready, isFalse);
    });

    test('Sb/Sf kartları yalnızca değeri olan modellerde çıkar', () {
      expect(analyze3000g(find('S200')).checks.length, 3);
      expect(analyze3000g(find('S430')).checks.length, 5);
    });
  });

  group('3000G kart metinleri', () {
    test('S570: değerler, ayrıntılar ve uyarı etiketleri', () {
      final c = analyze3000g(find('S570')).checks;
      expect(c[0].title, 'Arka Rulman Referans Hızı');
      expect(c[0].valueText, '2.800 rpm');
      expect(c[0].detail, 'RULMAN 228 NU ECML/C3');
      expect(c[0].failureLabel, 'Yetersiz!');
      expect(c[1].detail, 'Model: ZSPN622/129');
      expect(c[3].title, 'Tambur Dayanımı (Sb)');
      expect(c[3].valueText, '1,36');
      expect(c[3].detail, 'Min Gereken: 1,5');
      expect(c[3].passed, isFalse);
      expect(c[3].failureLabel, 'Riskli!');
      expect(c[4].valueText, '1,43');
      expect(c[4].detail, 'Min Gereken: 1,3');
      expect(c[4].passed, isTrue);
    });

    test('limit hedefe eşitse geçer (>=)', () {
      const m = Decanter3000gModel(
        model: 'TEST',
        maxRpm: 2000,
        currentG: 2500,
        targetRpm: 3000,
        rearBearingRpm: 3000,
        rearBearingName: 'x',
        gearboxLargestRpm: 2999,
        gearboxLargestModel: 'y',
        gearboxCommonRpm: 3001,
        gearboxCommonModel: 'z',
        strengthSb: 1.5,
        strengthSf: 1.29,
      );
      final c = analyze3000g(m).checks;
      expect(c[0].passed, isTrue); // 3000 >= 3000
      expect(c[1].passed, isFalse); // 2999 < 3000
      expect(c[2].passed, isTrue); // 3001 >= 3000
      expect(c[3].passed, isTrue); // Sb 1,5 >= 1,5
      expect(c[4].passed, isFalse); // Sf 1,29 < 1,3
    });
  });
}
