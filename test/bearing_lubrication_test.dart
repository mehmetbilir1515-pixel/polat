import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/bearing_lubrication.dart';
import 'package:polat_rd/format.dart';

// Beklenen değerler, "Rulman Yağlama Bilgisi" HTML sayfasındaki veri tablolarından
// Node ile çıkarılarak üretilmiştir (elle yazılmamıştır).
void main() {
  final industrial = <({
    String model,
    double total,
    List<String> positions,
    List<double> grease,
    List<int> shots,
    List<String> types,
    List<String> codes,
  })>[
    (model: 'S200', total: 20.41, positions: ['Arka', 'Ön'], grease: [13.59, 6.82], shots: [9, 4], types: ['3210-A/C3', '4908 NA'], codes: ['150030010491', '150030010293']),
    (model: 'S300', total: 37.82, positions: ['Arka', 'Ön'], grease: [29.9, 7.92], shots: [19, 5], types: ['4312 ATN9', '4910 NA'], codes: ['150030010526', '150030010488']),
    (model: 'S350', total: 58.42, positions: ['Arka', 'Ön'], grease: [41.92, 16.5], shots: [27, 11], types: ['3218 A', '4916 NA'], codes: ['150030010868', '150030010443']),
    (model: 'S430', total: 82.27, positions: ['Arka', 'Ön'], grease: [54.27, 28.0], shots: [35, 18], types: ['3220 A', '4920 NA'], codes: ['150030010891', '150030010890']),
    (model: 'S470', total: 97.8, positions: ['Arka', 'Ön'], grease: [69.8, 28.0], shots: [45, 18], types: ['3222 A/C3', '4920 NA'], codes: ['150030010036', '150030010890']),
    (model: 'S530', total: 99.8, positions: ['Arka', 'Ön'], grease: [69.8, 30.0], shots: [45, 20], types: ['3222 A/C3', '4922 NA'], codes: ['150030010036', '150030010961']),
    (model: 'S570', total: 99.8, positions: ['Arka', 'Ön'], grease: [69.8, 30.0], shots: [45, 20], types: ['3222 A/C3', '4922 NA'], codes: ['150030010036', '150030010961']),
    (model: 'SX650', total: 73.0, positions: ['Ön', 'Arka'], grease: [43.0, 30.0], shots: [28, 20], types: ['QJ224 N2 MA', '4922 NA'], codes: ['150030011711', '150030010961']),
    (model: 'S670', total: 117.2, positions: ['Ön', 'Arka'], grease: [25.2, 92.0], shots: [16, 60], types: ['1024 NU ML', '7226 BCBM'], codes: ['150030010898', '150030010897']),
  ];

  final olive = <({
    String model,
    double grease,
    int shots,
    String type,
    String code,
    double outer,
    double inner,
    double width,
  })>[
    (model: 'PX5', grease: 20.075, shots: 13, type: '3212 A', code: '150030010292', outer: 110.0, inner: 60.0, width: 36.5),
    (model: 'PX10', grease: 20.075, shots: 13, type: '3212 A', code: '150030010292', outer: 110.0, inner: 60.0, width: 36.5),
    (model: 'PX20', grease: 41.92, shots: 27, type: '3218 A', code: '150030010868', outer: 160.0, inner: 90.0, width: 52.4),
    (model: 'PX30', grease: 41.92, shots: 27, type: '3218 A', code: '150030010868', outer: 160.0, inner: 90.0, width: 52.4),
    (model: 'PX40', grease: 69.8, shots: 45, type: '3222 A/C3', code: '150030010036', outer: 200.0, inner: 110.0, width: 69.8),
    (model: 'PXZ40', grease: 41.92, shots: 27, type: '3218 A', code: '150030010868', outer: 160.0, inner: 90.0, width: 52.4),
    (model: 'PXZ60', grease: 51.0, shots: 33, type: '24022 CC W33', code: '150030011446', outer: 170.0, inner: 110.0, width: 60.0),
    (model: 'PXZ80', grease: 51.0, shots: 33, type: '24022 CC W33', code: '150030011446', outer: 170.0, inner: 110.0, width: 60.0),
    (model: 'PXZ100', grease: 51.0, shots: 33, type: '24022 CC W33', code: '150030011446', outer: 170.0, inner: 110.0, width: 60.0),
    (model: 'PXZ160', grease: 69.8, shots: 45, type: '3222 A/C3', code: '150030010036', outer: 200.0, inner: 110.0, width: 69.8),
    (model: 'PXZ250', grease: 69.8, shots: 45, type: '3222 A/C3', code: '150030010036', outer: 200.0, inner: 110.0, width: 69.8),
    (model: 'PXZ500', grease: 69.8, shots: 45, type: '3222 A/C3', code: '150030010036', outer: 200.0, inner: 110.0, width: 69.8),
  ];

  group('Endüstriyel (helezon rulmanı) yağlama verisi', () {
    test('9 model, HTML ile aynı sırada', () {
      expect(
        industrialScrollLubrication.map((d) => d.model).toList(),
        industrial.map((e) => e.model).toList(),
      );
    });

    for (final e in industrial) {
      test('${e.model}: HTML ile aynı değerler', () {
        final d = industrialScrollLubrication.firstWhere((x) => x.model == e.model);
        expect(d.totalG, e.total);
        expect(d.bearings.map((b) => b.position).toList(), e.positions);
        expect(d.bearings.map((b) => b.greaseG).toList(), e.grease);
        expect(d.bearings.map((b) => b.shots).toList(), e.shots);
        expect(d.bearings.map((b) => b.type).toList(), e.types);
        expect(d.bearings.map((b) => b.code).toList(), e.codes);
      });
    }

    test('toplam yağ miktarı iki rulmanın toplamına eşittir', () {
      for (final d in industrialScrollLubrication) {
        final sum = d.bearings.fold<double>(0, (a, b) => a + b.greaseG);
        expect(d.totalG, closeTo(sum, 1e-9), reason: d.model);
      }
    });
  });

  group('Zeytinyağı (helezon rulmanı) yağlama verisi', () {
    test('12 model, HTML ile aynı sırada', () {
      expect(
        oliveOilScrollLubrication.map((d) => d.model).toList(),
        olive.map((e) => e.model).toList(),
      );
    });

    for (final e in olive) {
      test('${e.model}: HTML ile aynı değerler', () {
        final d = oliveOilScrollLubrication.firstWhere((x) => x.model == e.model);
        expect(d.regreaseG, e.grease);
        expect(d.shots, e.shots);
        expect(d.type, e.type);
        expect(d.code, e.code);
        expect(d.outerMm, e.outer);
        expect(d.innerMm, e.inner);
        expect(d.widthMm, e.width);
      });
    }
  });

  group('Yardımcılar', () {
    test('SKF arama adresi HTML ile aynı biçimde (encodeURIComponent)', () {
      expect(
        skfSearchUrl('3210-A/C3'),
        'https://www.skf.com/tr/search-results.html?q=3210-A%2FC3',
      );
      expect(
        skfSearchUrl('QJ224 N2 MA'),
        'https://www.skf.com/tr/search-results.html?q=QJ224%20N2%20MA',
      );
    });

    test('formatCompact gereksiz sıfırları atar ve virgül kullanır', () {
      expect(formatCompact(13.59), '13,59');
      expect(formatCompact(30), '30');
      expect(formatCompact(20.075), '20,075');
      expect(formatCompact(69.8), '69,8');
      expect(formatCompact(117.2), '117,2');
      expect(formatCompact(0), '0');
    });
  });
}
