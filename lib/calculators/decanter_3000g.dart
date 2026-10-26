import '../format.dart';

/// POLAT dekantör modelleri için 3000G kontrol verisi ve kuralları.
///
/// Veri ve kurallar, "DEKANTÖRLER İÇİN 3000G KONTROL EKRANI" HTML sayfasından
/// aynen alınmıştır. Model verisi sayfanın veri tablosundan üretilmiştir.

/// Tambur dayanımı (Sb) için gereken en küçük değer.
const double minStrengthSb = 1.5;

/// Tambur dayanımı (Sf) için gereken en küçük değer.
const double minStrengthSf = 1.3;

class Decanter3000gModel {
  const Decanter3000gModel({
    required this.model,
    required this.maxRpm,
    required this.currentG,
    required this.targetRpm,
    required this.rearBearingRpm,
    required this.rearBearingName,
    required this.gearboxLargestRpm,
    required this.gearboxLargestModel,
    required this.gearboxCommonRpm,
    required this.gearboxCommonModel,
    required this.strengthSb,
    required this.strengthSf,
  });

  final String model;

  /// Maksimum çalışma devri (rpm).
  final int maxRpm;

  /// Maksimum devirdeki mevcut G kuvveti.
  final int currentG;

  /// 3000G için gereken devir (rpm). Model zaten 3000G'yi sağlıyorsa null.
  final int? targetRpm;

  /// Arka rulman referans hızı (rpm) ve rulman adı.
  final int rearBearingRpm;
  final String rearBearingName;

  /// En büyük şanzıman limiti (rpm) ve modeli.
  final int gearboxLargestRpm;
  final String gearboxLargestModel;

  /// Yaygın şanzıman limiti (rpm) ve modeli.
  final int gearboxCommonRpm;
  final String gearboxCommonModel;

  /// Tambur dayanımı Sb ve Sf. 0 ise bu model için değer yoktur.
  final double strengthSb;
  final double strengthSf;
}

