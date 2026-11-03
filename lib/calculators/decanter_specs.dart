/// Katı çıkış çapı ve helezon boru çapı (mm). Bazı modeller 10° ve 15° konik
/// açılı iki ayrı yapıda üretilir; bu durumda her açı için ayrı bir kayıt bulunur.
class DiameterSet {
  const DiameterSet({
    this.angleDeg,
    required this.solidsOutletMm,
    required this.scrollPipeMm,
  });

  /// Konik açı (10 veya 15); modelde tek yapı varsa null.
  final int? angleDeg;

  /// Katı çıkış çapı (mm).
  final double solidsOutletMm;

  /// Helezon boru çapı (mm).
  final double scrollPipeMm;
}

/// POLAT dekantör modellerinin temel çalışma değerleri (kullanıcının tablosundan).
class DecanterSpec {
  const DecanterSpec({
    required this.model,
    required this.maxOperatingRpm,
    required this.maxBowlRpm,
    required this.hydraulicMinM3h,
    required this.hydraulicMaxM3h,
    required this.diameters,
  });

  final String model;

  /// Maksimum çalışma devri (rpm).
  final int maxOperatingRpm;

  /// Maksimum gövde devri (rpm).
  final int maxBowlRpm;

  /// Hidrolik kapasite aralığı (m³/saat).
  final int hydraulicMinM3h;
  final int hydraulicMaxM3h;

  /// Katı çıkış ve helezon boru çapları; 10°/15° olan modellerde iki kayıt.
  final List<DiameterSet> diameters;

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
    diameters: [
      DiameterSet(solidsOutletMm: 117.8, scrollPipeMm: 112.0),
    ],
  ),
  DecanterSpec(
    model: 'S300',
    maxOperatingRpm: 4300,
    maxBowlRpm: 4500,
    hydraulicMinM3h: 6,
    hydraulicMaxM3h: 15,
    diameters: [
      DiameterSet(solidsOutletMm: 175.5, scrollPipeMm: 150.0),
    ],
  ),
  DecanterSpec(
    model: 'S350',
    maxOperatingRpm: 3850,
    maxBowlRpm: 4200,
    hydraulicMinM3h: 15,
    hydraulicMaxM3h: 25,
    diameters: [
      DiameterSet(solidsOutletMm: 211.0, scrollPipeMm: 198.0),
    ],
  ),
  DecanterSpec(
    model: 'S430',
    maxOperatingRpm: 3100,
    maxBowlRpm: 3500,
    hydraulicMinM3h: 25,
    hydraulicMaxM3h: 35,
    diameters: [
      DiameterSet(solidsOutletMm: 262.0, scrollPipeMm: 228.0),
    ],
  ),
  DecanterSpec(
    model: 'S470',
    maxOperatingRpm: 3100,
    maxBowlRpm: 3300,
    hydraulicMinM3h: 35,
    hydraulicMaxM3h: 45,
    diameters: [
      DiameterSet(angleDeg: 10, solidsOutletMm: 277.6, scrollPipeMm: 238.0),
      DiameterSet(angleDeg: 15, solidsOutletMm: 225.6, scrollPipeMm: 230.0),
    ],
  ),
  DecanterSpec(
    model: 'S530',
    maxOperatingRpm: 2800,
    maxBowlRpm: 3000,
    hydraulicMinM3h: 40,
    hydraulicMaxM3h: 50,
    diameters: [
      DiameterSet(angleDeg: 10, solidsOutletMm: 302.0, scrollPipeMm: 285.0),
      DiameterSet(angleDeg: 15, solidsOutletMm: 254.5, scrollPipeMm: 244.0),
    ],
  ),
  DecanterSpec(
    model: 'S570',
    maxOperatingRpm: 2600,
    maxBowlRpm: 2800,
    hydraulicMinM3h: 50,
    hydraulicMaxM3h: 70,
    diameters: [
      DiameterSet(angleDeg: 10, solidsOutletMm: 327.6, scrollPipeMm: 320.0),
      DiameterSet(angleDeg: 15, solidsOutletMm: 273.6, scrollPipeMm: 244.0),
    ],
  ),
  DecanterSpec(
    model: 'SX650',
    maxOperatingRpm: 2300,
    maxBowlRpm: 2500,
    hydraulicMinM3h: 70,
    hydraulicMaxM3h: 100,
    diameters: [
      DiameterSet(angleDeg: 10, solidsOutletMm: 360.0, scrollPipeMm: 300.0),
      DiameterSet(angleDeg: 15, solidsOutletMm: 302.0, scrollPipeMm: 300.0),
    ],
  ),
  DecanterSpec(
    model: 'S670',
    maxOperatingRpm: 2100,
    maxBowlRpm: 2300,
    hydraulicMinM3h: 80,
    hydraulicMaxM3h: 110,
    diameters: [
      DiameterSet(angleDeg: 10, solidsOutletMm: 402.0, scrollPipeMm: 353.0),
    ],
  ),
];
