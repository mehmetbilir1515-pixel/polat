import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/drive_config.dart';
import 'package:polat_rd/calculators/gearbox_torque.dart';

/// Kullanıcının gönderdiği tablo, olduğu gibi (sekmeli, düzensiz boşluklu); Dart verisinden bağımsız ayrıştırılır.
const _rawTable = '''
ZS612/87\t               630 Nm\t         Gres\t          0,3 kg
ZSPN612/105\t       630 Nm\t          Sıvı\t              0,7 L
ZS614/87\t               1250 Nm\t         Gres\t           1 kg
ZSPN614/105\t         1370 Nm\t       Sıvı\t            1 L
ZS616M/87\t             2050 Nm\t      Gres\t           1,1 kg
ZSPN617/129\t         3150 Nm\t       Sıvı\t            2 L
ZSPN616/129\t         2100 Nm\t       Sıvı\t           1,6 L
ZSPN619/129\t         7960 Nm\t       Sıvı\t            5 L
ZS619LX/59\t            10400 Nm\t       Sıvı\t           4,3 L
ZS617FX/87\t             3150 Nm\t      Gres\t           1,7 kg
ZSPV619/84\t          7960 Nm\t       Sıvı\t            5,2 L
ZSPN618/129\t          5000 Nm\t        Sıvı\t           3,5 L
ZSPN621/129\t          12650 Nm\t        Sıvı\t           5,5 L
ZSPR619LX/150-177\t10400 Nm\t     Sıvı\t            6,3 L
ZSPN622/129\t           16000 Nm\t     Sıvı\t            6,8 L
ZSPV619LX/150-116\t12000 Nm\t      Sıvı\t            5,9 L
ZSPN623/129\t            20500 Nm\t      Sıvı\t             8 L
ZSPN625/129\t             30960 Nm\t       Sıvı\t         14 L
DESCH ZG50 - İ:80/1\t50000 Nm\t       Sıvı\t          42 L
ZS 612/17\t                    630 Nm\t      Gres\t          0,3 kg
ZS 616/25\t                   2100 Nm\t       Gres\t         1,8 kg
 ZS 617/25\t                  3150 Nm\t      Sıvı            \t1,9 L
ZS 616-59\t                 2100 Nm\t      Gres\t        1,4 kg
ZS618FX-59\t                5000 Nm\t          Sıvı\t             2,7 L
ZS 618/25\t                5000 Nm\t          Gres\t        2,2 kg
ZS 619/25\t               7960 Nm\t          Gres\t        4,9 kg
ZS619FX-59\t                7960 Nm\t           Sıvı\t         4,2 L
ZS 622FX/59\t           15880 Nm\t        Sıvı\t          6 L
''';

typedef _Row = ({String model, int torque, String oil, double amount, String unit});

List<_Row> _parseRaw() {
  final re = RegExp(r'^\s*(.+?)\s+(\d+)\s*Nm\s+(Gres|Sıvı)\s+([\d,]+)\s*(kg|L)\s*$');
  return [
    for (final line in _rawTable.trim().split('\n'))
      (
        model: re.firstMatch(line)!.group(1)!.trim(),
        torque: int.parse(re.firstMatch(line)!.group(2)!),
        oil: re.firstMatch(line)!.group(3)!,
        amount: double.parse(re.firstMatch(line)!.group(4)!.replaceAll(',', '.')),
        unit: re.firstMatch(line)!.group(5)!,
      ),
  ];
}

void main() {
  test('tork, yağ bilgisi ve yağ miktarı kullanıcının tablosuyla aynı (sıra dahil)', () {
    final expected = _parseRaw();
    expect(expected.length, 28);
    expect(gearboxTorques.length, expected.length);
    for (var i = 0; i < expected.length; i++) {
      final e = expected[i];
      final g = gearboxTorques[i];
      expect(g.model, e.model, reason: 'satır $i');
      expect(g.maxTorqueNm, e.torque, reason: e.model);
      expect(g.oil.label, e.oil, reason: e.model);
      expect(g.oil.unit, e.unit, reason: e.model); // gres -> kg, sıvı -> L
      expect(g.oilAmount, e.amount, reason: e.model);
    }
  });

  test('şanzıman tipleri benzersizdir ve arama doğru çalışır', () {
    expect(gearboxTorqueModels.toSet().length, gearboxTorqueModels.length);
    expect(gearboxTorqueFor('ZS619LX/59')!.maxTorqueNm, 10400);
    expect(gearboxTorqueFor('DESCH ZG50 - İ:80/1')!.maxTorqueNm, 50000);
    expect(gearboxTorqueFor('DESCH ZG50 - İ:80/1')!.oilAmount, 42);
    expect(gearboxTorqueFor('ZS 617/25')!.maxTorqueNm, 3150); // baştaki boşluk atılmış
    expect(gearboxTorqueFor('ZS 617/25')!.oil, GearboxOil.liquid);
    expect(gearboxTorqueFor('YOK-TİP'), isNull);
  });

  test('yağ kodu bilgileri kullanıcının verdiği metinle aynı', () {
    expect(greaseCodeNote, 'Gres kodu ve tanımı: 150030090152 SHELL GADUS S2 U460L 2');
    expect(
      liquidOilCodeNote,
      'Sıvı Yağ Kodu ve Tanımı: 150030090006 MİNERAL DİŞLİ YAĞI VİSKOZİTE 220',
    );
  });

  test('Şanzıman Motor Bilgisi ekranındaki şanzıman torklarıyla tutarlıdır', () {
    final byModel = {for (final g in gearboxTorques) g.model: g.maxTorqueNm};
    for (final c in driveConfigs) {
      final torque = int.parse(RegExp(r'\d+').firstMatch(c.gearboxTorque)!.group(0)!);
      expect(byModel.containsKey(c.gearboxType), isTrue, reason: c.gearboxType);
      expect(byModel[c.gearboxType], torque, reason: c.gearboxType);
    }
  });
}