const List<Decanter3000gModel> decanter3000gModels = [
  Decanter3000gModel(
    model: 'S200',
    maxRpm: 5300,
    currentG: 3140,
    targetRpm: null,
    rearBearingRpm: 6700,
    rearBearingName: 'RULMAN 2212 FAGNU ECML C3',
    gearboxLargestRpm: 7400,
    gearboxLargestModel: 'ZS612/87',
    gearboxCommonRpm: 7400,
    gearboxCommonModel: 'ZS612/87',
    strengthSb: 0,
    strengthSf: 0,
  ),
  Decanter3000gModel(
    model: 'S300',
    maxRpm: 4300,
    currentG: 3101,
    targetRpm: null,
    rearBearingRpm: 4800,
    rearBearingName: 'RULMAN 314 NU ECM/C3',
    gearboxLargestRpm: 6500,
    gearboxLargestModel: 'ZSPN614/105',
    gearboxCommonRpm: 5600,
    gearboxCommonModel: 'ZS614/87',
    strengthSb: 0,
    strengthSf: 0,
  ),
  Decanter3000gModel(
    model: 'S350',
    maxRpm: 3850,
    currentG: 2933,
    targetRpm: null,
    rearBearingRpm: 4000,
    rearBearingName: 'RULMAN 220 NU ECML/C3',
    gearboxLargestRpm: 4450,
    gearboxLargestModel: 'ZSPN617/129',
    gearboxCommonRpm: 4250,
    gearboxCommonModel: 'ZS616/87',
    strengthSb: 0,
    strengthSf: 0,
  ),
  Decanter3000gModel(
    model: 'S430',
    maxRpm: 3100,
    currentG: 2310,
    targetRpm: 3533,
    rearBearingRpm: 3600,
    rearBearingName: 'RULMAN 222 NU ECM/C3',
    gearboxLargestRpm: 3500,
    gearboxLargestModel: 'ZSPN619/129',
    gearboxCommonRpm: 4450,
    gearboxCommonModel: 'ZSPN617/129',
    strengthSb: 2.01,
    strengthSf: 2.11,
  ),
  Decanter3000gModel(
    model: 'S470',
    maxRpm: 3100,
    currentG: 2525,
    targetRpm: 3379,
    rearBearingRpm: 3600,
    rearBearingName: 'RULMAN 222 NU ECM/C3',
    gearboxLargestRpm: 3000,
    gearboxLargestModel: 'ZSPN621/129',
    gearboxCommonRpm: 3500,
    gearboxCommonModel: 'ZSPN619/129',
    strengthSb: 2.02,
    strengthSf: 2.12,
  ),
  Decanter3000gModel(
    model: 'S530',
    maxRpm: 2800,
    currentG: 2323,
    targetRpm: 3182,
    rearBearingRpm: 2800,
    rearBearingName: 'RULMAN 228 NU ECML/C3',
    gearboxLargestRpm: 3000,
    gearboxLargestModel: 'ZSPN621/129',
    gearboxCommonRpm: 3500,
    gearboxCommonModel: 'ZSPN619/129',
    strengthSb: 1.51,
    strengthSf: 1.59,
  ),
  Decanter3000gModel(
    model: 'S570',
    maxRpm: 2600,
    currentG: 2154,
    targetRpm: 3069,
    rearBearingRpm: 2800,
    rearBearingName: 'RULMAN 228 NU ECML/C3',
    gearboxLargestRpm: 2800,
    gearboxLargestModel: 'ZSPN622/129',
    gearboxCommonRpm: 3000,
    gearboxCommonModel: 'ZSPN621/129',
    strengthSb: 1.36,
    strengthSf: 1.43,
  ),
  Decanter3000gModel(
    model: 'SX650',
    maxRpm: 2300,
    currentG: 1922,
    targetRpm: 2873,
    rearBearingRpm: 3200,
    rearBearingName: 'RULMAN NU2226 ECM C3',
    gearboxLargestRpm: 2600,
    gearboxLargestModel: 'ZSPN623/129',
    gearboxCommonRpm: 2800,
    gearboxCommonModel: 'ZSPN622/129',
    strengthSb: 1.09,
    strengthSf: 1.14,
  ),
  Decanter3000gModel(
    model: 'S670',
    maxRpm: 2100,
    currentG: 1706,
    targetRpm: 2785,
    rearBearingRpm: 2400,
    rearBearingName: 'RULMAN 232 NU ECLM C3',
    gearboxLargestRpm: 2190,
    gearboxLargestModel: 'ZSPN625/129',
    gearboxCommonRpm: 2190,
    gearboxCommonModel: 'ZSPN625/129',
    strengthSb: 1.02,
    strengthSf: 1.07,
  ),
  Decanter3000gModel(
    model: 'SX840',
    maxRpm: 2100,
    currentG: 2058,
    targetRpm: 2535,
    rearBearingRpm: 1900,
    rearBearingName: 'RULMAN NUP 240 ECM',
    gearboxLargestRpm: 2190,
    gearboxLargestModel: 'ZSPN625/129',
    gearboxCommonRpm: 2190,
    gearboxCommonModel: 'ZSPN625/129',
    strengthSb: 1.01,
    strengthSf: 1.06,
  ),
  Decanter3000gModel(
    model: 'SX920',
    maxRpm: 1700,
    currentG: 1486,
    targetRpm: 2415,
    rearBearingRpm: 1600,
    rearBearingName: 'RULMAN NU240 E.M1A.C3',
    gearboxLargestRpm: 2100,
    gearboxLargestModel: 'DESCH ZG50',
    gearboxCommonRpm: 2100,
    gearboxCommonModel: 'DESCH ZG50',
    strengthSb: 1.13,
    strengthSf: 1.18,
  ),
];

/// Kontrol türü: hız limiti ya da tambur dayanımı. Başarısızlık mesajını belirler.
enum Decanter3000gCheckKind { speedLimit, strength }

class Decanter3000gCheck {
  const Decanter3000gCheck({
    required this.title,
    required this.valueText,
    required this.detail,
    required this.passed,
    required this.kind,
  });

