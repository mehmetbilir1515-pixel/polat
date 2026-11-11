import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/drive_config.dart';
import 'package:polat_rd/calculators/gearbox_torque.dart';

/// Kullanıcının gönderdiği tablo, olduğu gibi (sekmeli, düzensiz boşluklu); Dart verisinden bağımsız ayrıştırılır.
const _rawTable = '''
ZS612/87\t           630 Nm
ZSPN612/105\t   630 Nm
ZS614/87\t          1250 Nm
ZSPN614/105\t   1370 Nm
ZS616M/87\t      2050 Nm
ZSPN617/129\t  3150 Nm
ZSPN616/129\t   2100 Nm
ZSPN619/129\t  7960 Nm
ZS619LX/59\t      10400 Nm
ZS617FX/87\t       3150 Nm
ZSPV619/84\t    7960 Nm
ZSPN618/129\t    5000 Nm
ZSPN621/129\t     12650 Nm
ZSPR619LX/150-177\t10400 Nm
ZSPN622/129\t         16000 Nm
ZSPV619LX/150-116\t12000 Nm
ZSPN623/129\t       20500 Nm
ZSPN625/129\t        30960 Nm
DESCH ZG50 - İ:80/1\t50000 Nm
ZS 612/17\t             630 Nm
ZS 616/25\t           2100 Nm
 ZS 617/25\t           3150 Nm
ZS 616-59\t           2100 Nm
ZS618FX-59\t           5000 Nm
ZS 618/25\t           5000 Nm
ZS 619/25\t           7960 Nm
ZS619FX-59\t           7960 Nm
ZS 622FX/59\t       15880 Nm
''';

List<({String model, int torque})> _parseRaw() {
  final re = RegExp(r'^\s*(.+?)\s+(\d+)\s*Nm\s*$');
  return [
    for (final line in _rawTable.trim().split('\n'))
      (
        model: re.firstMatch(line)!.group(1)!.trim(),
        torque: int.parse(re.firstMatch(line)!.group(2)!),
      ),
  ];
}

void main() {
  test('şanzıman tork verisi kullanıcının tablosuyla aynı (sıra dahil)', () {
    final expected = _parseRaw();
    expect(expected.length, 28);
    expect(gearboxTorques.length, expected.length);
    for (var i = 0; i < expected.length; i++) {
      expect(gearboxTorques[i].model, expected[i].model, reason: 'satır $i');
      expect(gearboxTorques[i].maxTorqueNm, expected[i].torque, reason: expected[i].model);
    }
  });

  test('şanzıman tipleri benzersizdir ve arama doğru çalışır', () {
    expect(gearboxTorqueModels.toSet().length, gearboxTorqueModels.length);
    expect(gearboxTorqueFor('ZS619LX/59')!.maxTorqueNm, 10400);
    expect(gearboxTorqueFor('DESCH ZG50 - İ:80/1')!.maxTorqueNm, 50000);
    expect(gearboxTorqueFor('ZS 617/25')!.maxTorqueNm, 3150); // baştaki boşluk atılmış
    expect(gearboxTorqueFor('YOK-TİP'), isNull);
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
