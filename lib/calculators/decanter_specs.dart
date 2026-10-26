/// POLAT dekantör modellerinin temel çalışma değerleri (kullanıcının tablosundan).
class DecanterSpec {
  const DecanterSpec({
    required this.model,
    required this.maxOperatingRpm,
    required this.maxBowlRpm,
    required this.hydraulicMinM3h,
    required this.hydraulicMaxM3h,
  });

  final String model;

  /// Maksimum çalışma devri (rpm).
  final int maxOperatingRpm;

  /// Maksimum gövde devri (rpm).
  final int maxBowlRpm;

  /// Hidrolik kapasite aralığı (m³/saat).
  final int hydraulicMinM3h;
  final int hydraulicMaxM3h;

  /// Hidrolik kapasite aralığı metni, örn. "70-100".
  String get hydraulicRangeText => '$hydraulicMinM3h-$hydraulicMaxM3h';
}

const List<DecanterSpec> decanterSpecs = [
  DecanterSpec(
    model: 'S200',
    maxOperatingRpm: 5300,
    maxBowlRpm: 5500,
    hydraulicMinM3h: 1,
    hydraulicMaxM3h: 6,
  ),
  DecanterSpec(
    model: 'S300',
    maxOperatingRpm: 4300,
    maxBowlRpm: 4500,
    hydraulicMinM3h: 6,
    hydraulicMaxM3h: 15,
  ),
  DecanterSpec(
    model: 'S350',
    maxOperatingRpm: 3850,
    maxBowlRpm: 4200,
    hydraulicMinM3h: 15,
    hydraulicMaxM3h: 25,
  ),
  DecanterSpec(
    model: 'S430',
    maxOperatingRpm: 3100,
    maxBowlRpm: 3500,
    hydraulicMinM3h: 25,
    hydraulicMaxM3h: 35,
  ),
  DecanterSpec(
    model: 'S470',
    maxOperatingRpm: 3100,
    maxBowlRpm: 3300,
    hydraulicMinM3h: 35,
    hydraulicMaxM3h: 45,
  ),
  DecanterSpec(
    model: 'S530',
    maxOperatingRpm: 2800,
    maxBowlRpm: 3000,
    hydraulicMinM3h: 40,
    hydraulicMaxM3h: 50,
  ),
  DecanterSpec(
    model: 'S570',
    maxOperatingRpm: 2600,
    maxBowlRpm: 2800,
    hydraulicMinM3h: 50,
    hydraulicMaxM3h: 70,
  ),
  DecanterSpec(
    model: 'SX650',
    maxOperatingRpm: 2300,
    maxBowlRpm: 2500,
    hydraulicMinM3h: 70,
    hydraulicMaxM3h: 100,
  ),
  DecanterSpec(
    model: 'S670',
    maxOperatingRpm: 2100,
    maxBowlRpm: 2300,
    hydraulicMinM3h: 80,
    hydraulicMaxM3h: 110,
  ),
];