  final String title;
  final String valueText;
  final String detail;
  final bool passed;
  final Decanter3000gCheckKind kind;

  /// Başarısız kontrolde gösterilecek uyarı.
  String get failureLabel =>
      kind == Decanter3000gCheckKind.speedLimit ? 'Yetersiz!' : 'Riskli!';
}

class Decanter3000gAnalysis {
  const Decanter3000gAnalysis({
    required this.model,
    required this.meets3000gAlready,
    required this.maxRpm,
    required this.dynamicLabel,
    required this.dynamicValue,
    required this.dynamicUnit,
    required this.checks,
  });

  final Decanter3000gModel model;

  /// Mevcut çalışma devri 3000G'yi zaten sağlıyor mu (hedef devir yok).
  final bool meets3000gAlready;
  final int maxRpm;
  final String dynamicLabel;
  final int dynamicValue;
  final String dynamicUnit;
  final List<Decanter3000gCheck> checks;
}

/// Seçilen model için 3000G kontrolünü yapar.
///
/// Model 3000G'yi zaten sağlıyorsa hız limitleri mevcut maksimum devirle,
/// aksi halde 3000G için gereken hedef devirle karşılaştırılır.
/// Limit, karşılaştırılan devirden küçük değilse (>=) kontrol geçer.
/// Tambur dayanımı: Sb en az 1,5; Sf en az 1,3.
Decanter3000gAnalysis analyze3000g(Decanter3000gModel m) {
  final target = m.targetRpm;
  final meetsAlready = target == null;
  final compareRpm = target ?? m.maxRpm;

  String rpm(int v) => '${formatNumber(v.toDouble(), decimals: 0)} rpm';

  final checks = <Decanter3000gCheck>[
    Decanter3000gCheck(
      title: 'Arka Rulman Referans Hızı',
      valueText: rpm(m.rearBearingRpm),
      detail: m.rearBearingName,
      passed: m.rearBearingRpm >= compareRpm,
      kind: Decanter3000gCheckKind.speedLimit,
    ),
    Decanter3000gCheck(
      title: 'En Büyük Şanzıman Limiti',
      valueText: rpm(m.gearboxLargestRpm),
      detail: 'Model: ${m.gearboxLargestModel}',
      passed: m.gearboxLargestRpm >= compareRpm,
      kind: Decanter3000gCheckKind.speedLimit,
    ),
    Decanter3000gCheck(
      title: 'Yaygın Şanzıman Limiti',
      valueText: rpm(m.gearboxCommonRpm),
      detail: 'Model: ${m.gearboxCommonModel}',
      passed: m.gearboxCommonRpm >= compareRpm,
      kind: Decanter3000gCheckKind.speedLimit,
    ),
    if (m.strengthSb > 0)
      Decanter3000gCheck(
        title: 'Tambur Dayanımı (Sb)',
        valueText: formatNumber(m.strengthSb, decimals: 2),
        detail: 'Min Gereken: ${formatNumber(minStrengthSb, decimals: 1)}',
        passed: m.strengthSb >= minStrengthSb,
        kind: Decanter3000gCheckKind.strength,
      ),
    if (m.strengthSf > 0)
      Decanter3000gCheck(
        title: 'Tambur Dayanımı (Sf)',
        valueText: formatNumber(m.strengthSf, decimals: 2),
        detail: 'Min Gereken: ${formatNumber(minStrengthSf, decimals: 1)}',
        passed: m.strengthSf >= minStrengthSf,
        kind: Decanter3000gCheckKind.strength,
      ),
  ];

  return Decanter3000gAnalysis(
    model: m,
    meets3000gAlready: meetsAlready,
    maxRpm: m.maxRpm,
    dynamicLabel: meetsAlready ? 'Mevcut G Kuvveti' : 'Hedef 3000G Devri',
    dynamicValue: target ?? m.currentG,
    dynamicUnit: meetsAlready ? 'G' : 'rpm',
    checks: checks,
  );
}
