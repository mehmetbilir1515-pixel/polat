/// Helezon (scroll) rulmanı yağlama bilgisi.
///
/// Veri, "Rulman Yağlama Bilgisi" HTML sayfasındaki tablolardan (Endüstriyel ve
/// Zeytinyağı sekmeleri) birebir üretilmiştir. Bu sayfadaki başlıklar
/// "dekantörlerin helezon rulmanları" olduğundan veri helezon rulmanı için kullanılır.

/// Bir rulmanın konumu, yağ miktarı ve ölçüleri (endüstriyel dekantörler).
class ScrollBearingPosition {
  const ScrollBearingPosition({
    required this.position,
    required this.greaseG,
    required this.shots,
    required this.type,
    required this.code,
    required this.outerMm,
    required this.innerMm,
    required this.widthMm,
  });

  /// "Arka" veya "Ön".
  final String position;

  /// Yağ miktarı (g).
  final double greaseG;

  /// Manuel gres pompası ile basım sayısı.
  final int shots;

  final String type;
  final String code;
  final double outerMm;
  final double innerMm;
  final double widthMm;
}

/// Endüstriyel dekantör modeli: iki rulman ve toplam yağ miktarı.
class IndustrialScrollLubrication {
  const IndustrialScrollLubrication({
    required this.model,
    required this.totalG,
    required this.bearings,
  });

  final String model;

  /// Her iki rulmanın toplam yağ miktarı (g).
  final double totalG;

  final List<ScrollBearingPosition> bearings;
}

/// Zeytinyağı dekantör modeli: tek rulman için re-greasing bilgisi.
class OliveOilScrollLubrication {
  const OliveOilScrollLubrication({
    required this.model,
    required this.regreaseG,
    required this.shots,
    required this.type,
    required this.code,
    required this.outerMm,
    required this.innerMm,
    required this.widthMm,
  });

  final String model;

  /// Re-greasing miktarı (g).
  final double regreaseG;

  /// Manuel gres pompası ile basım sayısı.
  final int shots;

  final String type;
  final String code;
  final double outerMm;
  final double innerMm;
  final double widthMm;
}

/// SKF Türkiye sitesinde rulman tipini arayan adres (HTML'deki "SKF'te Ara").
String skfSearchUrl(String bearingType) {
  return 'https://www.skf.com/tr/search-results.html?q=${Uri.encodeComponent(bearingType)}';
}

