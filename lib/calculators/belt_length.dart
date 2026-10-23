import 'dart:math' as math;

import 'validation.dart';

/// Açık kayış-kasnak sistemi için tahmini kayış uzunluğu (mm).
///
/// L = 2C + π(D + d)/2 + (D − d)² / (4C); D büyük, d küçük kasnak çapı.
double openBeltLengthMm({
  required double pulleyAMm,
  required double pulleyBMm,
  required double centerDistanceMm,
}) {
  requirePositive(pulleyAMm, 'Motor kasnağı çapı');
  requirePositive(pulleyBMm, 'Tahrik edilen kasnak çapı');
  requirePositive(centerDistanceMm, 'Eksenler arası mesafe');
  final big = math.max(pulleyAMm, pulleyBMm);
  final small = math.min(pulleyAMm, pulleyBMm);
  if (centerDistanceMm <= (big - small) / 2) {
    throw const CalculationException(
      'Eksenler arası mesafe, kasnak çapları farkının yarısından büyük olmalıdır.',
    );
  }
  final difference = big - small;
  return 2 * centerDistanceMm +
      math.pi * (big + small) / 2 +
      difference * difference / (4 * centerDistanceMm);
}

double mmToInches(double mm) => mm / 25.4;

double mmToFeet(double mm) => mm / 304.8;

/// Dar profilli V-kayışlar için olası katalog kodu.
///
/// 3V/5V/8V (ve X'li sürümleri) kayışlarda kod, dış uzunluğun inçin onda biri
/// cinsinden değeridir (ör. 5V1000 = 100 inç). A/B/C profillerinde numaralandırma
/// üreticiye göre değiştiği için kod üretilmez (null döner).
String? possibleBeltDesignation(String profile, double lengthMm) {
  const narrowProfiles = {'3V', '3VX', '5V', '5VX', '8V', '8VX'};
  if (!narrowProfiles.contains(profile)) {
    return null;
  }
  final tenthsOfInch = (mmToInches(lengthMm) * 10).round();
  return '$profile$tenthsOfInch';
}