const List<IndustrialScrollLubrication> industrialScrollLubrication = [
  IndustrialScrollLubrication(
    model: 'S200',
    totalG: 20.41,
    bearings: [
      ScrollBearingPosition(
        position: 'Arka',
        greaseG: 13.59,
        shots: 9,
        type: '3210-A/C3',
        code: '150030010491',
        outerMm: 90.0,
        innerMm: 50.0,
        widthMm: 30.2,
      ),
      ScrollBearingPosition(
        position: 'Ön',
        greaseG: 6.82,
        shots: 4,
        type: '4908 NA',
        code: '150030010293',
        outerMm: 62.0,
        innerMm: 40.0,
        widthMm: 22.0,
      ),
    ],
  ),
  IndustrialScrollLubrication(
    model: 'S300',
    totalG: 37.82,
    bearings: [
      ScrollBearingPosition(
        position: 'Arka',
        greaseG: 29.9,
        shots: 19,
        type: '4312 ATN9',
        code: '150030010526',
        outerMm: 130.0,
        innerMm: 60.0,
        widthMm: 46.0,
      ),
      ScrollBearingPosition(
        position: 'Ön',
        greaseG: 7.92,
        shots: 5,
        type: '4910 NA',
        code: '150030010488',
        outerMm: 72.0,
        innerMm: 50.0,
        widthMm: 22.0,
      ),
    ],
  ),
  IndustrialScrollLubrication(
    model: 'S350',
    totalG: 58.42,
    bearings: [
      ScrollBearingPosition(
        position: 'Arka',
        greaseG: 41.92,
        shots: 27,
        type: '3218 A',
        code: '150030010868',
        outerMm: 160.0,
        innerMm: 90.0,
        widthMm: 52.4,
      ),
      ScrollBearingPosition(
        position: 'Ön',
        greaseG: 16.5,
        shots: 11,
        type: '4916 NA',
        code: '150030010443',
        outerMm: 110.0,
        innerMm: 80.0,
        widthMm: 30.0,
      ),
    ],
  ),
  IndustrialScrollLubrication(
    model: 'S430',
    totalG: 82.27,
    bearings: [
      ScrollBearingPosition(
        position: 'Arka',
        greaseG: 54.27,
        shots: 35,
        type: '3220 A',
        code: '150030010891',
        outerMm: 180.0,
        innerMm: 100.0,
        widthMm: 60.3,
      ),
      ScrollBearingPosition(
        position: 'Ön',
        greaseG: 28.0,
        shots: 18,
        type: '4920 NA',
        code: '150030010890',
        outerMm: 140.0,
        innerMm: 100.0,
        widthMm: 40.0,
      ),
    ],
  ),
  IndustrialScrollLubrication(
    model: 'S470',
    totalG: 97.8,
    bearings: [
      ScrollBearingPosition(
        position: 'Arka',
        greaseG: 69.8,
        shots: 45,
        type: '3222 A/C3',
        code: '150030010036',
        outerMm: 200.0,
        innerMm: 110.0,
        widthMm: 69.8,
      ),
      ScrollBearingPosition(
        position: 'Ön',
        greaseG: 28.0,
        shots: 18,
        type: '4920 NA',
        code: '150030010890',
        outerMm: 140.0,
        innerMm: 100.0,
        widthMm: 40.0,
      ),
    ],
  ),
  IndustrialScrollLubrication(
    model: 'S530',
    totalG: 99.8,
    bearings: [
      ScrollBearingPosition(
        position: 'Arka',
        greaseG: 69.8,
        shots: 45,
        type: '3222 A/C3',
        code: '150030010036',
        outerMm: 200.0,
        innerMm: 110.0,
        widthMm: 69.8,
      ),
      ScrollBearingPosition(
        position: 'Ön',
        greaseG: 30.0,
        shots: 20,
        type: '4922 NA',
        code: '150030010961',
        outerMm: 150.0,
        innerMm: 110.0,
        widthMm: 40.0,
      ),
    ],
  ),
  IndustrialScrollLubrication(
    model: 'S570',
    totalG: 99.8,
    bearings: [
      ScrollBearingPosition(
        position: 'Arka',
        greaseG: 69.8,
        shots: 45,
        type: '3222 A/C3',
        code: '150030010036',
        outerMm: 200.0,
        innerMm: 110.0,
        widthMm: 69.8,
      ),
      ScrollBearingPosition(
        position: 'Ön',
        greaseG: 30.0,
        shots: 20,
        type: '4922 NA',
        code: '150030010961',
        outerMm: 150.0,
        innerMm: 110.0,
        widthMm: 40.0,
      ),
    ],
  ),
  IndustrialScrollLubrication(
    model: 'SX650',
    totalG: 73.0,
    bearings: [
      ScrollBearingPosition(
        position: 'Ön',
        greaseG: 43.0,
        shots: 28,
        type: 'QJ224 N2 MA',
        code: '150030011711',
        outerMm: 215.0,
        innerMm: 120.0,
        widthMm: 40.0,
      ),
      ScrollBearingPosition(
        position: 'Arka',
        greaseG: 30.0,
        shots: 20,
        type: '4922 NA',
        code: '150030010961',
        outerMm: 150.0,
        innerMm: 110.0,
        widthMm: 40.0,
      ),
    ],
  ),
  IndustrialScrollLubrication(
    model: 'S670',
    totalG: 117.2,
    bearings: [
      ScrollBearingPosition(
        position: 'Ön',
        greaseG: 25.2,
        shots: 16,
        type: '1024 NU ML',
        code: '150030010898',
        outerMm: 180.0,
        innerMm: 120.0,
        widthMm: 28.0,
      ),
      ScrollBearingPosition(
        position: 'Arka',
        greaseG: 92.0,
        shots: 60,
        type: '7226 BCBM',
        code: '150030010897',
        outerMm: 230.0,
        innerMm: 130.0,
        widthMm: 40.0,
      ),
    ],
  ),
];

const List<OliveOilScrollLubrication> oliveOilScrollLubrication = [
  OliveOilScrollLubrication(
    model: 'PX5',
    regreaseG: 20.075,
    shots: 13,
    type: '3212 A',
    code: '150030010292',
    outerMm: 110.0,
    innerMm: 60.0,
    widthMm: 36.5,
  ),
  OliveOilScrollLubrication(
    model: 'PX10',
    regreaseG: 20.075,
    shots: 13,
    type: '3212 A',
    code: '150030010292',
    outerMm: 110.0,
    innerMm: 60.0,
    widthMm: 36.5,
  ),
  OliveOilScrollLubrication(
    model: 'PX20',
    regreaseG: 41.92,
    shots: 27,
    type: '3218 A',
    code: '150030010868',
    outerMm: 160.0,
    innerMm: 90.0,
    widthMm: 52.4,
  ),
  OliveOilScrollLubrication(
    model: 'PX30',
    regreaseG: 41.92,
    shots: 27,
    type: '3218 A',
    code: '150030010868',
    outerMm: 160.0,
    innerMm: 90.0,
    widthMm: 52.4,
  ),
  OliveOilScrollLubrication(
    model: 'PX40',
    regreaseG: 69.8,
    shots: 45,
    type: '3222 A/C3',
    code: '150030010036',
    outerMm: 200.0,
    innerMm: 110.0,
    widthMm: 69.8,
  ),
  OliveOilScrollLubrication(
    model: 'PXZ40',
    regreaseG: 41.92,
    shots: 27,
    type: '3218 A',
    code: '150030010868',
    outerMm: 160.0,
    innerMm: 90.0,
    widthMm: 52.4,
  ),
  OliveOilScrollLubrication(
    model: 'PXZ60',
    regreaseG: 51.0,
    shots: 33,
    type: '24022 CC W33',
    code: '150030011446',
    outerMm: 170.0,
    innerMm: 110.0,
    widthMm: 60.0,
  ),
  OliveOilScrollLubrication(
    model: 'PXZ80',
    regreaseG: 51.0,
    shots: 33,
    type: '24022 CC W33',
    code: '150030011446',
    outerMm: 170.0,
    innerMm: 110.0,
    widthMm: 60.0,
  ),
  OliveOilScrollLubrication(
    model: 'PXZ100',
    regreaseG: 51.0,
    shots: 33,
    type: '24022 CC W33',
    code: '150030011446',
    outerMm: 170.0,
    innerMm: 110.0,
    widthMm: 60.0,
  ),
  OliveOilScrollLubrication(
    model: 'PXZ160',
    regreaseG: 69.8,
    shots: 45,
    type: '3222 A/C3',
    code: '150030010036',
    outerMm: 200.0,
    innerMm: 110.0,
    widthMm: 69.8,
  ),
  OliveOilScrollLubrication(
    model: 'PXZ250',
    regreaseG: 69.8,
    shots: 45,
    type: '3222 A/C3',
    code: '150030010036',
    outerMm: 200.0,
    innerMm: 110.0,
    widthMm: 69.8,
  ),
  OliveOilScrollLubrication(
    model: 'PXZ500',
    regreaseG: 69.8,
    shots: 45,
    type: '3222 A/C3',
    code: '150030010036',
    outerMm: 200.0,
    innerMm: 110.0,
    widthMm: 69.8,
  ),
];
